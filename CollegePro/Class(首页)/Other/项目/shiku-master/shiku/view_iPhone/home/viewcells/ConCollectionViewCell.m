//
//  ConCollectionViewCell.m
//  BlockPro
//
//  Created by Rilakkuma on 15/8/15.
//  Copyright (c) 2015年 Rilakkuma. All rights reserved.
//

#import "ConCollectionViewCell.h"

@implementation ConCollectionViewCell
+(instancetype)createCollectionView:(UICollectionView *)collectionView Index:(NSIndexPath *)indexPath{
    static NSString *ID =@"ConCollectionViewCellID";
    ConCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConCollectionViewCell" owner:nil options:nil] lastObject];
    };
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
