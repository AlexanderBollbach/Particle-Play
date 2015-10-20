//
//  HotCuesView.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/15/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "HotCuesView.h"


@implementation HotCuesView {
     UIView *currentView;
}

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
 
          CGRect frame1 = self.bounds;
          frame1.size.width /= 4;
          
          CGRect frame2 = frame1;
          frame2.origin.x += frame1.size.width;
          
          CGRect frame3 = frame2;
          frame3.origin.x += frame3.size.width;
          
          CGRect frame4 = frame3;
          frame4.origin.x += frame4.size.width;
          
          UIView *view1 = [[UIView alloc] initWithFrame:CGRectInset(frame1, 3, 3)];
          view1.backgroundColor = [UIColor purpleColor];
          
          UIView *view2 = [[UIView alloc] initWithFrame:CGRectInset(frame2, 3, 3)];
          view2.backgroundColor = [UIColor purpleColor];
         
          UIView *view3 = [[UIView alloc] initWithFrame:CGRectInset(frame3, 3, 3)];
          view3.backgroundColor = [UIColor purpleColor];
          
          UIView *view4 = [[UIView alloc] initWithFrame:CGRectInset(frame4, 3, 3)];
          view4.backgroundColor = [UIColor purpleColor];
          
          [self addSubview:view1];
          [self addSubview:view2];
          [self addSubview:view3];
          [self addSubview:view4];
          
          self.backgroundColor = [UIColor clearColor];
          self.clipsToBounds = YES;
          view1.tag = 0;
          view2.tag = 4;
          view3.tag = 8;
          view4.tag = 12;
     }
     return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
      UITouch *touch = [touches anyObject];
     [self.delegate doSomethingWithTag:touch.view.tag];
     
     __block UIView *v = touch.view;
     
   //  currentView = touch.view;
     [UIView animateWithDuration:0.1 animations:^{
          v.alpha = 0;
     } completion:^(BOOL finished) {
          v.alpha = 1;
          v = nil;
     }];
}

@end
