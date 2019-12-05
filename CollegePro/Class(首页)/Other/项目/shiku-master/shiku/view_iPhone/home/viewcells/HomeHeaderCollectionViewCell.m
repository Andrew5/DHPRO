//
//  HomeHeaderCollectionViewCell.m
//  BlockPro
//
//  Created by Rilakkuma on 15/8/15.
//  Copyright (c) 2015年 Rilakkuma. All rights reserved.
//

#import "HomeHeaderCollectionViewCell.h"

@implementation HomeHeaderCollectionViewCell

- (void)awakeFromNib {
    
    // Initialization code
}

+(instancetype)createCollectionView:(UICollectionView *)collectionView Index:(NSIndexPath *)indexPath{
    
    //
    static NSString *ID =@"HomeHeaderCollectionViewCellID";
    HomeHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderCollectionViewCell" owner:nil options:nil] lastObject];
        
    };
    return cell;
}

- (IBAction)actentionAction:(id)sender {
    [self.delegate attentionBack:sender];
}
@end
