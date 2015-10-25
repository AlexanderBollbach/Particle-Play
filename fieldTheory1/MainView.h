//
//  MainView.h
//  Particle Play
//
//  Created by alexanderbollbach on 9/30/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrbView.h"
#import "SpaceView.h"


@interface MainView : UIView
@property (nonatomic,strong) NSMutableArray *orbs;
@property (nonatomic,strong) OrbView *anchorOrb;
@property (nonatomic,assign) CGFloat dashConstant;
@property (nonatomic,assign) CGFloat dashConstant2;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) float phaseShift;
@property (nonatomic,strong) SpaceView *spaceView;

@end
