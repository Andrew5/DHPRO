//
//  FFKPViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/15.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "FFKPViewController.h"

@interface FFKPViewController ()
{
    NSMutableDictionary * imgViewDic;
    UIImageView * recordImageView;
    NSInteger score;
//    NSTimer * timer;
    UIProgressView * progress;
    double progressValue;
    double gameTime;
}
@property (nonatomic, strong) NSTimer* timer;
- (void) pictureLayout;
- (void) pictureRemoveAll;
- (void) flipBack:(UIImageView *) imgView;
@end

@implementation FFKPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    gameTime = 60.0f;   //游戏初始结束时间为60秒，随后随着过关难度的加大递减10
    //设置背景颜色
    if(imgViewDic == nil)
        imgViewDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    [self pictureLayout];
     self.isShowleftBtn = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer  invalidate];
    self.timer = nil;
}
- (void) pictureLayout
{
    //加载图片资源
    NSMutableArray * imgArray = [[NSMutableArray alloc] initWithCapacity:1];
    for(int i=1;i<=8;i++)
    {
        NSString * imgName = [NSString stringWithFormat:@"h%d.jpg",i];
        UIImageView * imgView =[[UIImageView alloc] initWithImage: [UIImage imageNamed:imgName]];
        imgView.tag = i;
        [imgArray addObject:imgView];
        [imgArray addObject:imgView];
    }
    //宽度:72.5    高度:107.5
    for(int row = 0;row<4;row++)
    {
        for(int colum = 0;colum<4;colum++)
        {
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50 + colum*72.5 + 6*(colum + 1), 64 + row*107.5 + 6*(row + 1), 72.5, 107.5)];
            //随机取出图片
            int index = arc4random() % [imgArray count];
            UIImageView * tmpImgView = (UIImageView *)[imgArray objectAtIndex:index];
            imgView.image = tmpImgView.image;
            imgView.tag = tmpImgView.tag;
            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipImgView:)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tapGesture];
            
            [imgArray removeObjectAtIndex:index];
            [imgViewDic setValue:imgView.image forKey:[NSString stringWithFormat:@"%ld",(long)imgView.tag]];
            [self.view addSubview:imgView];
            [self performSelector:@selector(flipBack:) withObject:imgView afterDelay:1.0];
        }
    }
    
    //记时 一
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setProgressViewValue) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //    二
     __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf setProgressViewValue];
    }];
    
    progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64 + 454, DH_DeviceWidth, 6)];
    [self.view addSubview:progress];
}
- (void) pictureRemoveAll
{
    for(UIView * subView in self.view.subviews)
    {
        [subView removeFromSuperview];
    }
}
- (void) setProgressViewValue
{
    progressValue += 1.0;
    [progress setProgress:progressValue/gameTime animated:YES];//重置进度条
    if(progressValue > gameTime)
    {
        //停用计时器
        [self.timer invalidate];
        self.timer = nil;

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"游戏提示" message:@"失败，重新开始" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
        return;
    }
//    else
//    {
//
//    }
}
- (void) flipBack:(UIImageView *) imgView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:(UIView *)imgView cache:YES];
    imgView.image = [UIImage imageNamed:@"flip.jpg"];
    imgView.userInteractionEnabled = YES;
    [UIView commitAnimations];
}
- (void) flipImgView:(id) sender
{
    UITapGestureRecognizer * tagGesture = (UITapGestureRecognizer *)sender;
    UIImageView * imgView =  (UIImageView *)tagGesture.view;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:(UIView *)imgView cache:YES];
    imgView.image = [imgViewDic objectForKey:[NSString stringWithFormat:@"%ld",(long)imgView.tag]];
    imgView.userInteractionEnabled = NO;
    [UIView commitAnimations];
    
    if(recordImageView == nil)
        recordImageView = imgView;
    else if(recordImageView.tag != imgView.tag)
    {
        [self performSelector:@selector(flipBack:) withObject:recordImageView afterDelay:1.0];
        [self performSelector:@selector(flipBack:) withObject:imgView afterDelay:1.0];
        recordImageView = nil;
    }
    else
    {
        score ++;
        if(score == 8)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"游戏提示" message:@"恭喜过关" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
        }
        recordImageView = nil;
    }
}

#pragma UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //游戏结束
    if(alertView.tag == 2)
    {
        
    }
    else if (alertView.tag == 1)    //过关
    {
        //设置游戏结束时间
        if(gameTime > 20)
            gameTime -= 10;
        else
            gameTime = 20;
    }
    
    progressValue = 0;
    [progress setProgress:0];
    score = 0;
    [imgViewDic removeAllObjects];
    
    [self performSelector:@selector(pictureRemoveAll) withObject:nil afterDelay:1.0f];
    [self performSelector:@selector(pictureLayout) withObject:nil afterDelay:1.0f];
}
#pragma --

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)dealloc
{
    [self.timer  invalidate];
    self.timer = nil;
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
