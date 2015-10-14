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
          
          CGFloat row1X = CGRectGetHeight(self.bounds)/4*1 - 20;
          CGFloat row2x = CGRectGetHeight(self.bounds)/4*2;
          
          CGFloat playPauseButtonWidth = CGRectGetWidth(self.bounds) * (.2);
          CGFloat playPauseButtonHeight = CGRectGetHeight(self.bounds) * (0.25);
          CGFloat playPauseButtonX = 0 + CGRectGetWidth(self.bounds)*(.05);
          CGFloat playPauseButtonY = row1X;

        CGRect playPauseButtonFrame = CGRectMake(playPauseButtonX, playPauseButtonY, playPauseButtonWidth, playPauseButtonHeight);
          

          CGFloat resetButtonOffset = 15;
          
          for (int x = 0; x < 4; x++) {
               CGFloat resetButtonWidth = CGRectGetWidth(self.bounds)/4 - 5;
               CGFloat resetButtonHeight = CGRectGetHeight(self.bounds) - row2x;
               CGFloat resetButtonX = CGRectGetWidth(self.bounds)/4*x + resetButtonOffset;
               CGFloat resetButtonY = row2x;
               CGRect resetButtonFrame = CGRectMake(resetButtonX, resetButtonY, resetButtonWidth, resetButtonHeight);

               ResetButton *resetButton = [[ResetButton alloc] initWithFrame:resetButtonFrame];
               resetButton.backgroundColor = [UIColor redColor];
               resetButton.tag = x;
               [resetButton addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
               [self addSubview:resetButton];
          }
 
          CGFloat tempoSliderWidth = CGRectGetWidth(self.bounds) * (.5);
          CGFloat tempoSliderHeight = CGRectGetHeight(self.bounds) * (0.25);
          CGFloat tempoSliderX = 0 + CGRectGetWidth(self.bounds)*(.05) + 150;
          CGFloat tempoSliderY = row1X;
          CGRect tempoSliderFrame = CGRectMake(tempoSliderX, tempoSliderY, tempoSliderWidth, tempoSliderHeight);
          
          self.playPauseButton = [[PlayPauseButton alloc] initWithFrame:playPauseButtonFrame];
          //[self.playPauseButton setNeedsDisplay];
          self.tempoSlider = [[CustomSlider alloc] initWithFrame:tempoSliderFrame];
          [self.tempoSlider addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventValueChanged];
          
          
          [self addSubview:self.tempoSlider];
          [self addSubview:self.playPauseButton];
       
          
          self.backgroundColor = [UIColor clearColor];
     }
     return self;
}



-(void)handleEvent:(id)sender {
     
     if ([sender isKindOfClass:[UIButton class]]) {
          UIButton *theButton = sender;
          theButton.selected = !theButton.selected;
          if (self.delegate) {
               [self.delegate didClickWithTag:(int)theButton.tag];
          }
     }
     if ([sender isKindOfClass:[CustomSlider class]]) {
          CustomSlider *theSlider = sender;
          theSlider.selected = !theSlider.selected;
          if (self.delegate) {
               [self.delegate sliderChangedWithValue:(int)theSlider.amount];
          }
     }
     
}

@end
