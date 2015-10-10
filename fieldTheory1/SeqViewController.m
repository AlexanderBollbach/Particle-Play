//
//  SettingsViewController.m
//  fieldTheory1
//
//  Created by alexanderbollbach on 8/26/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.

#import "SeqViewController.h"
#import "SeqView.h"
#import "OrbManager.h"
#import "AppDelegate.h"
#import "myFunction.h"
#import "CustomSlider.h"

@interface SeqViewController ()

@property(nonatomic,strong)UIView* sequencerView;
@property(nonatomic,strong)OrbManager* orbManager;
@property(nonatomic,strong)AppDelegate* appDel;
@property(nonatomic,strong)CustomSlider* customSlider;
@property(nonatomic,strong)SeqView* seqView;

@end

@implementation SeqViewController {
     bool sequenceTick;
}

- (void)viewDidLoad {
     [super viewDidLoad];
     
     CGRect bottomFrame = self.view.frame;
     bottomFrame.size.height = self.view.frame.size.height/3;
     bottomFrame.origin.y = self.view.frame.size.height;
     self.view.frame = bottomFrame;
     
     NSLog(@"%@", NSStringFromCGRect(self.view.frame));
     self.orbManager = [OrbManager sharedOrbManager];
     self.seqView = [[SeqView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    // [self.seqView createSeqs];
     [self.view addSubview:self.seqView];
     self.seqView.delegate = self;
}

- (void)sequencerView:(SeqView *)sequencerView column:(int)column row:(int)row {
     OrbModel *modelRef;
     for (OrbModel *orb in self.orbManager.orbModels) {
          switch (row) {
               case 0:
                    if ([orb.name isEqualToString:@"kick"]) {
                         modelRef = orb;
                    }
                    break;
               case 1:
                    if ([orb.name isEqualToString:@"snare"]) {
                         modelRef = orb;
                    }
                    break;
               case 2:
                    if ([orb.name isEqualToString:@"hihat"]) {
                         modelRef = orb;
                    }
                    break;
               case 3:
                    if ([orb.name isEqualToString:@"openHihat"]) {
                         modelRef = orb;
                    }
                    break;
               default:
                    break;
          }
     }
     BOOL beatToSwtich = [modelRef.sequence[column-1] boolValue];
     BOOL switchedBeat = !beatToSwtich;
     [modelRef.sequence replaceObjectAtIndex:column-1 withObject:[NSNumber numberWithBool:switchedBeat]];
     UIView *agrid = (UIView*)[self.seqView getSeqGridWithRow:row andCol:column];
     agrid.backgroundColor = switchedBeat ?  [UIColor orangeColor] : [UIColor yellowColor];
}


@end

