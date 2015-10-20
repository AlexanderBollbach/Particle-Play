//
//  TopPanelView.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/9/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayPauseButton.h"
#import "CustomSlider.h"
#import "HotCuesView.h"

@class ControlsView;

@protocol ControlsViewDelegate <NSObject>
-(void)didClickWithTag:(int)tag;
-(void)sliderChangedWithValue:(int)value;
-(void)toggleExpand:(BOOL)toggle;
- (void)playedPaused:(BOOL)play_pause;
@end

@interface ControlsView : UIView
@property (nonatomic,strong) PlayPauseButton *playPauseButton;
@property (nonatomic,strong) CustomSlider *tempoSlider;
@property (nonatomic,strong) id<ControlsViewDelegate> delegate;
@property (nonatomic,strong) HotCuesView *hotCuesView;
@property (nonatomic,strong) UIButton *expandButton;
@end
