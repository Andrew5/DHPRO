//
//  DoraemonNSLogListCell.m
//  AFNetworking
//
//  Created by yixiang on 2018/11/26.
//

#import "DoraemonNSLogListCell.h"
#import "DoraemonDefine.h"
#import "DoraemonUtil.h"

@interface DoraemonNSLogListCell()

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *logLabel;

@end

@implementation DoraemonNSLogListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDoraemonSizeFrom750_Landscape(27), [[self class] cellHeightWith:nil]/2-kDoraemonSizeFrom750_Landscape(25)/2, kDoraemonSizeFrom750_Landscape(25), kDoraemonSizeFrom750_Landscape(25))];
        _arrowImageView.image = [UIImage doraemon_xcassetImageNamed:@"doraemon_expand_no"];
        _arrowImageView.contentMode = UIViewContentModeCenter;
        _arrowImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_arrowImageView];
        
        _logLabel = [[UILabel alloc] init];
        _logLabel.textColor = [UIColor doraemon_black_1];
        _logLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(24)];
        [self.contentView addSubview:_logLabel];
    }
    return self;
}

- (void)renderCellWithData:(DoraemonNSLogModel *)model{
    NSString *content;
    if (model && model.expand){
        NSString *log = model.content;
        NSTimeInterval timeInterval = model.timeInterval;
        NSString *time = [DoraemonUtil dateFormatTimeInterval:timeInterval];
        content = [NSString stringWithFormat:DoraemonLocalizedString(@"%@\n触发时间: %@"),log,time];
        _logLabel.numberOfLines = 0;
        _logLabel.text = content;
        CGSize size = [_logLabel sizeThatFits:CGSizeMake(DoraemonScreenWidth-kDoraemonSizeFrom750_Landscape(32)*2-kDoraemonSizeFrom750_Landscape(25)-kDoraemonSizeFrom750_Landscape(12)*2, MAXFLOAT)];
        _logLabel.frame = CGRectMake(_arrowImageView.doraemon_right+kDoraemonSizeFrom750_Landscape(12), [[self class] cellHeightWith:model]/2-size.height/2, size.width, size.height);
        
        _arrowImageView.image = [UIImage doraemon_xcassetImageNamed:@"doraemon_expand"];
    }else{
        _logLabel.numberOfLines = 1;
        _logLabel.text = model.content;
        _logLabel.frame = CGRectMake(_arrowImageView.doraemon_right+kDoraemonSizeFrom750_Landscape(12), [[self class] cellHeightWith:model]/2-kDoraemonSizeFrom750_Landscape(34)/2,DoraemonScreenWidth-kDoraemonSizeFrom750_Landscape(32)*2-kDoraemonSizeFrom750_Landscape(25)-kDoraemonSizeFrom750_Landscape(12)*2 , kDoraemonSizeFrom750_Landscape(34));
        _arrowImageView.image = [UIImage doraemon_xcassetImageNamed:@"doraemon_expand_no"];
    }
    


}

+ (CGFloat)cellHeightWith:(DoraemonNSLogModel *)model{
    CGFloat cellHeight = kDoraemonSizeFrom750_Landscape(60);
    if (model && model.expand) {
        NSString *log = model.content;
        NSTimeInterval timeInterval = model.timeInterval;
        NSString *time = [DoraemonUtil dateFormatTimeInterval:timeInterval];
        NSString *content = [NSString stringWithFormat:DoraemonLocalizedString(@"%@\n触发时间: %@"),log,time];
        
        UILabel *logLabel = [[UILabel alloc] init];
        logLabel.textColor = [UIColor doraemon_black_1];
        logLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(24)];
        logLabel.text = content;
        logLabel.numberOfLines = 0;
        CGSize size = [logLabel sizeThatFits:CGSizeMake(DoraemonScreenWidth-kDoraemonSizeFrom750_Landscape(32)*2-kDoraemonSizeFrom750_Landscape(25)-kDoraemonSizeFrom750_Landscape(12)*2, MAXFLOAT)];
        cellHeight = kDoraemonSizeFrom750_Landscape(10) + size.height + kDoraemonSizeFrom750_Landscape(10);
    }
    return cellHeight;
}



@end
