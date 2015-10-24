//
//  Theme.m
//  Particle Player
//
//  Created by alexanderbollbach on 10/21/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (Theme*)sharedTheme {
     static Theme *theme = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
          theme = [[self alloc] init];
     });
     return theme;
}


- (instancetype)init {
     if (self = [super init]) {
          self.controlsViewBackground = [UIColor flatConcreteColor];
          self.orbMasterColor = [UIColor flatSTLightBlueColor];
          self.orbColor = [UIColor flatSTTripleColor];
          self.mainViewBackgroundColor = [UIColor flatSTDarkNavyColor];
          self.mainFillColor = [UIColor purpleColor];
          self.bordersColor = [UIColor whiteColor];
          self.borderWidth = 0.8;
          self.relativeDivisorForHeightOfControlsView = 2.0f;
     }
     return self;
}
@end
