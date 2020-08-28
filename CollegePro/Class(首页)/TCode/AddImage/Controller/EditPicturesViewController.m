//
//  EditPicturesViewController.m
//  LegendSmart_ManageEdition
//
//  Created by M on 16/8/29.
//  Copyright © 2016年 hanyegang. All rights reserved.
//

#import "EditPicturesViewController.h"

@interface EditPicturesViewController ()<UIScrollViewDelegate>
{
    UIScrollView * scroll;
    UILabel * lableNumber;
    UIView * view;
}
@end

@implementation EditPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(shanchu:)];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(popViewController:)];
    
    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    scroll.delegate=self;
    scroll.bounces=NO;
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scroll];
    [self imageView];
    
    self.title =[NSString stringWithFormat:@"%ld/%lu",self.integer+1,(unsigned long)self.imageArray.count];

    
    
   

}
- (void)imageView{
    for (UIImageView * imageView in [scroll subviews]) {
        [imageView removeFromSuperview];
    }
    for (int i = 0 ; i < self.imageArray.count; i ++) {
        UIImageView * BackImag=[[UIImageView alloc]initWithFrame:CGRectMake(10+(self.view.frame.size.width-10)*i+10*i, 0,self.view.frame.size.width-20,self.view.frame.size.height)];
        BackImag.contentMode = UIViewContentModeScaleAspectFit;
        BackImag.userInteractionEnabled=YES;
        BackImag.image = self.imageArray[i];
        [scroll addSubview:BackImag];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapZX:)];
        tap.numberOfTapsRequired=1;
        tap.numberOfTouchesRequired=1;
        [BackImag addGestureRecognizer:tap];
        
    }
    scroll.contentOffset=CGPointMake(self.view.frame.size.width*self.integer+1,0);
    scroll.pagingEnabled=YES;
    scroll.contentSize=CGSizeMake(self.view.frame.size.width*self.imageArray.count,0);
}
- (void)shanchu:(id)sender{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认删除图片?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.imageArray removeObjectAtIndex:self.integer];
        [self.selectedAssets removeObjectAtIndex:self.integer];
        self.integer-=1;
        self.title =[NSString stringWithFormat:@"%ld/%lu",self.integer+1,(unsigned long)self.imageArray.count];
        if (self.imageArray.count!=0){
            [self imageView];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)popViewController:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger i=scrollView.contentSize.width/self.view.frame.size.width;
    self.integer=scrollView.contentOffset.x/self.view.frame.size.width;
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.integer+1,(long)i];
}
- (void)tapZX:(UITapGestureRecognizer *)sender{
    
}

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
