//
//  Sequencer.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/12/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol sequencerDelegate <NSObject>
-(void)didTickWithCount:(int)count;
@end

@interface Sequencer : NSObject

@property (nonatomic,strong) id<sequencerDelegate> delegate;

+ (Sequencer*)sharedSequencer;

-(void)startSequencer;


@end
