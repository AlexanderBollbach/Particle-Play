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
          self.orbColor = [UIColor flatEmeraldColor];
          self.mainViewBackgroundColor = [UIColor flatSTDarkNavyColor];
          self.gridSelectedColor = [UIColor whiteColor];
          self.bordersColor = [UIColor blackColor];
          self.borderWidth = 1;
     }
     return self;
}
@end
