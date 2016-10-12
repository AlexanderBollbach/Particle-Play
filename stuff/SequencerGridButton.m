//
//  SequencerGridButton.m
//  Particle Player
//
//  Created by alexanderbollbach on 10/22/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "SequencerGridButton.h"
#import "Theme.h"

@implementation SequencerGridButton

- (instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          self.layer.borderColor = [UIColor whiteColor].CGColor;
     }
     return  self;
}

@end
