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
          [self setTheme1];
     }
     return self;
}

- (void)cycleTheme {
     static int counter = 1;
     if (counter == 1) {
          [self setTheme1];
          counter++;
     } else if (counter == 2) {
          [self setTheme2];
          counter = 1;
     }
}

- (void)setTheme1 {
  
     self.cryptoMode = NO;
     self.controlsViewBackgroundColor = [UIColor flatWetAsphaltColor];
     self.mainViewBackgroundColor = [UIColor blackColor];

//     self.orbMasterColor = [UIColor flatSTLightBlueColor];
     self.orbColor = [UIColor flatWetAsphaltColor];
     
     self.orbHPColor = [UIColor purpleColor];
     self.orbReverbColor = [UIColor purpleColor];
     
     self.mainFillColor = [UIColor colorWithRed:0.8 green:0.8 blue:1 alpha:0.88];
    
     self.bordersColor = [UIColor whiteColor];
     self.borderWidth = 2;
     
     self.relativeDivisorForHeightOfControlsView = 2.0f;
     
}

- (void)setTheme2 {
     
     self.cryptoMode = YES;
     self.controlsViewBackgroundColor = [UIColor whiteColor];
     self.orbMasterColor = [UIColor flatAlizarinColor];
     self.orbColor = [UIColor redColor];
     self.orbHPColor = [UIColor whiteColor];
     self.orbReverbColor = [UIColor purpleColor];
     self.mainViewBackgroundColor = [UIColor flatSTDarkNavyColor];
     self.mainFillColor = [UIColor colorWithRed:1 green:0.8 blue:1 alpha:0.8];
     self.bordersColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.6];
     self.borderWidth = 8;
     self.relativeDivisorForHeightOfControlsView = 2.0f;
}


@end
