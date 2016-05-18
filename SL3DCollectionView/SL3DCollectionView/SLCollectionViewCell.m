//
//  SLCollectionViewCell.m
//  CollectionView
//
//  Created by CHEUNGYuk Hang Raymond on 16/4/29.
//  Copyright © 2016年 CHEUNGYuk Hang Raymond. All rights reserved.
//

#import "SLCollectionViewCell.h"
#import "DSReflectionLayer.h"
#import "UIView+DSImages.h"

@interface SLCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation SLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}


- (void)setImage:(UIImage *)image {
    
    _image = image;
    self.imageView.image = image;
    
    //此方法给图片添加影子的效果
    [self.imageView clearReflecitonLayer];
    [self.imageView addReflectionToSuperLayer];
}

@end
