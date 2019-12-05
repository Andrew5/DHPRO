//
//  MainViewController.m
//  BankCard
//
//  Created by XAYQ-FanXL on 16/7/7.
//  Copyright © 2016年 AN. All rights reserved.
//

#import "BankCartViewController.h"
#import "ScanCardViewController.h"

@interface BankCartViewController ()

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UIImageView *cardImageView;

@end

@implementation BankCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.bounds.size.width - 100)/2, 500, 100, 54);
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startScanCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)startScanCard {
    ScanCardViewController *scanCardVC = [[ScanCardViewController alloc] init];
    [scanCardVC achieveResult:^(NSString *cardNumber, NSString *bank, UIImage *image) {
        self.cardImageView.image = image;
        self.numLabel.text = cardNumber;
        self.bankLabel.text = bank;
    }];
    
    [self.navigationController pushViewController:scanCardVC animated:YES];
}

- (UILabel *)bankLabel {
    if (!_bankLabel) {
        _bankLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 300)/2, 150, 300, 40)];
        _bankLabel.backgroundColor = [UIColor clearColor];
        _bankLabel.font = [UIFont fontWithName:@"AppleGothic" size:18];
        _bankLabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:_bankLabel];
    }
    return _bankLabel;
}


- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 300)/2, 100, 300, 40)];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.font = [UIFont fontWithName:@"AppleGothic" size:18];
        _numLabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:_numLabel];
    }
    return _numLabel;
}

- (UIImageView *)cardImageView {
    if (!_cardImageView) {
        float cardw = self.view.bounds.size.width * 70 / 100;
        if(self.view.bounds.size.width < cardw)
            cardw = self.view.bounds.size.width;
        
        float cardh = (float)(cardw / 0.63084f);
        
        float left = (self.view.bounds.size.width -cardw)/2;
//        float top = (self.view.bounds.size.height -cardh)/2;
        CGRect rect = CGRectMake(left, 100, cardw, cardh);
        _cardImageView = [[UIImageView alloc] initWithFrame:rect];
        _cardImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_cardImageView];
    }
    return _cardImageView;
}


@end
