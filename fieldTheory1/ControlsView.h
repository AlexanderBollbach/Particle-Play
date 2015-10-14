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
#import "ResetButton.h"

@class ControlsView;

@protocol ControlsViewDelegate <NSObject>
-(void)didClickWithTag:(int)tag;
-(void)sliderChangedWithValue:(int)value;
@end

@interface ControlsView : UIView
@property (nonatomic,strong) PlayPauseButton *playPauseButton;
@property (nonatomic,strong) ResetButton *resetButton;
@property (nonatomic,strong) CustomSlider *tempoSlider;
@property (nonatomic,strong) id<ControlsViewDelegate> delegate;
@end
