//
// Created by 刘科 on 2022/10/6.
//

#import "UILabel+Simple.h"


@implementation UILabel (Simple)
+ (instancetype)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    UILabel *label = [UILabel new];
    if (textColor) {
        label.textColor = textColor;
    } else {
        label.textColor = [UIColor colorNamed:@"normal_text_color"];
    }
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

+ (instancetype)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColorName:(NSString *)textColorName {
    UILabel *label = [UILabel new];
    if (textColorName) {
        label.textColor = [UIColor colorNamed:textColorName];
    } else {
        label.textColor = [UIColor colorNamed:@"normal_text_color"];
    }
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

+ (instancetype)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    return [self labelWithText:text fontSize:fontSize textColorName:nil];
}

@end