//
// Created by 刘科 on 2022/10/7.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

@class UIImage;


@interface YUVConvertor : NSObject
+ (NSData *)i420ToNV12:(NSData *)data;
+ (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image;
+ (CVPixelBufferRef)createCVPixelBufferRefFromNV12Buffer:(unsigned char *)buffer width:(int)width height:(int)height;
+ (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBuffer;
@end