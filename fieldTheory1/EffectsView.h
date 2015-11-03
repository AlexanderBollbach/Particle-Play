//
//  CockPitView.h
//  Particle Player
//
//  Created by alexanderbollbach on 10/21/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandButton.h"


@protocol EffectsViewDelegate <NSObject> // controlsviewcontroller
- (void)setEffectForOrbWithID:(int)orbID effectTag:(int)effectTag selected:(BOOL)selected;
- (void)toggle:(BOOL)expanded;
@end


@interface EffectsView : UIView
@property (nonatomic,strong) ExpandButton *expandButton;
@property (nonatomic,strong) id<EffectsViewDelegate> delegate;

-(void)loadOrbWithID:(int)orbID andRev:(BOOL)rev hp:(BOOL)hp lp:(BOOL)lp dist:(BOOL)dist
             orbName:(NSString*)orbName;

@end
