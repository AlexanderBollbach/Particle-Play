//
//  MainView.m
//  Particle Play
//
//  Created by alexanderbollbach on 9/30/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "UIColor+ColorAdditions.h"
#import "MainView.h"
#import "OrbModel.h"

@interface MainView() @end

@implementation MainView {
     float phase;
}

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          self.orbs = [NSMutableArray new];
          self.backgroundColor = [UIColor clearColor];
          phase = 0;
          self.dashConstant = 10;
          self.isPlaying = NO;
          self.phaseShift = 2;
          self.spaceView = [[SpaceView alloc] initWithFrame:self.bounds];
          [self addSubview:self.spaceView];
          [self setNeedsDisplay];
     }
     return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     NSLog(@"touches began in mainview");
     [super touchesBegan:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect {
     if (self.isPlaying) {

     CGFloat dash[2] = { 7, 6.5 };

     CGContextRef context = UIGraphicsGetCurrentContext();
     for (OrbView *orb in self.orbs) {
          CGContextMoveToPoint(context, orb.center.x,orb.center.y);
          CGContextSetLineWidth(context, 4.0f);
          CGContextSetLineDash(context, phase, dash, 1);
          [[UIColor flatSTWhiteColor] setStroke];
          
          if(![orb.orbModelRef.name isEqualToString:@"reverb"] &&
             ![orb.orbModelRef.name isEqualToString:@"hp"]){
               if (orb.hasReverb) {
                    CGContextMoveToPoint(context, orb.center.x, orb.center.y);
                    CGContextAddLineToPoint(context, self.reverbOrb.center.x, self.reverbOrb.center.y);
               }
               if (orb.hasHP) {
                    CGContextMoveToPoint(context, orb.center.x, orb.center.y);
                    CGContextAddLineToPoint(context, self.hpOrb.center.x, self.hpOrb.center.y);
               }
          }
          CGContextDrawPath(context,kCGPathFillStroke);
          
     }
     phase = phase + self.phaseShift;
     }

}

-(void) setNeedsDisplay {
    // [self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];

     [super setNeedsDisplay];
}

@end