//
//  ViewController.m
//  SL3DCollectionView
//
//  Created by CHEUNGYuk Hang Raymond on 16/5/18.
//  Copyright © 2016年 CHEUNGYuk Hang Raymond. All rights reserved.
//

#import "ViewController.h"
#import "SLCollectionViewFlowLayout.h"
#import "SLCollectionViewCell.h"

#define SLSectionNum 35
#define SLID @"cell"

@interface ViewController ()<UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义
    SLCollectionViewFlowLayout *layout = [[SLCollectionViewFlowLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    //注册cell
    [collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:SLID];
    
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
}

#pragma mark -- 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return SLSectionNum;
}

- (SLCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLID forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self loadViewIfNeeded];
}

@end
