//
//  TopPanelView.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/9/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportView.h"
#import "SequencerView.h"

@interface ControlsView : UIView
@property (nonatomic,strong) TransportView *transportView;
@property (nonatomic,strong) SequencerView *sequencerView;
@end
