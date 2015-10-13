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
     float tempoTransformNew;
     int count;
     int sequencerCounter;
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
          tempoTransformNew = 1;
          count = 0;
          sequencerCounter = 0;
          
     }
     return self;
}

-(void)startSequencer {
     
     if (self.timer) {
          [self.timer invalidate];
          self.timer = nil;
     }
     self.timer = [NSTimer scheduledTimerWithTimeInterval:(0.08 * tempoTransformNew)
                                                   target:self
                                                 selector:@selector(sequencer:)
                                                 userInfo:nil
                                                  repeats:YES];
     [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}



- (void)sequencer:(id)sender {
     
     if (tempoTransformNew != tempoTransform) {
          [self startSequencer];
          tempoTransform = tempoTransformNew;
     }
     sequencerCounter++;
     int tick = ((sequencerCounter)%16);
     if (self.delegate) {
          [self.delegate didTickWithCount:tick];
     }
     
}





@end
