//
//  MainView.h
//  Particle Play
//
//  Created by alexanderbollbach on 9/30/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrbView.h"

@interface MainView : UIView
@property (nonatomic,strong) NSMutableArray *orbs;
@property (nonatomic,strong) OrbView *anchorOrb;
@end
