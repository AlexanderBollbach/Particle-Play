//
//  ResetButton.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/9/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "ResetButton.h"

@implementation ResetButton
-(void)drawRect:(CGRect)rect {
     CGContextRef context = UIGraphicsGetCurrentContext();
     if (self.selected) {
          CGContextMoveToPoint(context, 0,0);
          CGContextAddLineToPoint(context,20,28);
     } else {
          CGContextMoveToPoint(context, 0,0);
          CGContextAddLineToPoint(context,10,10);
     }
     [[UIColor yellowColor] setStroke];
     CGContextDrawPath(context,kCGPathFillStroke);
}

@end
