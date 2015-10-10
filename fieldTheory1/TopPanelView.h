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

@interface TopPanelView : UIView
@property (nonatomic,strong) PlayPauseButton *playPauseButton;
@property (nonatomic,strong) ResetButton *resetButton;
@property (nonatomic,strong) CustomSlider *tempoSlider;
@end
