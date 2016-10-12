//
//  ViewController.m
//  PathTest
//
//  Created by alexanderbollbach on 11/1/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "OrbTrackView.h"
#import "UIBezierPath+forEachElement.h"

@interface OrbTrackView ()

@end

@implementation OrbTrackView {
   UIBezierPath *path_;
   CAShapeLayer *pathLayer_;
   NSMutableData *pathPointsData_;
   CGPoint const *pathPoints_;
   NSInteger pathPointsCount_;
//   UIView *testView;
   NSInteger handlePathPointIndex_;
   CGPoint desiredHandleCenter_;
}

- (instancetype)initWithFrame:(CGRect)frame andHandleView:(UIView*)view {
   if (self = [super initWithFrame:frame]) {

        [self initPathLayer];
        self.testView = view;

        [self initHandleViewWithView];
        [self initHandlePanGestureRecognizer];
   
   
   }
   return self;
}


- (void)initPathLayer {
   pathLayer_ = [CAShapeLayer layer];
   pathLayer_.lineWidth = 1;
   pathLayer_.fillColor = nil;
   pathLayer_.strokeColor = [UIColor clearColor].CGColor;
   pathLayer_.lineCap = kCALineCapButt;
   pathLayer_.lineJoin = kCALineJoinRound;
   [self.layer addSublayer:pathLayer_];
}

- (void)createPathFromPoint:(CGPoint)from toPoint:(CGPoint)to {
     
     path_ = [UIBezierPath bezierPath];
    // CGFloat offset = self.bounds.size.width / 8;
     [path_ moveToPoint:CGPointMake(from.x, from.y)];
     [path_ addLineToPoint:CGPointMake(to.x, to.y)];
     
     [path_ closePath];
     [self createPathPoints];
     [self layoutPathLayer];
     [self layoutHandleView];
}


- (void)initHandleViewWithView {
   handlePathPointIndex_ = 0;

   [self addSubview:self.testView];
}

- (void)initHandlePanGestureRecognizer {
   UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleWasPanned:)];
   [self.testView addGestureRecognizer:recognizer];
}

- (void)layoutSubviews {
 //  [self createPath];

}

- (void)layoutHandleView {
   // Make sure the index is in bounds.
   handlePathPointIndex_ = [self handlePathPointIndexWithOffset:0];
   
   self.testView.center = [pathLayer_ convertPoint:pathPoints_[handlePathPointIndex_] toLayer:self.layer];
}



static CGPoint *lastPointOfPathElement(CGPathElement const *element) {
   int index;
   switch (element->type) {
      case kCGPathElementMoveToPoint: index = 0; break;
      case kCGPathElementAddCurveToPoint: index = 2; break;
      case kCGPathElementAddLineToPoint: index = 0; break;
      case kCGPathElementAddQuadCurveToPoint: index = 1; break;
      case kCGPathElementCloseSubpath: index = NSNotFound; break;
   }
   return index == NSNotFound ? 0 : &element->points[index];
}

- (void)createPathPoints {
   
     
     CGPathRef cgDashedPath = CGPathCreateCopyByDashingPath(path_.CGPath,
                                                            NULL,
                                                            0,
                                                            (CGFloat[]){ 1.0f, 1.0f },
                                                            2);
   UIBezierPath *dashedPath = [UIBezierPath bezierPathWithCGPath:cgDashedPath];
   CGPathRelease(cgDashedPath);
   
   static CGFloat const kMinimumDistance = 0.1f;
   
   __block CGPoint priorPoint = { HUGE_VALF, HUGE_VALF };
   
   pathPointsData_ = [[NSMutableData alloc] init];
   
   [dashedPath forEachElement:^(const CGPathElement *element) {
      CGPoint *p = lastPointOfPathElement(element);
      if (!p)
         return;
      if (hypotf(p->x - priorPoint.x, p->y - priorPoint.y) < kMinimumDistance)
         return;
      [pathPointsData_ appendBytes:p length:sizeof *p];
      priorPoint = *p;
   }];
   
   pathPoints_ = (CGPoint const *)pathPointsData_.bytes;
   pathPointsCount_ = pathPointsData_.length / sizeof *pathPoints_;
   
   if (pathPointsCount_ > 1 && hypotf(pathPoints_[0].x - priorPoint.x, pathPoints_[0].y - priorPoint.y) < kMinimumDistance) {
      pathPointsCount_ -= 1;
   }
}

- (void)layoutPathLayer {
   pathLayer_.path = path_.CGPath;
   pathLayer_.frame = self.bounds;
}

- (void)handleWasPanned:(UIPanGestureRecognizer *)recognizer {
   switch (recognizer.state) {
      case UIGestureRecognizerStateBegan: {
         desiredHandleCenter_ = self.testView.center;
         break;
      }
      case UIGestureRecognizerStateChanged:
      case UIGestureRecognizerStateEnded:
      case UIGestureRecognizerStateCancelled: {
         CGPoint translation = [recognizer translationInView:self];
         desiredHandleCenter_.x += translation.x;
         desiredHandleCenter_.y += translation.y;
         [self moveHandleTowardPoint:desiredHandleCenter_];
         break;
      }
         
      default:
         break;
   }
   
   [recognizer setTranslation:CGPointZero inView:self];
}

- (void)moveHandleTowardPoint:(CGPoint)point {
   CGFloat earlierDistance = [self distanceToPoint:point ifHandleMovesByOffset:-1];
   CGFloat currentDistance = [self distanceToPoint:point ifHandleMovesByOffset:0];
   CGFloat laterDistance = [self distanceToPoint:point ifHandleMovesByOffset:1];
   if (currentDistance <= earlierDistance && currentDistance <= laterDistance)
      return;
   
   NSInteger direction;
   CGFloat distance;
   if (earlierDistance < laterDistance) {
      direction = -1;
      distance = earlierDistance;
   } else {
      direction = 1;
      distance = laterDistance;
   }
   
   NSInteger offset = direction;
   while (true) {
      NSInteger nextOffset = offset + direction;
      CGFloat nextDistance = [self distanceToPoint:point ifHandleMovesByOffset:nextOffset];
      if (nextDistance >= distance)
         break;
      distance = nextDistance;
      offset = nextOffset;
   }
   
   handlePathPointIndex_ += offset;
   [self layoutHandleView];
}

- (CGFloat)distanceToPoint:(CGPoint)point ifHandleMovesByOffset:(NSInteger)offset {
   int index = [self handlePathPointIndexWithOffset:offset];
   CGPoint proposedHandlePoint = pathPoints_[index];
   return hypotf(point.x - proposedHandlePoint.x, point.y - proposedHandlePoint.y);
}

- (NSInteger)handlePathPointIndexWithOffset:(NSInteger)offset {
   NSInteger index = handlePathPointIndex_ + offset;
   while (index < 0) {
      index += pathPointsCount_;
   }
   while (index >= pathPointsCount_) {
      index -= pathPointsCount_;
   }
   return index;
}

@end