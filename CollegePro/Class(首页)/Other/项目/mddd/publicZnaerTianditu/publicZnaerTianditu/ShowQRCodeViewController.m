//
//  ShowQRCodeViewController.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/22.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "ShowQRCodeViewController.h"
#import "QRCodeGenerator.h"

#define SCAN_CODE_STR(equipId) [NSString stringWithFormat:@"znaer:%@",equipId]

@interface ShowQRCodeViewController ()
{
    NSString *_equipId;
}
@end

@implementation ShowQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"二维码"];
    
    self.codeImageView = [[UIImageView alloc]initWithFrame: CGRectMake(self.view.frame.size.width*0.1, 100, self.view.frame.size.width*0.8, self.view.frame.size.width*0.8)];
    
    UIImage *imgs=[UIImage imageNamed:@"120px"];
    
    self.codeImageView.image = [QRCodeGenerator qrImageForString:SCAN_CODE_STR(_equipId) imageSize:360 Topimg:imgs];
    
    [self.view addSubview:self.codeImageView];
}

#pragma mark - PassValueDelegate
- (void)setValue:(NSObject *)value{
    _equipId = (NSString *)value;
}

@end
