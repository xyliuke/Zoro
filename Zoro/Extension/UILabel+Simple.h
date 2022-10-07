//
// Created by 刘科 on 2022/10/6.
//

#import <UIKit/UIKit.h>

@interface UILabel (Simple)
+ (nonnull instancetype)labelWithText:(nullable NSString *)text fontSize:(CGFloat)fontSize textColor:(nullable UIColor *)textColor;
+ (nonnull instancetype)labelWithText:(nullable NSString *)text fontSize:(CGFloat)fontSize textColorName:(nullable NSString *)textColorName;
+ (nonnull instancetype)labelWithText:(nullable NSString *)text fontSize:(CGFloat)fontSize;
@end