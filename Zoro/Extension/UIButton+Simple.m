//
// Created by 刘科 on 2022/10/6.
//

#import "UIButton+Simple.h"
#include <YYCategories/UIControl+YYAdd.h>

@implementation UIButton (Simple)
+ (instancetype)buttonWithText:(NSString *)text fontSize:(CGFloat)fontSize textColorName:(NSString *)textColorName event:(void (^)(UIButton *sender))event {
    UIButton *button = [UIButton new];
    [button setTitle:text forState:UIControlStateNormal];
    UIColor *color = [UIColor colorNamed:textColorName ?: @"normal_text_color"];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    button.backgroundColor = [UIColor colorNamed:@"button_bg_color"];
    [button addBlockForControlEvents:UIControlEventTouchUpInside block:event];
    return button;
}

@end