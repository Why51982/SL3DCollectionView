//
//  SLCollectionViewFlowLayout.m
//  CollectionView
//
//  Created by CHEUNGYuk Hang Raymond on 16/4/28.
//  Copyright © 2016年 CHEUNGYuk Hang Raymond. All rights reserved.
//

#import "SLCollectionViewFlowLayout.h"

@implementation SLCollectionViewFlowLayout


//边界发生改变的时候是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

/*
 此方法实现到可视范围中心的时候，变大的效果
//获取可视范围内的cell的属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    //1.获取cell对应的attributes对象
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    //获取中心点
    CGFloat centerX = self.collectionView.frame.size.width * 0.5 + self.collectionView.contentOffset.x;
    
    //2.修改一下attributes对象
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        
        CGFloat distance = ABS(attr.center.x - centerX);
        
        //添加参数实现离中心点，越远越小的效果
        CGFloat factor = 0.003;
        CGFloat scale = 1 / (1 + distance * factor);
        
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attributes;
}
*/
#define ITEM_SIZE 300.0
#define ACTIVE_DISTANCE 200
#define rotate 35.0 * M_PI / 180.0

- (instancetype)init {
    
    if (self = [super init]) {
        //cell的大小
        self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
        //滚动的方向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设定全局的区内边距
        self.sectionInset = UIEdgeInsetsMake(ACTIVE_DISTANCE, 0, ACTIVE_DISTANCE, 0);
        //设定全局的最小行间距
        self.minimumLineSpacing = 0.0;
        //设定全局的cell最小间距
        self.minimumInteritemSpacing = ACTIVE_DISTANCE;
    }
    return self;
}

//此方法实现3D动画效果
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;

    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        
        if (CGRectIntersectsRect(attributes.frame, rect)) { //判断2个矩形是否重叠，交叉
            
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = rotate * normalizedDistance;//rotate:35°
                CATransform3D transfrom = CATransform3DIdentity;
                //m34是透视效果，要操作的这个对象要有旋转的角度，否则没有效果。当然，Z方向上得有变化才会有透视效果
                //第80行和第81行的顺序不能反，m34必须在Z方向变化之前
                transfrom.m34 = 1.0 / 600;
                transfrom = CATransform3DRotate(transfrom, -zoom, 0.0f, 1.0f, 0.0f);
                attributes.transform3D = transfrom;
                attributes.zIndex = 1;
                
            }else
            {
                CATransform3D transfrom = CATransform3DIdentity;
                transfrom.m34 = 1.0 / 600;
                if (distance>0) {
                    transfrom = CATransform3DRotate(transfrom, -rotate, 0.0f, 1.0f, 0.0f);
                    
                }
                else{
                    transfrom = CATransform3DRotate(transfrom, rotate, 0.0f, 1.0f, 0.0f);
                    
                }
                
                attributes.transform3D = transfrom;
                attributes.zIndex = 1;
            }
            
        }
    }
    return array;
}



/**
 *
 *  @param proposedContentOffset 当人用力滑动屏幕的时候，由于“惯性”，将要停留的位置
 *  @param velocity              手离开的时候，滑动的速度 点/秒
 *
 *  @return 停留的点
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    //1.计算中心点的位置
    CGFloat centerX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    //2.获取可视区域内的cell的attributes对象
    //获取可视区域
    CGFloat visibleX = proposedContentOffset.x;
    CGFloat visibleY = proposedContentOffset.y;
    CGFloat visibleW = self.collectionView.frame.size.width;
    CGFloat visibleH = self.collectionView.frame.size.height;
    
    //比较最小的偏移
    NSArray *attributes = [self layoutAttributesForElementsInRect:CGRectMake(visibleX, visibleY, visibleW, visibleH)];
    
    int min_idx = 0;
    UICollectionViewLayoutAttributes *min_attr = attributes[min_idx];
    CGFloat distance1 = ABS(min_attr.center.x - centerX);
    
    for (int i = 1; i < attributes.count; i++) {
        UICollectionViewLayoutAttributes *attribute = attributes[i];
        CGFloat distance2 = ABS(attribute.center.x - centerX);
        
        if (distance2 < distance1) {
            min_idx = i;
            distance1 = distance2;
        }
    }
    
    //计算最小的偏移量
    UICollectionViewLayoutAttributes *min_obj = attributes[min_idx];
    CGFloat moveX = min_obj.center.x - centerX;
    return CGPointMake(moveX + proposedContentOffset.x, proposedContentOffset.y);

    
//    NSLog(@"proposedContentOffset = %@", NSStringFromCGPoint(proposedContentOffset));
//    NSLog(@"velocity = %@", NSStringFromCGPoint(velocity));
//    NSLog(@"==================================");
//    
//    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}

@end
