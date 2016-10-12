//
//  testView.h
//  PathTest
//
//  Created by alexanderbollbach on 11/1/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrbTrackView : UIView
@property (nonatomic,strong) UIView *testView;

- (instancetype)initWithFrame:(CGRect)frame andHandleView:(UIView*)view;
- (void)createPathFromPoint:(CGPoint)from toPoint:(CGPoint)to;

@end
