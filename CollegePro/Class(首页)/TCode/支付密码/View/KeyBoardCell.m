//
//  KeyBoardCell.m
//  CollegePro
//
//  Created by jabraknight on 2020/5/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "KeyBoardCell.h"

@implementation KeyBoardCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
    }
    return self;
}
- (void)setup{
    [self keyboardBtn];
}

- (UIButton *)keyboardBtn{
    if (!_keyboardBtn){
        _keyboardBtn = [UIButton new];
//        [_keyboardBtn setBackgroundImage:[UIImage imageNamed:@"keyboard_key"] forState:UIControlStateNormal];
        [_keyboardBtn setTitle:@"按钮" forState:UIControlStateNormal];
        [_keyboardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_keyboardBtn addTarget:self action:@selector(KeyboardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_keyboardBtn];
        _keyboardBtn.frame = self.contentView.bounds;
    }
    return _keyboardBtn;
}

- (void)KeyboardBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KeyBoardCellBtnClick:)]){
        [self.delegate KeyBoardCellBtnClick:self.tag - 100];
    }
}

- (void)setModel:(KeyBoardModel *)model{
    if (_model != model){
        _model = model;
        if(!model.isUpper && self.tag > 9 + 100){
            NSString * string = [model.key lowercaseString];
            
            [self.keyboardBtn setTitle:string forState:UIControlStateNormal];
        }
        else{
            [self.keyboardBtn setTitle:model.key forState:UIControlStateNormal];
        }
    }
}
@end
