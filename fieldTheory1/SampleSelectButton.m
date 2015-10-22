//
//  SampleSelectButton.m
//  Particle Player
//
//  Created by alexanderbollbach on 10/21/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "SampleSelectButton.h"
#import "Theme.h"

@implementation SampleSelectButton

- (instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          self.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor;
          self.layer.borderWidth = [Theme sharedTheme].borderWidth;
          self.tintColor = [UIColor orangeColor];
     }
     return self;
}

- (void)setHighlighted:(BOOL)highlighted {
     [super setHighlighted:highlighted];
    // NSLog(@"highligted %d", highlighted);

}

@end
