//
// Created by 刘科 on 2022/10/16.
//

#import <UIKit/UIKit.h>


@interface YUVSettingView : UIView
@property (nonatomic, strong) void(^yuvPartChanged)(YUVSettingView *view, BOOL y, BOOL u, BOOL v);
- (NSUInteger)getWidth;
- (NSUInteger)getHeight;
@end