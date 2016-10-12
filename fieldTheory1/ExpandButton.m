//
//  ExpandButton.m
//  Particle Player
//
//  Created by alexanderbollbach on 10/23/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "ExpandButton.h"
#import "Theme.h"
@implementation ExpandButton {
     float offset;
}

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          offset = CGRectGetWidth(self.bounds)/5;

          self.backgroundColor = [UIColor clearColor];
          self.wings = 1.5;
          self.pivot = 0.3;
          [self setNeedsDisplay];

     }
     return self;
}

- (void)drawRect:(CGRect)rect {


     CGContextRef context = UIGraphicsGetCurrentContext();
     
     self.wings *= CGRectGetHeight(self.bounds) * 0.5;
     self.pivot *= CGRectGetHeight(self.bounds) * 0.5;
     
     CGContextSetLineWidth(context, 5);
     CGContextSetLineCap(context, kCGLineCapButt);
     CGContextSetLineJoin(context, kCGLineJoinBevel);
     
     CGContextMoveToPoint(context, 0 + offset, self.wings);
     CGContextAddLineToPoint(context, self.bounds.size.width/2, self.pivot);
     CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds) - offset, self.wings);

     [[[Theme sharedTheme] bordersColor] setStroke];
     CGContextStrokePath(context);
     
}


@end
