//
//  SampleSelectButton.m
//  Particle Player
//
//  Created by alexanderbollbach on 10/21/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "SampleSelectButton.h"
#import "Theme.h"

@implementation SampleSelectButton

- (instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          self.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor;
     }
     return self;
}

- (void)setHighlighted:(BOOL)highlighted {
     [super setHighlighted:highlighted];
    // NSLog(@"highligted %d", highlighted);

}


-(void)setSelected:(BOOL)selected {

     if (selected) {
          self.layer.borderWidth = [Theme sharedTheme].borderWidth;
     } else {
          self.layer.borderWidth = 0;
     }

}


-(void)drawRect:(CGRect)rect {
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextMoveToPoint(context, 0,0);
  

     if (self.selected) {
//          CGContextAddLineToPoint(context,CGRectGetWidth(self.bounds),0);
//          CGContextAddLineToPoint(context,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds));
//
//          CGContextSetLineWidth(context, 2.0f);
//          [[Theme sharedTheme].bordersColor setStroke];
//          CGContextStrokePath(context);
          
          
          
     } else {
          
     }
     }

@end
