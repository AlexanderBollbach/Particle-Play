//
//  SettingsViewController.h
//  fieldTheory1
//
//  Created by alexanderbollbach on 8/26/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrbModel.h"
#import "OrbView.h"

@interface SeqViewController : UIViewController

@property(nonatomic,strong)NSString* orbName;
@property(nonatomic,strong)OrbModel* orbModelRef;
@property(nonatomic,strong)OrbView* orbViewRef;


@end
