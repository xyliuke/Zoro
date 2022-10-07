//
// Created by 刘科 on 2022/10/7.
//

#import <UIKit/UIKit.h>

@interface YUVTypeData : NSObject
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL selected;
@end

@interface YUVTypeCollectionView : UIView
@property (nonatomic, strong) NSArray<YUVTypeData *> *data;
@property (nonatomic, strong) void(^selectedChange)(YUVTypeCollectionView *yuvView, YUVTypeData *selectedData);
@end