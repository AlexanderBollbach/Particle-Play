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

@implementation MainView

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          self.orbs = [NSMutableArray new];
          self.backgroundColor = [UIColor blackColor];
     }
     return self;
}


- (void)drawRect:(CGRect)rect {
     
     CGFloat dash[2] = { self.dashConstant, self.dashConstant };

     CGContextRef context = UIGraphicsGetCurrentContext();
     for (OrbView *orb in self.orbs) {
          CGContextMoveToPoint(context, orb.center.x,orb.center.y);
          CGContextAddLineToPoint(context, self.anchorOrb.center.x, self.anchorOrb.center.y);
          CGContextSetLineWidth(context, 4.0f);
          CGContextSetLineDash(context, 0.0, dash, 1);
          [[UIColor flatSTWhiteColor] setStroke];
          CGContextDrawPath(context,kCGPathFillStroke);
     }
}


@end