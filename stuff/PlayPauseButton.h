//
//  PlayPauseButton.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/9/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayPauseButton : UIButton

@property (nonatomic, strong) CAShapeLayer *playPauseLayer;
@property (nonatomic,strong) UIBezierPath *playPath;
@property (nonatomic,strong) UIBezierPath *pausePath;

-(void)animatePlayToPause;
-(void)animatePauseToPlay;


@end
