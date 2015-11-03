//
//  TopTransportView.h
//  Particle Play
//
//  Created by alexanderbollbach on 11/2/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayPauseButton.h"
#import "CustomSlider.h"

@protocol TopTransportViewDelegate <NSObject>
- (void)sliderChangedWithValue:(int)value;
- (void)playedPaused:(BOOL)play_pause;
@end


@interface TopTransportView : UIView
@property (nonatomic,strong) PlayPauseButton *playPauseButton;
@property (nonatomic,strong) CustomSlider *tempoSlider;
@property (nonatomic,strong) id<TopTransportViewDelegate> delegate;
@end