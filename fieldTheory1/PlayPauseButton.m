//
//  PlayPauseButton.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/9/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "PlayPauseButton.h"
#import "Theme.h"

@implementation PlayPauseButton
-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
     
          self.playPauseLayer = [CAShapeLayer layer];
          [self.layer addSublayer:self.playPauseLayer];
          
          self.playPath = [UIBezierPath bezierPath];
          self.pausePath = [UIBezierPath bezierPath];

          // play path
          CGPoint point1 = CGPointMake(0,0);
          CGFloat point2X = CGRectGetWidth(self.bounds);
          CGFloat point2Y = CGRectGetHeight(self.bounds)/2;
          CGPoint point2 = CGPointMake(point2X, point2Y);
          CGFloat point3X = 0;
          CGFloat point3Y = CGRectGetHeight(self.bounds);
          CGPoint point3 = CGPointMake(point3X, point3Y);
          
          [self.playPath moveToPoint:point1];
          [self.playPath addLineToPoint:point2];
          [self.playPath addLineToPoint:point3];
          [self.playPath addLineToPoint:point1];
          
          // pause path
          CGPoint point1b = CGPointMake(0,0);
          CGFloat point2Xb = CGRectGetWidth(self.bounds);
          CGFloat point2Yb = 0;
          CGPoint point2b = CGPointMake(point2Xb, point2Yb);
          CGFloat point3Xb = CGRectGetWidth(self.bounds);
          CGFloat point3Yb = CGRectGetHeight(self.bounds);
          CGPoint point3b = CGPointMake(point3Xb, point3Yb);
          CGFloat point4Xb = 0;
          CGFloat point4Yb = CGRectGetHeight(self.bounds);
          CGPoint point4b = CGPointMake(point4Xb, point4Yb);
          
          [self.pausePath moveToPoint:point1b];
          [self.pausePath addLineToPoint:point2b];
          [self.pausePath addLineToPoint:point3b];
          [self.pausePath addLineToPoint:point4b];
          [self.pausePath addLineToPoint:point1b];

          self.playPauseLayer.path = self.playPath.CGPath;
       //   self.playPauseLayer.strokeColor = [UIColor whiteColor].CGColor;
          self.playPauseLayer.fillColor = [UIColor whiteColor].CGColor;
//          self.playPauseLayer.strokeColor = [Theme sharedTheme].bordersColor.CGColor;
//          self.playPauseLayer.lineWidth =
          self.playPauseLayer.strokeColor = [Theme sharedTheme].bordersColor.CGColor;
          self.playPauseLayer.lineWidth = [Theme sharedTheme].borderWidth;
     }
     return self;
}

- (void)animateTriToSquare {
     CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"path"];
     basicAni.fromValue = (__bridge id _Nullable)(self.playPauseLayer.path);
     basicAni.toValue = (__bridge id _Nullable)(self.pausePath.CGPath);
     basicAni.duration = 0.2;
     basicAni.removedOnCompletion = NO;
     basicAni.fillMode = kCAFillModeForwards;
     [self.playPauseLayer addAnimation:basicAni forKey:nil];
}

- (void)animateSquareToTri {
     CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"path"];
     basicAni.fromValue = (__bridge id _Nullable)((self.pausePath.CGPath));
     basicAni.toValue = (__bridge id _Nullable)(self.playPauseLayer.path);
     basicAni.duration = 0.2;
     basicAni.removedOnCompletion = NO;
     basicAni.fillMode = kCAFillModeForwards;
     [self.playPauseLayer addAnimation:basicAni forKey:nil];
}

@end
