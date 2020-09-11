//
//  SphericaLayout.m
//  CollegePro
//
//  Created by jabraknight on 2019/8/12.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "SphericaLayout.h"

@implementation SphericaLayout
-(void)prepareLayout{
    [super prepareLayout];
    
}
//返回的滚动范围增加了对x轴的兼容
-(CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width*([self.collectionView numberOfItemsInSection:0]+2), self.collectionView.frame.size.height*([self.collectionView numberOfItemsInSection:0]+2));
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * atti = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //获取item的个数
    int itemCounts = (int)[self.collectionView numberOfItemsInSection:0];
    atti.center = CGPointMake(self.collectionView.frame.size.width/2+self.collectionView.contentOffset.x, self.collectionView.frame.size.height/2+self.collectionView.contentOffset.y);
    atti.size = CGSizeMake(30, 30);
    
    CATransform3D trans3D = CATransform3DIdentity;
    trans3D.m34 = -1/900.0;
    
    CGFloat radius = 15/tanf(M_PI*2/itemCounts/2);
    //根据偏移量 改变角度
    //添加了一个x的偏移量
    float offsety = self.collectionView.contentOffset.y;
    float offsetx = self.collectionView.contentOffset.x;
    //分别计算偏移的角度
    float angleOffsety = offsety/self.collectionView.frame.size.height;
    float angleOffsetx = offsetx/self.collectionView.frame.size.width;
    CGFloat angle1 = (float)(indexPath.row+angleOffsety-1)/itemCounts*M_PI*2;
    //x，y的默认方向相反
    CGFloat angle2 = (float)(indexPath.row-angleOffsetx-1)/itemCounts*M_PI*2;
    //这里我们进行四个方向的排列
    if (indexPath.row%4==1) {
        trans3D = CATransform3DRotate(trans3D, angle1, 1.0,0, 0);
    }else if(indexPath.row%4==2){
        trans3D = CATransform3DRotate(trans3D, angle2, 0, 1, 0);
    }else if(indexPath.row%4==3){
        trans3D = CATransform3DRotate(trans3D, angle1, 0.5,0.5, 0);
    }else{
        trans3D = CATransform3DRotate(trans3D, angle1, 0.5,-0.5,0);
    }
    
    trans3D = CATransform3DTranslate(trans3D, 0, 0, radius);
    
    atti.transform3D = trans3D;
    return atti;
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray * attributes = [[NSMutableArray alloc]init];
    //遍历设置每个item的布局属性
    for (int i=0; i<[self.collectionView numberOfItemsInSection:0]; i++) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    return attributes;
}
@end
