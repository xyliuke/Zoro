//
// Created by 刘科 on 2022/10/6.
//

#import <UIKit/UIKit.h>

@interface UIButton (Simple)
+ (nonnull instancetype)buttonWithText:(nullable NSString *)text fontSize:(CGFloat)fontSize textColorName:(nullable NSString *)textColorName event:(nullable void(^)(UIButton *sender))event;
@end