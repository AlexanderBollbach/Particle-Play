//
//  Sequencer.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/12/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperTimer.h"


@import UIKit;

@protocol SequencerDelegate <NSObject>
- (void)didTickWithCount:(int)count;
@end

@interface Sequencer : NSObject

@property (nonatomic,strong) id<SequencerDelegate> delegate;
@property (nonatomic,assign) NSInteger sequencerCounter;
@property (nonatomic,assign) BOOL playing;
@property (strong) SuperTimer *superTimer;

+ (Sequencer*)sharedSequencer;
- (void)spawnSequencerWithTempo:(int)tempo;
- (void)startSequencer;
- (void)pauseSequencer;
- (void)setTempoWithInterval:(int)interval;

@end
