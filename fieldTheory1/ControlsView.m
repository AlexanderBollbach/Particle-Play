//
//  TopPanelView.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/9/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//
#import "ControlsView.h"
#import "Theme.h"

@implementation ControlsView

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          
          CGRect row1 = self.bounds; // transport frame
          row1.size.height /= 4;
          
          CGRect row2 = row1; // sequencer frame
          row2.origin.y = row1.size.height;
          row2.size.height = self.bounds.size.height - row2.size.height;
         
          self.effectsView = [[EffectsView alloc] initWithFrame:row1];
          self.effectsView.backgroundColor = [UIColor clearColor];
          [self addSubview:self.effectsView];

          self.sequencerView = [[SequencerView alloc] initWithFrame:row2];
          [self addSubview:self.sequencerView];

          self.backgroundColor = [Theme sharedTheme].controlsViewBackgroundColor;
 
     }
     return self;
}


@end
