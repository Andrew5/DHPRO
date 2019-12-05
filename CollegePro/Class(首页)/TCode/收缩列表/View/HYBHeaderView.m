//
//  HYBHeaderView.m
//  SectionAnimationDemo
//
//  Created by huangyibiao on 16/6/8.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBHeaderView.h"
#import "HYBSectionModel.h"

@interface HYBHeaderView ()

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYBHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expanded"]];
    self.arrowImageView.frame = CGRectMake(10, (44 - 8) / 2, 15, 8);
    [self.contentView addSubview:self.arrowImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onExpand:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    button.frame = CGRectMake(0, 0, w, 44);
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 200, 44)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.titleLabel];
    self.contentView.backgroundColor = [UIColor purpleColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, w, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
  }
  
  return self;
}

- (void)setModel:(HYBSectionModel *)model {
  if (_model != model) {
    _model = model;
  }
  
  
  if (model.isExpanded) {
    self.arrowImageView.transform = CGAffineTransformIdentity;
  } else {
    self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
  }
  
  
  self.titleLabel.text = model.sectionTitle;
}

- (void)onExpand:(UIButton *)sender {
  self.model.isExpanded = !self.model.isExpanded;
  
  [UIView animateWithDuration:0.25 animations:^{
    if (self.model.isExpanded) {
      self.arrowImageView.transform = CGAffineTransformIdentity;
    } else {
      self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
  }];
  
  if (self.expandCallback) {
    self.expandCallback(self.model.isExpanded);
  }
}

@end
