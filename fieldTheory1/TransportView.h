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
#import "ExpandButton.h"

@protocol TransportViewDelegate <NSObject>
- (void)sliderChangedWithValue:(int)value;
- (void)toggleExpand:(BOOL)toggle;
- (void)playedPaused:(BOOL)play_pause;
- (void)loadOrbWithTag:(NSInteger)tag;
@end


@interface TransportView : UIView
@property (nonatomic,strong) PlayPauseButton *playPauseButton;
@property (nonatomic,strong) ExpandButton *expandButton;
@property (nonatomic,strong) CustomSlider *tempoSlider;
@property (nonatomic,strong) id<TransportViewDelegate> delegate;
@end
