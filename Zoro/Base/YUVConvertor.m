//
// Created by 刘科 on 2022/10/7.
//

#import <UIKit/UIKit.h>
#import "YUVConvertor.h"

@implementation YUVConvertor {

}

+ (NSData *)yuvToNV12:(NSData *)data type:(YUV_TYPE)type {
    switch (type) {
        case I420:
            return [self i420ToNV12:data];
        case NV12:
            return data;
        case NV21:
            return [self NV21ToNV12:data];
        default:
            break;
    }
    return data;
}


+ (NSData *)i420ToNV12:(NSData *)data {
    NSMutableData *ret = [[NSMutableData alloc] initWithCapacity:data.length];
    NSUInteger yLength = (NSUInteger)(data.length / 1.5);
    [ret appendData:[data subdataWithRange:NSMakeRange(0, yLength)]];
    NSUInteger uLength = yLength / 4;
    NSData *uData = [data subdataWithRange:NSMakeRange(yLength, uLength)];
    NSData *vData = [data subdataWithRange:NSMakeRange(yLength + uLength, uLength)];
    for (int i = 0; i < uLength; ++i) {
        [ret appendData:[uData subdataWithRange:NSMakeRange(i, 1)]];
        [ret appendData:[vData subdataWithRange:NSMakeRange(i, 1)]];
    }
    return ret;
}

+ (NSData *)NV21ToNV12:(NSData *)data {
    NSMutableData *ret = [[NSMutableData alloc] initWithCapacity:data.length];
    NSUInteger yLength = (NSUInteger)(data.length / 1.5);
    [ret appendData:[data subdataWithRange:NSMakeRange(0, yLength)]];
    NSUInteger uvLength = yLength / 2;
    for (int i = 0; i < uvLength; i += 2) {
        [ret appendData:[data subdataWithRange:NSMakeRange(yLength + i + 1, 1)]];//U
        [ret appendData:[data subdataWithRange:NSMakeRange(yLength + i, 1)]];//V
    }
    return ret;
}


+ (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image {
    return [self pixelBufferFromCGImage:image.CGImage pixelFormatType:kCVPixelFormatType_32BGRA resizeSize:image.size];
}

+ (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image pixelFormatType:(OSType)pixelFormatType resizeSize:(CGSize)resizeSize {
    BOOL hasAlpha = IsCGImageRefContainsAlphaTTLive(image);
    CFDictionaryRef empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
            @(YES), (NSString *)kCVPixelBufferCGImageCompatibilityKey,
            @(YES), (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey,
            empty, (NSString *)kCVPixelBufferIOSurfacePropertiesKey,
                    nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, resizeSize.width, resizeSize.height, pixelFormatType, (__bridge CFDictionaryRef) options, &pxbuffer);

    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);

    if (status != kCVReturnSuccess) {
        return NULL;
    }

    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata;
    if (pixelFormatType == kCVPixelFormatType_OneComponent8) {
        pxdata = CVPixelBufferGetBaseAddressOfPlane(pxbuffer,0);
    }else {
        pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    }

    NSParameterAssert(pxdata != NULL);
    if (pxdata == NULL) {
        CVPixelBufferRelease(pxbuffer);
        return NULL;
    }


    CGColorSpaceRef colorSpace;
    size_t bytesPerRow;
    if (pixelFormatType == kCVPixelFormatType_OneComponent8) {
        colorSpace = CGColorSpaceCreateDeviceGray();
        bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pxbuffer, 0);
    }else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        bytesPerRow = CVPixelBufferGetBytesPerRow(pxbuffer);
    }
    uint32_t bitmapInfo = bitmapInfoWithPixelFormatTypeTTLive(pixelFormatType, (bool)hasAlpha);

    CGContextRef context = CGBitmapContextCreate(pxdata, resizeSize.width, resizeSize.height, 8, bytesPerRow, colorSpace, bitmapInfo);
    NSParameterAssert(context);
    if (context == NULL) {
        CVPixelBufferRelease(pxbuffer);
        return NULL;
    }

    CGContextDrawImage(context, CGRectMake(0, 0, resizeSize.width, resizeSize.height), image);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);

    return pxbuffer;
}

// alpha的判断
BOOL IsCGImageRefContainsAlphaTTLive(CGImageRef imageRef) {
    if (!imageRef) {
        return NO;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
            alphaInfo == kCGImageAlphaNoneSkipFirst ||
            alphaInfo == kCGImageAlphaNoneSkipLast);
    return hasAlpha;
}

static uint32_t bitmapInfoWithPixelFormatTypeTTLive(OSType inputPixelFormat, bool hasAlpha){

    if (inputPixelFormat == kCVPixelFormatType_32BGRA) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
        if (!hasAlpha) {
            bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host;
        }
        return bitmapInfo;
    }else if (inputPixelFormat == kCVPixelFormatType_32ARGB) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
        return bitmapInfo;
    }else if (inputPixelFormat == kCVPixelFormatType_OneComponent8) {
        uint32_t bitmapInfo = kCGImageAlphaNone;
        return bitmapInfo;
    }else{
        NSLog(@"不支持此格式");
        return 0;
    }
}

+ (UIImage *)createImageFromBuffer:(NSData *)buffer type:(YUV_TYPE)type width:(int)width height:(int)height {
    CVPixelBufferRef pixelBuffer = [self createCVPixelBufferRefFromBuffer:buffer type:type width:width height:height];
    UIImage *image = [self imageFromPixelBuffer:pixelBuffer];
    CVPixelBufferRelease(pixelBuffer);
    return image;
}

+ (CVPixelBufferRef)createCVPixelBufferRefFromBuffer:(NSData *)buffer type:(YUV_TYPE)type width:(int)width height:(int)height {
    NSData *nv12Data = [self yuvToNV12:buffer type:type];
    return [self createCVPixelBufferRefFromNV12Buffer:[nv12Data bytes] width:width height:height];
}


+ (CVPixelBufferRef)createCVPixelBufferRefFromNV12Buffer:(unsigned char *)buffer width:(int)width height:(int)height {
    NSDictionary *pixelAttributes = @{(NSString*)kCVPixelBufferIOSurfacePropertiesKey:@{}};
    
    CVPixelBufferRef pixelBuffer = NULL;
    
    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                          width,
                                          height,
                                          kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                                          (__bridge CFDictionaryRef)(pixelAttributes),
                                          &pixelBuffer);//kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
    
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    unsigned char *yDestPlane = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    
    // Here y_ch0 is Y-Plane of YUV(NV12) data.
    unsigned char *y_ch0 = buffer;
    size_t yHeight = CVPixelBufferGetHeightOfPlane(pixelBuffer, 0);
    size_t yStride = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
    for (int i = 0; i< yHeight; i ++) {
        memset(yDestPlane + i * yStride, 0, yStride);
        memcpy(yDestPlane + i * yStride, y_ch0 + i * width, width);
    }
    unsigned char *uvDestPlane = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    
    unsigned char *y_ch1 = buffer + width * height;
    // Here y_ch1 is UV-Plane of YUV(NV12) data.
    size_t uvHeight = CVPixelBufferGetHeightOfPlane(pixelBuffer, 1);
    size_t uvStride = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);
    
    for (int i = 0; i< uvHeight; i ++) {
        memset(uvDestPlane + i * uvStride, 0, uvStride);
        memcpy(uvDestPlane + i * uvStride, y_ch1 + i * width, width);
    }
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    if (result != kCVReturnSuccess) {
        NSLog(@"Unable to create cvpixelbuffer %d", result);
    }
    return pixelBuffer;
}

+ (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    UIImage *image = [UIImage imageWithCIImage:ciImage];
    return image;
}

@end
