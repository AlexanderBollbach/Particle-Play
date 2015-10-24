//
//  CustomSlider.m
//  sliderTest
//
//  Created by alexanderbollbach on 9/14/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "CustomSlider.h"
#import "Theme.h"
#import "myFunction.h"

@implementation CustomSlider

-(instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      self.fillAmount = 100;
        self.value = 50;
      self.backgroundColor = [UIColor clearColor];
        [self setNeedsDisplay];

   }
   return self;
}


-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
   [super beginTrackingWithTouch:touch withEvent:event];
      return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
 //  [super continueTrackingWithTouch:touch withEvent:event];
   
   CGPoint lastPoint = [touch locationInView:self];

     self.fillAmount = lastPoint.x;

     
   self.value = interpolate(0,
                             self.bounds.size.width,
                             0,
                             100,
                             lastPoint.x,
                             1);
     NSLog(@"%i", self.value);
   [self sendActionsForControlEvents:UIControlEventValueChanged];
   [self setNeedsDisplay];
     
     
     
   return YES;

}


- (void)drawRect:(CGRect)rect {
   
   [[[Theme sharedTheme] mainFillColor] setFill];
   UIRectFill(CGRectMake(0.0, 0.0, self.fillAmount, CGRectGetHeight(self.bounds)));
     self.layer.borderWidth = [Theme sharedTheme].borderWidth;
   self.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor;
   
}


@end
