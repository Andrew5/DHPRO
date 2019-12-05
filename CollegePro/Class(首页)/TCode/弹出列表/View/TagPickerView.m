//
//  TagPickerView.m
//  PackageDemo
//
//  Created by 思 彭 on 2017/4/12.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "TagPickerView.h"
#import "HXTagsView.h"
#import "HXTagAttribute.h"
#import "UIViewExt.h"

static TagPickerView *shareInstance = nil;

#define TagsView_HEIGHT 234.0f  //TagsView高度
#define TOOLBAR_HEIGHT 40.0f    //底部toolBar高度
#define K_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define K_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define ButtonHeight 20.0f     // "取消""确定"按钮高度
#define ButtonWidth 60.0f      // "取消""确定"按钮宽度

@interface TagPickerView ()

@property (nonatomic, strong) UIView *toolbar;/**<选择器下方工具条 */
@property (nonatomic, strong) UIView *backView;/**<容器 */
@property (nonatomic, strong) HXTagsView *tagsView;
@property (nonatomic, strong) NSArray *currentSelectedTagsArray; /**<当前选择的标签数组 */

@end

@implementation TagPickerView

#pragma mark - Initial

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc]init];
    });
    [shareInstance show];
    return shareInstance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
        [self creatView];
    }
    return self;
}

#pragma mark - setUI

- (void)creatView {
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, K_SCREEN_HEIGHT, K_SCREEN_WIDTH, TagsView_HEIGHT+TOOLBAR_HEIGHT)];
    [self addSubview:self.backView];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.userInteractionEnabled = YES;
    
    self.tagsView = [[HXTagsView alloc]initWithFrame:CGRectMake(0, 0, K_SCREEN_WIDTH, TagsView_HEIGHT)];
    self.tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.tagsView.isMultiSelect = YES; // 可以多选
    self.tagsView.tagAttribute.borderColor = [UIColor orangeColor];
    self.tagsView.tagAttribute.cornerRadius = 5.0f;
    self.tagsView.tagAttribute.textColor = [UIColor darkGrayColor];
    self.tagsView.tagAttribute.tagSpace = 10.0f;
    self.tagsView.tagAttribute.normalBackgroundColor = [UIColor whiteColor];
    self.tagsView.tagAttribute.selectedBackgroundColor = [UIColor orangeColor];
    
    __weak typeof(self) weakSelf = self;
    self.tagsView.completion = ^(NSArray *selectTags, NSInteger currentIndex) {
        weakSelf.currentSelectedTagsArray = selectTags;
    };
    [self.backView addSubview:self.tagsView];
    // 底部的"取消""确定"按钮视图
    CGFloat space = 20.0f;
    CGFloat toolBarViewWidth = K_SCREEN_WIDTH - (2 * ButtonWidth) - (2 * space);
    self.toolbar = [[UIView alloc]initWithFrame:CGRectMake((K_SCREEN_WIDTH - toolBarViewWidth) / 2, self.tagsView.bottom, toolBarViewWidth, TOOLBAR_HEIGHT)];
    [self.backView addSubview:self.toolbar];
    NSArray *buttonTitleArray = @[@"取消", @"确定"];
    for (NSInteger i = 0; i < buttonTitleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake((i * ButtonWidth) + ((i + 1) * space), (self.toolbar.frame.size.height - ButtonHeight) / 2, ButtonWidth, ButtonHeight);
        btn.layer.cornerRadius = 10;
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [UIColor orangeColor].CGColor;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbar addSubview:btn];
    }
}

- (void)setTagsArray:(NSArray *)tagsArray {
    
    _tagsArray = tagsArray;
    self.tagsView.tags = self.tagsArray;
}

//添加手势
-(void)addTapGestureRecognizerToSelf {
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBottomView)];
    [self addGestureRecognizer:tap];
}

#pragma mark - DoAction

- (void)show {
    
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect newframe = self.backView.frame;
        newframe.origin.y = K_SCREEN_HEIGHT-TagsView_HEIGHT-TOOLBAR_HEIGHT;
        self.backView.frame = newframe;
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect newframe = self.backView.frame;
        newframe.origin.y = K_SCREEN_HEIGHT;
        self.backView.frame = newframe;
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

- (void)btnDidClick: (UIButton *)button {
    
    if ([button.titleLabel.text isEqualToString:@"取消"]) {
        NSLog(@"取消");
        [self dismiss];
    } else {
        NSLog(@"确定");
        if (self.currentSelectedTagsArray.count == 0) {
            NSLog(@"请先选择标签哟!!!...");
            return;
        }
        if (self.selectedTagBlock) {
            self.selectedTagBlock(self.currentSelectedTagsArray);
        }
        [self hiddenBottomView];
    }
}

- (void)hiddenBottomView {
    [self dismiss];
}

@end
