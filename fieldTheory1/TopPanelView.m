//
//  TopPanelView.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/9/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "TopPanelView.h"

@implementation TopPanelView

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          
          
          CGFloat playPauseButtonWidth = CGRectGetWidth(self.bounds) * (.2);
          CGFloat playPauseButtonHeight = CGRectGetHeight(self.bounds) * (0.5);
          CGFloat playPauseButtonX = 0 + CGRectGetWidth(self.bounds)*(.05);
          CGFloat playPauseButtonY = 0 + CGRectGetHeight(self.bounds)/2-playPauseButtonHeight/2;

        CGRect playPauseButtonFrame = CGRectMake(playPauseButtonX, playPauseButtonY, playPauseButtonWidth, playPauseButtonHeight);
          

          CGFloat resetButtonWidth = CGRectGetWidth(self.bounds) * (.05);
          CGFloat resetButtonHeight = CGRectGetHeight(self.bounds) * (0.5);
          CGFloat resetButtonX = 0 + CGRectGetWidth(self.bounds)*(.05) + 125;
          CGFloat resetButtonY = 0 + CGRectGetHeight(self.bounds)/2-resetButtonHeight/2;
          CGRect resetButtonFrame = CGRectMake(resetButtonX, resetButtonY, resetButtonWidth, resetButtonHeight);
          
          
          
          CGFloat tempoSliderWidth = CGRectGetWidth(self.bounds) * (.5);
          CGFloat tempoSliderHeight = CGRectGetHeight(self.bounds) * (0.5);
          CGFloat tempoSliderX = 0 + CGRectGetWidth(self.bounds)*(.05) + 150;
          CGFloat tempoSliderY = 0 + CGRectGetHeight(self.bounds)/2-tempoSliderHeight/2;
          CGRect tempoSliderFrame = CGRectMake(tempoSliderX, tempoSliderY, tempoSliderWidth, tempoSliderHeight);
          
          self.playPauseButton = [[PlayPauseButton alloc] initWithFrame:playPauseButtonFrame];
         // self.playPauseButton.backgroundColor = [UIColor redColor];
          [self.playPauseButton setNeedsDisplay];
          
          self.resetButton = [[ResetButton alloc] initWithFrame:resetButtonFrame];
          self.resetButton.backgroundColor = [UIColor redColor];
          
          self.tempoSlider = [[CustomSlider alloc] initWithFrame:tempoSliderFrame];

          [self addSubview:self.tempoSlider];
          [self addSubview:self.playPauseButton];
          [self addSubview:self.resetButton];
     }
     return self;
}


@end
