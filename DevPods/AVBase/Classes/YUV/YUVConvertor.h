//
// Created by 刘科 on 2022/10/7.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

@class UIImage;

typedef NS_ENUM(NSUInteger, YUV_TYPE){
    I420,
    NV12,
    NV21
};


@interface YUVConvertor : NSObject
+ (NSData *)yuvToNV12:(NSData *)data type:(YUV_TYPE)type;
+ (NSData *)i420ToNV12:(NSData *)data;
+ (NSData *)NV21ToNV12:(NSData *)data;
+ (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image;
+ (UIImage *)createImageFromBuffer:(NSData *)buffer type:(YUV_TYPE)type width:(NSUInteger)width height:(NSUInteger)height;
+ (UIImage *)createImageFromBuffer:(NSData *)buffer type:(YUV_TYPE)type width:(NSUInteger)width height:(NSUInteger)height enableY:(BOOL)enableY enableU:(BOOL)enableU enableV:(BOOL)enableV;
+ (CVPixelBufferRef)createCVPixelBufferRefFromBuffer:(NSData *)buffer type:(YUV_TYPE)type width:(NSUInteger)width height:(NSUInteger)height;
+ (CVPixelBufferRef)createCVPixelBufferRefFromBuffer:(NSData *)buffer type:(YUV_TYPE)type width:(NSUInteger)width height:(NSUInteger)height enableY:(BOOL)enableY enableU:(BOOL)enableU enableV:(BOOL)enableV;
+ (CVPixelBufferRef)createCVPixelBufferRefFromNV12Buffer:(unsigned char *)buffer width:(NSUInteger)width height:(NSUInteger)height;
+ (CVPixelBufferRef)createCVPixelBufferRefFromNV12Buffer:(unsigned char *)buffer width:(NSUInteger)width height:(NSUInteger)height enableY:(BOOL)enableY enableU:(BOOL)enableU enableV:(BOOL)enableV;
+ (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBuffer;
@end
