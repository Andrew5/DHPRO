//
//  DHTScrollviewTeachingVC.m
//  CollegePro
//
//  Created by jabraknight on 2020/11/29.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHTScrollviewTeachingVC.h"
#import "DHScrollerTView.h"

@interface DHTScrollviewTeachingVC ()<UIScrollViewDelegate>
{
    CGPoint _endOffsetX;
}
@end

@implementation DHTScrollviewTeachingVC
/*
 1、在UIScrollView上添加N+2个UIImageView
 2、在UIScrollView上添加固定的3个UIImageView
 3、利用重用机制中的UICollectionView或者横向TableView来实现
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setScroller];
}
- (void)setScroller{
   
    
    DHScrollerTView *pieceView = [[DHScrollerTView alloc]init];
    [self.view addSubview:pieceView];
    pieceView.layer.borderColor = [UIColor greenColor].CGColor;
    pieceView.layer.borderWidth = 1.0;
    pieceView.backgroundColor = [UIColor grayColor];
    [pieceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(00);
        make.right.equalTo(self.view).offset(00);
        make.height.mas_equalTo(@100);
    }];
    [pieceView layoutIfNeeded];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void)dealloc{
    NSLog(@"-----");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
