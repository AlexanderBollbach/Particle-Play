//
//  OrbView.m
//  sliderTest
//
//  Created by alexanderbollbach on 9/14/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "OrbView.h"
#import "SeqViewController.h"
#import "AppDelegate.h"
#import "OrbModel.h"
#import "OrbManager.h"
#import "myFunction.h"
#import "AUSamplePlayer2.h"

#define degreesToRadians(x) ((x) * M_PI / 180.0)

@interface OrbView()
@property (nonatomic, strong) UIPanGestureRecognizer* panGesture;
@end

@implementation OrbView

-(instancetype)initWithFrame:(CGRect)frame {
     self = [super initWithFrame:frame];
     if (self) {
          
          // setup
          self.layer.shadowRadius = 5.0f;
          self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f].CGColor;
          self.layer.borderWidth = 2.0f;
          self.layer.cornerRadius = CGRectGetMidX(self.bounds);
          self.layer.shadowColor = [UIColor whiteColor].CGColor;
          self.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
          
          //gesture
          self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
          self.panGesture.delegate = self;
          [self addGestureRecognizer:self.panGesture];
          
          //Sound
          NSString *path = [[NSBundle mainBundle] pathForResource:@"SimpleDrums" ofType:@"aupreset"];
          self.sampler =  [[AUSamplePlayer2 alloc]initWithPresetPath:path];
     }
     return self;
}

- (void)setIsMaster:(BOOL)isMaster {
     _isMaster = isMaster;
     
     if (_isMaster) {
          self.layer.shadowRadius = 10.0f;
          self.layer.shadowOpacity = 1.0f;
     }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
     [super setBackgroundColor:backgroundColor];
     
     if (!self.isMaster) {
          self.layer.shadowColor = backgroundColor.CGColor;
     }
}

- (void)handlePan:(UIPanGestureRecognizer*)sender {
     [self.superview bringSubviewToFront:self];
     self.center = [sender locationInView:self.superview];
     self.orbModelRef.center = self.center;
}

- (void)performAnimation {

     self.layer.shadowRadius = 25.0f;
     
     CABasicAnimation *shadow = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
     shadow.fromValue = @1;
     shadow.toValue = @0;
     shadow.duration = 0.1;
     [self.layer addAnimation:shadow forKey:shadow.keyPath];
  
     CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
     scale.fromValue = @1;
     scale.toValue = @1.5;
     scale.autoreverses = YES;
     scale.duration = 0.1;
     [self.layer addAnimation:scale forKey:scale.keyPath];
}

@end
