//
//  Sequencer.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/12/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol sequencerDelegate <NSObject>
- (void)didTickWithCount:(int)count;
@end

@interface Sequencer : NSObject

@property (nonatomic,strong) id<sequencerDelegate> delegate;
@property (nonatomic,assign) NSInteger sequencerCounter;
@property (nonatomic,assign) float tempoNew;

+ (Sequencer*)sharedSequencer;

- (void)startSequencer;
- (void)stopSequencer;

@end
