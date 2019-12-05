#import "GoodsDetailShareViewCell.h"

@implementation GoodsDetailShareViewCell


- (void)awakeFromNib {
    self.backgroundColor = RGBCOLORV(0xf2f2f2);
    _rateTitle.textColor = _saleTitle.textColor = RGBCOLORV(0x666666);
//    _rateTitle.font = _saleTitle.font = _rateLable.font = _saleLable.font = [UIFont systemFontOfSize:12];
    _rateLable.textColor = _saleLable.textColor = RGBCOLORV(0x7a9d5b);
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareHandler) forControlEvents:UIControlEventTouchUpInside];

}

- (void)bind {
    @weakify(self)
    [RACObserve(self, goods)
            subscribeNext:^(id x) {
                @strongify(self);
                [self render];
            }];
}
//销量修改
- (void)render {
    _rateLable.text = _goods.shop_rates;
    _saleLable.text = [NSString stringWithFormat:@"%@", _goods.sales];
}

- (void)shareHandler {
    [[self delegate] shareGoods];
}
@end
