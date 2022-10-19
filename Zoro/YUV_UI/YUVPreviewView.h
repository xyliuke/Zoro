//
//  YUVPreviewView.h
//  Zoro
//
//  Created by 刘科 on 2022/10/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YUVPreviewView : UIView
@property (nonatomic, strong) NSArray<UIImage*> *images;//多帧图片预览
//选中的图片有变化，针对多帧图片
@property (nonatomic, strong) void(^selectImageChanged)(YUVPreviewView *view, NSUInteger index);
//针对多帧图片时播放操作，只有一张图片时，不生效
- (void)start;
- (void)pause;
- (void)stop;
- (void)show:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
