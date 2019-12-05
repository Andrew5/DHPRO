#import "GoodsDetailMore1CollectionViewCell.h"

@implementation GoodsDetailMore1CollectionViewCell

- (void)awakeFromNib {
    self.backgroundColor = WHITE_COLOR;
    self.coverImageView.layer.cornerRadius = 10;
    self.coverImageView.layer.masksToBounds = YES;
    self.textLabel1.textColor = RGBCOLORV(0x666666);
    self.textLabel2.textColor = TEXT_COLOR_DARK;
    _bottomSplitView.backgroundColor = RGBCOLORV(0xf2f2f2);
}
@end
