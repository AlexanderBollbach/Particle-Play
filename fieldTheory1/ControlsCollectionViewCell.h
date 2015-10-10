//
//  ContolsCollectionViewCell.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/3/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@protocol ControlsCellViewDelegate <NSObject>
- (void)seqTickedWithColumn:(int)column orbId:(int)orbID selected:(BOOL)selected;
@end

@interface ControlsCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id<ControlsCellViewDelegate> delegate;
@property (nonatomic,assign) int orbID;
@property (nonatomic ,strong) UILabel *orbName;
-(void)layoutSeqWithSeq:(NSArray *)seq;
@end
