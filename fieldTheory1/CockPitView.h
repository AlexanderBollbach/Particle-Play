//
//  CockPitView.h
//  Particle Player
//
//  Created by alexanderbollbach on 10/21/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayPauseButton.h"
#import "CustomSlider.h"

@protocol CockPitViewDelegate <NSObject>
- (void)sliderChangedWithValue:(int)value;
- (void)toggleExpand:(BOOL)toggle;
- (void)playedPaused:(BOOL)play_pause;
@end


@interface CockPitView : UIView
@property (nonatomic,strong) PlayPauseButton *playPauseButton;
@property (nonatomic,strong) UIButton *expandButton;
@property (nonatomic,strong) CustomSlider *tempoSlider;
@property (nonatomic,strong) id<CockPitViewDelegate> delegate;
@end
