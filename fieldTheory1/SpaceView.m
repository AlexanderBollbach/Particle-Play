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
     self.emitterLayer.emitterPosition = self.center;
     
     self.emitterLayer.emitterMode = kCAEmitterLayerLine;
     self.emitterLayer.emitterShape = kCAEmitterLayerBackToFront;
     self.emitterLayer.emitterDepth = 8;
     self.emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
     self.emitterLayer.emitterSize = self.bounds.size;
     self.emitterLayer.emitterZPosition = 3;
     //Create the emitter cell
     self.emitterCell = [CAEmitterCell emitterCell];
     self.emitterCell.blueSpeed = 1.5;
     self.emitterCell.emissionLongitude = 2;
     self.emitterCell.birthRate = 150;
     self.emitterCell.lifetime = 5;
     self.emitterCell.lifetimeRange = 3;
     
     
     self.emitterCell.velocity = 500;
     self.emitterCell.velocityRange = 0;

     self.emitterCell.emissionRange = 3;
     self.emitterCell.scaleSpeed = 3; // was 0.3
     self.emitterCell.color = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor];
     
     [self.emitterCell setName:@"test"];

     
     CGSize size = CGSizeMake(0.11, 0.2);
     UIBezierPath *shape = [UIBezierPath bezierPath];
     shape.lineJoinStyle = kCGLineJoinBevel;
     [shape moveToPoint: CGPointMake(0, 0)];
     [shape addLineToPoint: CGPointMake(size.width, size.height / 2)];
     [shape addLineToPoint: CGPointMake(0, size.height)];
     shape.lineWidth = 2;
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
     self.emitterLayer.emitterCells = [NSArray arrayWithObject:self.emitterCell];
     [self.layer addSublayer:self.emitterLayer];
}




@end