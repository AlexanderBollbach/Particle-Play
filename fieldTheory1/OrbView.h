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
@class Sampler;
@class OrbView;

@protocol OrbViewDelegate <NSObject> // mainviewcontroller
- (void)orbTappedWithID:(int)ID;
- (BOOL)isPointTooCloseToOrbs:(CGPoint)point theOrb:(OrbView*)orb;
@end

@interface OrbView : UIButton <UIGestureRecognizerDelegate>
@property (nonatomic, weak) OrbModel* orbModelRef;
@property (nonatomic, strong) CAShapeLayer* orbLayerBase;
@property (nonatomic, strong) Sampler *sampler;
@property (nonatomic, assign) BOOL isEffect;
@property (nonatomic, assign) BOOL hasReverb;
@property (nonatomic,assign) float revAmount;
@property (nonatomic, assign) BOOL hasHP;
@property (nonatomic,assign) float hpCutoff;
@property (nonatomic,strong) id<OrbViewDelegate> delegate;

- (void)performAnimation;
- (void)setIcon;
- (void)loadSampler;

@end
