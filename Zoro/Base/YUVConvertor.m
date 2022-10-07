//
// Created by 刘科 on 2022/10/7.
//

#import <UIKit/UIKit.h>
#import "YUVConvertor.h"


@implementation YUVConvertor {

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

+ (CVPixelBufferRef)createCVPixelBufferRefFromNV12Buffer:(unsigned char *)buffer width:(int)width height:(int)height {
    NSDictionary *pixelAttributes = @{(NSString*)kCVPixelBufferIOSurfacePropertiesKey:@{}};

    CVPixelBufferRef pixelBuffer = NULL;

    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
            (size_t)width,
            (size_t)height,
            kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
            (__bridge CFDictionaryRef)(pixelAttributes),
            &pixelBuffer);

    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    unsigned char *yDestPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);

    // Here y_ch0 is Y-Plane of YUV(NV12) data.
    unsigned char *y_ch0 = buffer;
    memcpy(yDestPlane, y_ch0, width * height);
    unsigned char *uvDestPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);

    // Here y_ch1 is UV-Plane of YUV(NV12) data.
    unsigned char *y_ch1 = buffer + width * height;
    memcpy(uvDestPlane, y_ch1, width * height / 2);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    if (result != kCVReturnSuccess) {
        NSLog(@"Unable to create cvpixelbuffer %d", result);
    }
    return pixelBuffer;
}

+ (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    size_t w = CVPixelBufferGetWidth(pixelBuffer);
    size_t h = CVPixelBufferGetHeight(pixelBuffer);
    CIImage *ciimage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef cgImage = [context createCGImage:ciimage fromRect:CGRectMake(0, 0, w, h)];
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
    UIImage *image = [UIImage imageWithCIImage:ciimage];
//    CGImageRelease(cgImage);
    return image;
}

@end