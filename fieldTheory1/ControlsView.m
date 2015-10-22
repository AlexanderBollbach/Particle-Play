//
//  TopPanelView.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/9/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//
#import "ControlsView.h"


@implementation ControlsView

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          
          CGRect row1 = self.bounds;
          row1.size.height /= 2;
          
          CGRect row2 = row1;
          row2.origin.y = row1.size.height;
          row2.size.height = self.bounds.size.height - row2.size.height;
         
          self.cockPitView = [[CockPitView alloc] initWithFrame:row1];
          self.cockPitView.backgroundColor = [UIColor clearColor];
          [self addSubview:self.cockPitView];

          self.sequencerView = [[SequencerView alloc] initWithFrame:row2];
          self.sequencerView.backgroundColor = [UIColor clearColor];
          [self.sequencerView setupSequencerViews];
          [self addSubview:self.sequencerView];
       
          
          self.backgroundColor = [UIColor clearColor];
     }
     return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
     
     // Convert the point to the target view's coordinate system.
     // The target view isn't necessarily the immediate subview
     CGPoint pointForTargetView = [self.cockPitView.expandButton convertPoint:point fromView:self];
     NSLog(@"%@", NSStringFromCGPoint(point));
     if (CGRectContainsPoint(self.cockPitView.expandButton.bounds, pointForTargetView)) {
          
          // The target view may have its view hierarchy,
          // so call its hitTest method to return the right hit-test view
          return [self.cockPitView hitTest:pointForTargetView withEvent:event];
     }
     
     return [super hitTest:point withEvent:event];
}

@end
