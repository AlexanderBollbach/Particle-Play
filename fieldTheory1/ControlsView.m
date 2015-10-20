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
          row1.size.height /= 4;
          
          CGRect row2 = row1;
          row2.origin.y = row1.size.height;
          row2.size.height = self.bounds.size.height - row2.size.height;
          
          CGRect row1L_frame = row1;
          row1L_frame.size.width /= 2;
          
          CGRect row1R_frame = row1L_frame;
          row1R_frame.origin.x += row1R_frame.size.width;
          
          CGRect row1R_A_frame = row1R_frame;
          row1R_A_frame.size.width /= 2;
          
          CGRect row1R_B_frame = row1R_A_frame;
          row1R_B_frame.origin.x += row1R_B_frame.size.width;
          
          // row 1
          self.playPauseButton = [[PlayPauseButton alloc] initWithFrame:CGRectInset(row1L_frame, 5, 5)];
          [self.playPauseButton addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];

         // [self handleEvent:self.playPauseButton];
          self.playPauseButton.selected = YES;
          [self.playPauseButton animateTriToSquare];
          self.tempoSlider = [[CustomSlider alloc] initWithFrame:CGRectInset(row1R_A_frame, 5, 5)];
          [self.tempoSlider addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventValueChanged];
          
          self.expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
          self.expandButton.frame = row1R_B_frame;
          [self.expandButton setImage:[UIImage imageNamed:@"carrot"] forState:UIControlStateNormal];
          [self addSubview:self.expandButton];
          [self.expandButton addTarget:self action:@selector(handleExpandButton:) forControlEvents:UIControlEventTouchUpInside];
          
          
          // row2
          self.hotCuesView = [[HotCuesView alloc] initWithFrame:row2];
          self.hotCuesView.backgroundColor = [UIColor clearColor];
          
          [self addSubview:self.tempoSlider];
          [self addSubview:self.playPauseButton];
          [self addSubview:self.hotCuesView];
          
          self.backgroundColor = [UIColor clearColor];
     }
     return self;
}

-(void)handleExpandButton:(UIButton*)sender {
     sender.selected = !sender.selected;
     [self.delegate toggleExpand:sender.selected];
     NSLog(@"%@", sender.tintColor);
}

-(void)handleEvent:(id)sender {
     if ([sender isKindOfClass:[CustomSlider class]]) {
          CustomSlider *theSlider = sender;
          theSlider.selected = !theSlider.selected;
          if (self.delegate) {
               [self.delegate sliderChangedWithValue:(int)theSlider.amount];
          }
     }
     if ([sender isKindOfClass:[PlayPauseButton class]]) {
          PlayPauseButton *theButton = sender;
          theButton.selected = !theButton.selected;
          if (theButton.selected) {
               [theButton animateTriToSquare];
          } else {
               [theButton animateSquareToTri];
          }
          if (self.delegate) {
               [self.delegate playedPaused:theButton.selected];
          }
     }
     
}

@end
