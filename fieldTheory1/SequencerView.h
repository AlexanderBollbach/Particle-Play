//
//  SequencerView.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/12/15
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrbModel.h"
#import "Sequencer.h"

@protocol SequencerViewDelegate <NSObject>
- (void)seqTickedWithOrbID:(int)orbID andGridNum:(int)gridNum selected:(BOOL)selected;
@end


@interface SequencerView : UIView
@property (nonatomic, weak) id<SequencerViewDelegate> delegate;
@property (nonatomic,assign) int orbID;
-(void)loadOrb:(OrbModel*)orb;
-(void)animateWithCount:(int)count;
-(void)initSequencerBG;

@end
