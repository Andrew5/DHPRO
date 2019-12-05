//
//  HomSection4CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeSection4TypeXSGCollectionViewCell.h"

@implementation HomeSection4TypeXSGCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.lb_title.textColor=TEXT_COLOR_DARK;
    self.lb_price.textColor=MAIN_COLOR;
    [self.btn_cart setTintColor:MAIN_COLOR];
    [self.btn_fav setTintColor:MAIN_COLOR];
    
    dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self initTickerView];
    
//    flipView = [[JDDateCountdownFlipView alloc] initWithTargetDate:[NSDate date]];
//    [self.timerContainer addSubview: flipView];
//    [flipView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.timerContainer);
//        make.top.equalTo(self.timerContainer);
//        make.size.mas_equalTo(self.timerContainer);
//    }];
////    [self layoutSubviews];
//    flipView.backgroundColor=[UIColor redColor];

}
- (void) setTargetDate: (NSDate*) targetDate
{
//    NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components: flags fromDate: [NSDate date] toDate: targetDate options: 0];
    
//    mFlipNumberViewDay.intValue    = [dateComponents day];
//    mFlipNumberViewHour.intValue   = [dateComponents hour];
//    mFlipNumberViewMinute.intValue = [dateComponents minute];
//    mFlipNumberViewSecond.intValue = [dateComponents second];
}
-(void)initTickerView
{
    clockfontsize=15.f;
    clockTickerViewDay1=[SBTickerView new];
    clockTickerViewDay2=[SBTickerView new];
    UILabel *lbday=[UILabel new];
    lbday.font=[UIFont systemFontOfSize:12];
    lbday.text=@"天";
    clockTickerViewHour1=[SBTickerView new];
    clockTickerViewHour2=[SBTickerView new];
    UILabel *lbhour=[UILabel new];
    lbhour.font=[UIFont systemFontOfSize:12];
    lbhour.text=@"时";
    clockTickerViewMinute1=[SBTickerView new];
    clockTickerViewMinute2=[SBTickerView new];
    UILabel *lbMinute=[UILabel new];
    lbMinute.font=[UIFont systemFontOfSize:12];
    lbMinute.text=@"分";
    clockTickerViewSecond1=[SBTickerView new];
    clockTickerViewSecond2=[SBTickerView new];
    UILabel *lbSecond=[UILabel new];
    lbSecond.font=[UIFont systemFontOfSize:12];
    lbSecond.text=@"秒";
    [self.timerContainer addSubview:clockTickerViewDay1];
    [self.timerContainer addSubview:clockTickerViewDay2];
    [self.timerContainer addSubview:lbday];
    [self.timerContainer addSubview:clockTickerViewHour1];
    [self.timerContainer addSubview:clockTickerViewHour2];
    [self.timerContainer addSubview:lbhour];
    [self.timerContainer addSubview:clockTickerViewMinute1];
    [self.timerContainer addSubview:clockTickerViewMinute2];
    [self.timerContainer addSubview:lbMinute];
    [self.timerContainer addSubview:clockTickerViewSecond1];
    [self.timerContainer addSubview:clockTickerViewSecond2];
    [self.timerContainer addSubview:lbSecond];
    
    int offset=0;
   
    
//    [clockTickerViewHour1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.timerContainer);
//        make.top.equalTo(self.timerContainer);
//        make.width.equalTo(clockTickerViewHour2);
//        make.height.equalTo(self.timerContainer);
//    }];
//    [clockTickerViewHour2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(clockTickerViewHour1.mas_right).offset(offset);
//        make.top.equalTo(self.timerContainer);
//        make.width.equalTo(lbhour);
//        make.height.equalTo(self.timerContainer);
//    }];
//    [lbhour mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(clockTickerViewHour2.mas_right).offset(1);
//        make.top.equalTo(self.timerContainer);
//        make.width.equalTo(clockTickerViewMinute1);
//        make.height.equalTo(self.timerContainer);
//    }];
//
//    [clockTickerViewMinute1 mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.left.equalTo(lbhour.mas_right).offset(offset);
//        make.top.equalTo(self.timerContainer);
//        make.width.equalTo(clockTickerViewMinute2);
//        make.height.equalTo(self.timerContainer);
//    }];
//    [clockTickerViewMinute2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(clockTickerViewMinute1.mas_right).offset(offset);
//        make.top.equalTo(self.timerContainer);
//        make.width.equalTo(lbMinute);
//        make.height.equalTo(self.timerContainer);
//    }];
//    
//    [lbMinute mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(clockTickerViewMinute2.mas_right).offset(1);
//        make.top.equalTo(self.timerContainer);
//        make.width.equalTo(clockTickerViewSecond1);
//        make.height.equalTo(self.timerContainer);
//    }];
//    
//    [clockTickerViewSecond1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(lbMinute.mas_right).offset(offset);
//        make.top.equalTo(self.timerContainer);
//        make.width.equalTo(clockTickerViewSecond2);
//        make.height.equalTo(self.timerContainer);
//    }];
//    [clockTickerViewSecond2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(clockTickerViewSecond1.mas_right).offset(offset);
//        make.top.equalTo(self.timerContainer);
//        make.width.equalTo(lbSecond);
//        make.height.equalTo(self.timerContainer);
//    }];
//    
//    [lbSecond mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(clockTickerViewSecond2.mas_right).offset(1);
//        make.top.equalTo(self.timerContainer);
//        make.width.equalTo(clockTickerViewHour1);
//        make.height.equalTo(self.timerContainer);
//    }];
    
    [lbSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timerContainer);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(clockTickerViewDay1);
        make.height.equalTo(self.timerContainer);
    }];
    [clockTickerViewSecond2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbSecond.mas_left).offset(offset);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(lbSecond);
        make.height.equalTo(self.timerContainer);
    }];
    [clockTickerViewSecond1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clockTickerViewSecond2.mas_left).offset(offset);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(clockTickerViewSecond2);
        make.height.equalTo(self.timerContainer);
    }];
    [lbMinute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clockTickerViewSecond1.mas_left).offset(1);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(clockTickerViewSecond1);
        make.height.equalTo(self.timerContainer);
    }];
    [clockTickerViewMinute2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbMinute.mas_left).offset(offset);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(lbMinute);
        make.height.equalTo(self.timerContainer);
    }];
    [clockTickerViewMinute1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clockTickerViewMinute2.mas_left).offset(offset);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(clockTickerViewMinute2);
        make.height.equalTo(self.timerContainer);
    }];
    
    [lbhour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clockTickerViewMinute1.mas_left).offset(1);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(clockTickerViewMinute1);
        make.height.equalTo(self.timerContainer);
    }];
    [clockTickerViewHour2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbhour.mas_left).offset(offset);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(lbhour);
        make.height.equalTo(self.timerContainer);
    }];
    [clockTickerViewHour1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clockTickerViewHour2.mas_left);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(clockTickerViewHour2);
        make.height.equalTo(self.timerContainer);
    }];
    [lbday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clockTickerViewHour1.mas_left).offset(1);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(clockTickerViewHour1);
        make.height.equalTo(self.timerContainer);
    }];
    [clockTickerViewDay2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbday.mas_left).offset(offset);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(lbday);
        make.height.equalTo(self.timerContainer);
    }];
    [clockTickerViewDay1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(clockTickerViewDay2.mas_left);
        make.top.equalTo(self.timerContainer);
        make.width.equalTo(clockTickerViewDay2);
        make.height.equalTo(self.timerContainer);
    }];

     [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(numberTick:) userInfo:nil repeats:YES];
    //Init
    _currentClock = @"00000000";
    _clockTickers = [NSArray arrayWithObjects:
                     clockTickerViewDay1,
                     clockTickerViewDay2,
                     clockTickerViewHour1,
                     clockTickerViewHour2,
                     clockTickerViewMinute1,
                     clockTickerViewMinute2,
                     clockTickerViewSecond1,
                     clockTickerViewSecond2, nil];
    
    for (SBTickerView *ticker in _clockTickers)
        [ticker setFrontView:[SBTickView tickViewWithTitle:@"0" fontSize:clockfontsize]];
}
- (void)numberTick:(id)sender {
    
    NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components: flags fromDate: [NSDate date] toDate: targetDate options: 0];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddHHmmss"];
    NSString *newClock = [formatter stringFromDate:date];
//    NSString *newClock = [NSString stringWithFormat:@"%ld%ld%ld",[dateComponents hour],[dateComponents minute],[dateComponents second]];
    [_clockTickers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![[_currentClock substringWithRange:NSMakeRange(idx, 1)] isEqualToString:[newClock substringWithRange:NSMakeRange(idx, 1)]]) {
            [obj setBackView:[SBTickView tickViewWithTitle:[newClock substringWithRange:NSMakeRange(idx, 1)] fontSize:clockfontsize]];
            [obj tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
        }
    }];
    
    _currentClock = newClock;
}

- (void)bind
{
    @weakify(self)
    [RACObserve(self, aditem)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}

- (void)unbind
{
}
- (void)render
{
    [self.coverImage sd_setImageWithURL:url(self.aditem.url) placeholderImage:img_placehold];
    ;
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateformatter setTimeZone:GTMzone];
    NSDate* dates = [dateformatter dateFromString:self.aditem.endTime];
    
    targetDate = [NSDate dateWithTimeIntervalSinceNow:(long)[dates timeIntervalSinceNow]];
    self.lb_price.text=self.aditem.price;
    self.lb_title.text=self.aditem.title;
    
//    [flipView setTargetDate:date];
    
    
}
//- (void)layoutSubviews
//{
//    UIView* view = [[self.timerContainer subviews] objectAtIndex: 0];
//    
//    view.frame = CGRectMake(0, 0, self.timerContainer.frame.size.width, self.timerContainer.frame.size.height);
//    view.center = CGPointMake(self.timerContainer.frame.size.width /2,
//                              (self.timerContainer.frame.size.height/2));
//}
@end
