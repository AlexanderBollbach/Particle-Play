//
//  Sequencer.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/12/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "Sequencer.h"

@interface Sequencer()
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation Sequencer {
     float tempoTransform;
     int count;
}

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
          tempoTransform = 1;
          self.tempoNew = 1;
          count = 0;
          self.sequencerCounter = 0;
          
     }
     return self;
}

-(void)startSequencer {
     
     if (self.timer) {
          [self.timer invalidate];
          self.timer = nil;
     }
     self.timer = [NSTimer scheduledTimerWithTimeInterval:(0.6 * self.tempoNew)
                                                   target:self
                                                 selector:@selector(sequencer:)
                                                 userInfo:nil
                                                  repeats:YES];
     [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)sequencer:(id)sender {
     
     if (self.tempoNew != tempoTransform) {
          [self startSequencer];
          tempoTransform = self.tempoNew;
     }
     int tick = ((self.sequencerCounter)%16);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"didTick"
                                                         object:self
                                                       userInfo:@{@"count": [NSNumber numberWithInt:tick]}];
     if (self.delegate) {
          [self.delegate didTickWithCount:tick];
     }
     self.sequencerCounter++;
}





@end
