//
//  OrbView.h
//  fieldTheory1
//
//  Created by alexanderbollbach on 8/20/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@class OrbModel;
@class AUSamplePlayer2;

@interface OrbView : UIButton <UIGestureRecognizerDelegate>
@property (nonatomic, weak) OrbModel* orbModelRef;
@property (nonatomic, strong) CAShapeLayer* orbLayerBase;
@property (nonatomic, strong) AUSamplePlayer2 *sampler;
@property (nonatomic, assign) BOOL isMaster;
- (void)performAnimation;
-(void)setIcon;

@end
