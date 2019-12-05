#import "GoodsDetailSection1CollectionViewCell.h"
#import "UICustomLineLabel.h"

@implementation GoodsDetailSection1CollectionViewCell

- (void)awakeFromNib {
    self.backgroundColor = WHITE_COLOR;
    self.priceLabel.textColor = RGBCOLORV(0xea6000);
    _marketPriceLabel.lineType = LineTypeMiddle;
    _marketPriceLabel.textColor = RGBCOLORV(0x666666);
    _splitView.backgroundColor=RGBCOLORV(0Xf2f2f2);
}

- (void)bind {
    @weakify(self)
    [RACObserve(self, goods)
            subscribeNext:^(id x) {
                @strongify(self);
                [self render];
            }];
}
//不显示批发价格
- (void)render {
    _nameLabel.text = self.goods.goods_name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", _goods.shop_price];
    _marketPriceLabel.text=[NSString stringWithFormat:@"￥%@", _goods.market_price];
    _marketPriceLabel.hidden = YES;

    if([_goods.market_price floatValue]<=0){
        [_discountLabel setHidden:YES];
    }else{
        _discountLabel.text=[NSString stringWithFormat:@"%.1f折",
                             [_goods.shop_price floatValue]/[_goods.market_price floatValue]
        ];
    }
}

@end
