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

-(void)setSelected:(BOOL)selected {
     
  //   self.selected = !self.selected;
     
     if (selected) {
          self.backgroundColor = [Theme sharedTheme].mainFillColor;
     } else {
          self.backgroundColor = [UIColor clearColor];
     }
}

@end
