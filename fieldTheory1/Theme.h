//
//  Theme.h
//  Particle Player
//
//  Created by alexanderbollbach on 10/21/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+ColorAdditions.h"

@interface Theme : NSObject
@property (nonatomic,strong) UIColor *controlsViewBackground;
@property (nonatomic,strong) UIColor *orbColor;
@property (nonatomic,strong) UIColor *orbMasterColor;
@property (nonatomic,strong) UIColor *mainViewBackgroundColor;
@property (nonatomic,strong) UIColor *mainFillColor;
@property (nonatomic,strong) UIColor *bordersColor;
@property (nonatomic,assign) CGFloat borderWidth;
@property (nonatomic,assign) CGFloat relativeDivisorForHeightOfControlsView;
+ (Theme*)sharedTheme;
@end
