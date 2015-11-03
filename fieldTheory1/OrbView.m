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
#import "Sampler.h"
#import "Theme.h"

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
          self.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor;
          self.layer.borderWidth = [Theme sharedTheme].borderWidth;
          self.layer.cornerRadius = CGRectGetMidX(self.bounds);
          self.layer.shadowColor = [UIColor whiteColor].CGColor;
          self.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
          
          //gesture
//          self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//          self.panGesture.delegate = self;
//          [self addGestureRecognizer:self.panGesture];
//          
          
       
          UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orbTapped:)];
         [self addGestureRecognizer:tap];
          
         // self.hasReverb = NO;
         // self.hasHP = NO;
          
     }
     return self;
}


- (void)orbTapped:(UITapGestureRecognizer*)tap {
     [self.delegate orbTappedWithID:self.orbModelRef.idNum];
}


- (void)loadSampler {
     NSString *path = [[NSBundle mainBundle] pathForResource:@"SimpleDrums" ofType:@"aupreset"];
     self.sampler =  [[Sampler alloc]initWithPresetPath:path];
}


- (void)setIsMaster:(BOOL)isEffect {
     self.isEffect= isEffect;
     
     if (_isEffect) {
          self.layer.shadowRadius = 10.0f;
          self.layer.shadowOpacity = 1.0f;
     }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
     [super setBackgroundColor:backgroundColor];
     
     if (!self.isEffect) {
          self.layer.shadowColor = backgroundColor.CGColor;
     }
}

- (void)handlePan:(UIPanGestureRecognizer*)sender {
    
//     if ([self.orbModelRef.name isEqualToString:@"effects"]) {
//          return;
//     }
//     
//     CGPoint toPoint = [sender locationInView:self.superview];
//     [self.superview bringSubviewToFront:self];
//     
//     // close to point always returns true for now
//     if ([self.delegate isPointTooCloseToOrbs:toPoint theOrb:self]) {
//          self.orbModelRef.center = self.center;
//          self.center = toPoint;
//     }
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
     if ([Theme sharedTheme].cryptoMode) {
          scale.toValue = @2.5;
     } else {
          scale.toValue = @1.3;
     }
     scale.autoreverses = YES;
     scale.duration = 0.1;
     [self.layer addAnimation:scale forKey:scale.keyPath];

}

-(void)setIcon {
     UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.orbModelRef.name]];
     imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 35, CGRectGetHeight(self.bounds) - 35);
     imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
     [self addSubview:imageView];
}

@end
