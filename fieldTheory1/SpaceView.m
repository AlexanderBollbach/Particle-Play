//
//  SpaceView.m
//  Particle Player
//
//  Created by alexanderbollbach on 10/23/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "SpaceView.h"
#import <QuartzCore/QuartzCore.h>
@interface SpaceView()
@end


@implementation SpaceView
- (instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          [self makeParticles];
          self.alpha = 0.1;
     }
     return self;
}

-(void)makeParticles {
  //   CGPoint pt = self.center;
    // CGPoint pt = [[touches anyObject] locationInView:self];
    // float multiplier = 0.2f;

     //Create the emitter layer
     self.emitterLayer = [CAEmitterLayer layer];
     self.emitterLayer.emitterPosition = CGPointMake(0, 0);
     
     self.emitterLayer.emitterMode = kCAEmitterLayerAdditive;
     self.emitterLayer.emitterShape = kCAEmitterLayerLine;
     self.emitterLayer.emitterDepth = 2;
   //  self.emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
     self.emitterLayer.emitterSize = self.bounds.size;
     
     //Create the emitter cell
     self.emitterCell = [CAEmitterCell emitterCell];
     self.emitterCell.emissionLongitude = 2;
     self.emitterCell.birthRate = 200;
     self.emitterCell.lifetime = 5;
     self.emitterCell.lifetimeRange = 1;
     self.emitterCell.velocity = 80;
     self.emitterCell.velocityRange = 100;
     self.emitterCell.emissionRange = 1;
     self.emitterCell.scaleSpeed = 1; // was 0.3
     self.emitterCell.color = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor];
     
     CGSize size = CGSizeMake(0.01,0.1);
     UIBezierPath *shape = [UIBezierPath bezierPath];
     shape.lineJoinStyle = kCGLineJoinMiter;
     [shape moveToPoint: CGPointMake(0, 0)];
     [shape addLineToPoint: CGPointMake(size.width, size.height / 2)];
     [shape addLineToPoint: CGPointMake(0, size.height)];
     shape.lineWidth = 1;
     [shape closePath];
     
     UIGraphicsBeginImageContextWithOptions(size, false,[UIScreen mainScreen].scale);
     // CGContextRef context = UIGraphicsGetCurrentContext();
     // offset the draw to allow the line thickness to not get clipped
     //  CGContextTranslateCTM(context, self.lineWidth, self.lineWidth);
     UIColor *strokeColor = [UIColor whiteColor];
     UIColor *fillColor = [UIColor whiteColor];
     [strokeColor setStroke];
     [fillColor setFill];
     [shape fill];
     [shape stroke];
     UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     self.emitterCell.contents = (__bridge id)(result.CGImage);
     self.emitterCell.name = @"particle";
     self.emitterLayer.emitterCells = [NSArray arrayWithObject:self.emitterCell];
     [self.layer addSublayer:self.emitterLayer];
}




@end