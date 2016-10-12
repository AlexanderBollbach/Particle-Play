//
//  Sequencer.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/12/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "Sequencer.h"
#import "Theme.h"

@interface Sequencer()
@end

@implementation Sequencer
+ (Sequencer*)sharedSequencer {
     static Sequencer *sequencer = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
          sequencer = [[self alloc] init];
     });
     return sequencer;
}

-(instancetype)init {
     if (self = [super init]) {
        //  [self spawnSequencerWithTempo:5000];
     }
     return self;
}


- (void)setTempoWithInterval:(int)interval {
     [self.superTimer setInterval:interval*1000];
}

- (void)spawnSequencerWithTempo:(int)tempo {
     self.superTimer = [[SuperTimer alloc] initWithInterval:tempo :^{
          [self sequencer];
     }];
}

-(void)startSequencer {
     [self spawnSequencerWithTempo:5000];
}

- (void)pauseSequencer {
     [self.superTimer pauseTimer];
}

- (void)sequencer {
     static int counter = 0;
     
     if (self.playing) {
          counter++;
          int tick = counter % 16;
          
          // crypto mode plays sequence backwards
          if ([Theme sharedTheme].cryptoMode) {
               tick = (16 - 1) - tick;
          }
          
          [[NSNotificationCenter defaultCenter] postNotificationName:@"didTick"
                                                              object:self
                                                            userInfo:@{@"count": [NSNumber numberWithInt:tick]}];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"didTickOnMainThread"
                                                              object:self
                                                            userInfo:@{@"count": [NSNumber numberWithInt:tick]}];
     }
     
}

@end
