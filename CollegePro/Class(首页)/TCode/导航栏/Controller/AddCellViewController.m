//
//  AddCellViewController.m
//  Test
//
//  Created by jabraknight on 2017/3/23.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "AddCellViewController.h"

@interface AddCellViewController ()

@end

@implementation AddCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabelText:) name:@"ChangeLabelTextNotification" object:nil];
    // Do any additional setup after loading the view.
}
//-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
//    NSLog(@"context %@",context);
//}
- (void)changeLabelText:(NSNotification *)notification
{
    NSDictionary *text = notification.object;
    
    NSLog(@"接收到通知的时申明-%@",text[@"text"]);
    //    UIViewController *viewCtl = self.navigationController.viewControllers[2];
    //
    //    [self.navigationController popToViewController:viewCtl animated:YES];
}

/*
 //
 //  ViewController.m
 //  Test
 //
 //  Created by lisong on 2016/9/30.
 //  Copyright © 2016年 lisong. All rights reserved.
 //
 
 #import "ViewController.h"
 #import <AVFoundation/AVFoundation.h>
 #import <MediaPlayer/MediaPlayer.h>
 static NSString *identifier = @"cell";
 static NSInteger count = 2;
 
 @interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
 
 @property (weak, nonatomic) IBOutlet UITableView *tableView;
 
 @property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTop;
 
 @end
 
 @implementation ViewController
 
 - (void)dealloc
 {
 [self.tableView removeObserver:self forKeyPath:@"contentSize"];
 }
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
 
 [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
 
 [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
 
 
 NSError *activationError = nil;
 BOOL success = [[AVAudioSession sharedInstance] setActive:YES error:&activationError];
 if (!success) {
 NSLog(@"111");
 }
 MPVolumeView *v = [[MPVolumeView alloc]initWithFrame:CGRectMake(20, 100, 250, 100)];
 [self.view addSubview:v];
 }
 
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
 {
 self.buttonTop.constant = MIN(self.tableView.contentSize.height + 20, self.view.frame.size.height - 64 - 10 - 50);
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 return count;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
 {
 return 0.1;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 100;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
 
 cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
 return cell;
 }
 
 - (IBAction)buttonDidClick:(UIButton *)sender
 {
 count++;
 
 [self.tableView reloadData];
 }
 
 @end

 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
