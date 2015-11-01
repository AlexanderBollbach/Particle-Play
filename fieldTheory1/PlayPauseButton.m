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
          CGFloat point2Xb = CGRectGetWidth(self.bounds)/2;
          CGFloat point2Yb = 0;
          CGPoint point2b = CGPointMake(point2Xb, point2Yb);
          CGFloat point3Xb = CGRectGetWidth(self.bounds)/2;
          CGFloat point3Yb = CGRectGetHeight(self.bounds);
          CGPoint point3b = CGPointMake(point3Xb, point3Yb);
          CGFloat point4Xb = 0;
          CGFloat point4Yb = CGRectGetHeight(self.bounds);
          CGPoint point4b = CGPointMake(point4Xb, point4Yb);
          
          
          CGFloat point1xP = CGRectGetWidth(self.bounds)/2+2;
          CGFloat point1yP = 0;
          CGPoint point1bP = CGPointMake(point1xP,point1yP);
          CGFloat point2XbP = CGRectGetWidth(self.bounds);
          CGFloat point2YbP = 0;
          CGPoint point2bP = CGPointMake(point2XbP, point2YbP);
          CGFloat point3XbP = CGRectGetWidth(self.bounds);
          CGFloat point3YbP = CGRectGetHeight(self.bounds);
          CGPoint point3bP = CGPointMake(point3XbP, point3YbP);
          CGFloat point4XbP = CGRectGetWidth(self.bounds)/2+2;
          CGFloat point4YbP = CGRectGetHeight(self.bounds);
          CGPoint point4bP = CGPointMake(point4XbP, point4YbP);
          
          [self.pausePath moveToPoint:point1b];
          [self.pausePath addLineToPoint:point2b];
          [self.pausePath addLineToPoint:point3b];
          [self.pausePath addLineToPoint:point4b];
          [self.pausePath addLineToPoint:point1b];
          
          [self.pausePath moveToPoint:point1bP];
          [self.pausePath addLineToPoint:point2bP];
          [self.pausePath addLineToPoint:point3bP];
          [self.pausePath addLineToPoint:point4bP];
          [self.pausePath addLineToPoint:point1bP];
          

          self.playPauseLayer.path = self.playPath.CGPath;
          self.playPauseLayer.fillColor = [Theme sharedTheme].mainFillColor.CGColor;
          self.playPauseLayer.strokeColor = [Theme sharedTheme].bordersColor.CGColor;
          self.playPauseLayer.lineWidth = [Theme sharedTheme].borderWidth;
     }
     return self;
}


- (void)animatePlayToPause {
     CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"path"];
     basicAni.fromValue = (__bridge id _Nullable)(self.playPath.CGPath);
     basicAni.toValue = (__bridge id _Nullable)(self.pausePath.CGPath);
     basicAni.duration = 0.2;
     basicAni.removedOnCompletion = NO;
     basicAni.fillMode = kCAFillModeForwards;
     [self.playPauseLayer addAnimation:basicAni forKey:nil];
}

- (void)animatePauseToPlay {
     CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"path"];
     basicAni.fromValue = (__bridge id _Nullable)((self.pausePath.CGPath));
     basicAni.toValue = (__bridge id _Nullable)(self.playPath.CGPath);
     basicAni.duration = 0.2;
     basicAni.removedOnCompletion = NO;
     basicAni.fillMode = kCAFillModeForwards;
     [self.playPauseLayer addAnimation:basicAni forKey:nil];
}

@end
