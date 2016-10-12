//
//  HotCuesView.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/15/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HotCuesView;

@protocol HotCuesViewDelegate <NSObject>
-(void)doSomethingWithTag:(NSInteger)tag;
@end

@interface HotCuesView : UIView

@property (nonatomic,strong) id<HotCuesViewDelegate> delegate;

@end
