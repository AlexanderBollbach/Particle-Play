//
//  MainView.m
//  Particle Play
//
//  Created by alexanderbollbach on 9/30/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "UIColor+ColorAdditions.h"
#import "MainView.h"

@interface MainView()
@end

@implementation MainView {
     float phase;
}

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          self.orbs = [NSMutableArray new];
          self.backgroundColor = [UIColor clearColor];
          phase = 0;
          self.dashConstant = 10;
          CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
          [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
          self.isPlaying = NO;
          self.phaseShift = 2;
     }
     
     return self;
}
- (void)tick {
     if (self.isPlaying) {
     [self setNeedsDisplay];
     }

}

- (void)drawRect:(CGRect)rect {
     [self setNeedsDisplay];

     CGFloat dash[2] = { self.dashConstant, self.dashConstant };

     CGContextRef context = UIGraphicsGetCurrentContext();
     for (OrbView *orb in self.orbs) {
          CGContextMoveToPoint(context, orb.center.x,orb.center.y);
          CGContextAddLineToPoint(context, self.anchorOrb.center.x, self.anchorOrb.center.y);
          CGContextSetLineWidth(context, 4.0f);
          CGContextSetLineDash(context, phase, dash, 1);
          [[UIColor flatSTWhiteColor] setStroke];
          CGContextDrawPath(context,kCGPathFillStroke);
     }
     phase = phase + self.phaseShift;
}
-(void) setNeedsDisplay {
     [self.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
     [super setNeedsDisplay];
}

@end