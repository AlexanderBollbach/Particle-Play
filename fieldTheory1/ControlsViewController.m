//
//  ControlsViewController.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/2/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "ControlsViewController.h"
#import "ControlsCollectionViewCell.h"
#import "OrbModel.h"
#import "OrbManager.h"
#import "UIColor+ColorAdditions.h"

@interface ControlsViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ControlsCellViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;
@end

@implementation ControlsViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     
     _collectionViewFlowLayout = [UICollectionViewFlowLayout new];
     _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     [_collectionViewFlowLayout setMinimumInteritemSpacing:0.0f];
     [_collectionViewFlowLayout setMinimumLineSpacing:0.0f];
     
     _collectionView = [UICollectionView.alloc initWithFrame:self.view.frame
                                        collectionViewLayout:_collectionViewFlowLayout];
     [_collectionView setDelegate:self];
     [_collectionView setDataSource:self];
     [_collectionView registerClass:[ControlsCollectionViewCell class] forCellWithReuseIdentifier:@"uicvCell"];
     _collectionView.backgroundColor = [UIColor flatSTDarkBlueColor];
     _collectionView.showsHorizontalScrollIndicator = NO;
     _collectionView.pagingEnabled = YES;
     [self.view addSubview:_collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     _collectionView.frame = self.view.bounds;
     _collectionViewFlowLayout.itemSize = self.view.bounds.size;
}

- (void)seqTickedWithColumn:(int)column orbId:(int)orbID selected:(BOOL)selected {
     for (OrbModel *orb in [OrbManager sharedOrbManager].orbModels) {
          if (orb.idNum == orbID) {
               [orb.sequence replaceObjectAtIndex:(int)column withObject:[NSNumber numberWithBool:selected]];
          }
     }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return [[OrbManager sharedOrbManager].orbModels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     ControlsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"uicvCell" forIndexPath:indexPath];
     
     OrbModel *model = [[OrbManager sharedOrbManager].orbModels objectAtIndex:indexPath.row];
     
     cell.orbID = model.idNum;
     cell.orbName.text = model.name;
     cell.delegate = self;
     
     [cell layoutSeqWithSeq:model.sequence];
     
     return cell;
}

@end
