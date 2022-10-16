//
// Created by 刘科 on 2022/10/3.
//

#import <View+MASAdditions.h>
#import "MainYUVView.h"
#import "MacOpenPanel.h"
#import "UILabel+Simple.h"
#import "UIButton+Simple.h"
#import "YUVTypeCollectionView.h"
#import "YUVSettingView.h"
#import <AVBase/YUVConvertor.h>
#include <YYCategories/YYCategories.h>

@interface MainYUVView()
@property (nonatomic, strong) UIView *settingView;
@property (nonatomic, strong) UIButton *openFileButton;
@property (nonatomic, strong) UIButton *openPreviewButton;
@property (nonatomic, strong) UILabel *openFileLabel;
@property (nonatomic, strong) NSURL *openFilePath;
@property (nonatomic, strong) YUVTypeCollectionView *yuvTypeView;
@property (nonatomic, strong) YUVTypeData *selectedYUVType;
@property (nonatomic, strong) YUVSettingView *inputSettingView;

@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) UIImageView *previewImageView;

@property (nonatomic) BOOL enableY;
@property (nonatomic) BOOL enableU;
@property (nonatomic) BOOL enableV;
@end

@implementation MainYUVView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.enableY = YES;
        self.enableU = YES;
        self.enableV = YES;
        [self setupUI];
    }

    return self;
}

- (void)setupUI {

    [self addSubview:self.settingView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
        make.top.equalTo(self).offset(2);
        make.height.equalTo(@150);
    }];

    [self.settingView addSubview:self.openFileButton];
    [self.openFileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.settingView).offset(16);
        make.top.equalTo(self.settingView).offset(16);
        make.width.equalTo(@100);
        make.height.equalTo(@24);
    }];

    [self.settingView addSubview:self.openFileLabel];
    [self.openFileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.openFileButton.mas_right).offset(8);
        make.centerY.equalTo(self.openFileButton);
        make.top.equalTo(self.openFileButton);
        make.bottom.equalTo(self.openFileButton);
    }];

    [self.settingView addSubview:self.openPreviewButton];
    [self.openPreviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.settingView).offset(16);
        make.width.equalTo(@100);
        make.height.equalTo(@24);
        make.bottom.equalTo(self.settingView).offset(-8);
    }];

    [self.settingView addSubview:self.yuvTypeView];
    [self.yuvTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settingView).offset(16);
        make.left.equalTo(self.openFileLabel.mas_right).offset(8);
        make.height.equalTo(@120);
        make.width.equalTo(@320);
    }];

    [self.settingView addSubview:self.inputSettingView];
    [self.inputSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.settingView).offset(-16);
        make.top.equalTo(self.settingView).offset(16);
        make.left.equalTo(self.yuvTypeView.mas_right).offset(8);
        make.height.equalTo(@120);
        make.width.equalTo(@320);
    }];



    [self addSubview:self.previewView];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.settingView.mas_bottom);
    }];

    [self.previewView addSubview:self.previewImageView];
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.previewView);
    }];
    self.previewImageView.hidden = YES;
}

- (UIView *)settingView {
    if (!_settingView) {
        _settingView = [UIView new];
        _settingView.layer.masksToBounds = YES;
        _settingView.layer.cornerRadius = 4;
        _settingView.layer.borderColor = [UIColor colorNamed:@"button_bg_color"].CGColor;
        _settingView.layer.borderWidth = 0.5;
    }
    return _settingView;
}

- (UIButton *)openFileButton {
    if (!_openFileButton) {
        @weakify(self)
        _openFileButton = [UIButton buttonWithText:@"打开文件" fontSize:14 textColorName:nil event:^(id sender) {
            @strongify(self)
            MacOpenPanel *openPanel = [MacOpenPanel new];
            openPanel.canChooseFiles = YES;
            openPanel.allowsMultipleSelection = NO;
            openPanel.prompt = @"test";
            [openPanel showPanelWithChosenFilesHandler:^(NSArray<NSURL *> *fileURLs) {
                if (fileURLs) {
                    self.openFilePath = fileURLs.firstObject;
                    self.openFileLabel.text = fileURLs.firstObject.absoluteString;
                }
            }];
        }];
    }
    return _openFileButton;
}

- (UILabel *)openFileLabel {
    if (!_openFileLabel) {
        _openFileLabel = [UILabel labelWithText:@"打开文件路径" fontSize:12 textColorName:nil];
        _openFileLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _openFileLabel.layer.masksToBounds = YES;
        _openFileLabel.layer.cornerRadius = 4;
        _openFileLabel.layer.borderColor = [UIColor colorNamed:@"button_bg_color"].CGColor;
        _openFileLabel.layer.borderWidth = 0.5;
    }
    return _openFileLabel;
}

- (UIButton *)openPreviewButton {
    if (!_openPreviewButton) {
        _openPreviewButton = [UIButton buttonWithText:@"预览" fontSize:14 textColorName:nil event:^(UIButton *sender) {
            [self previewYUV];
        }];
    }
    return _openPreviewButton;
}


- (YUVTypeCollectionView *)yuvTypeView {
    if (!_yuvTypeView) {
        _yuvTypeView = [YUVTypeCollectionView new];
        _yuvTypeView.layer.masksToBounds = YES;
        _yuvTypeView.layer.cornerRadius = 4;
        _yuvTypeView.layer.borderColor = [UIColor colorNamed:@"button_bg_color"].CGColor;
        _yuvTypeView.layer.borderWidth = 0.5;
        @weakify(self);
        _yuvTypeView.selectedChange = ^(YUVTypeCollectionView *view, YUVTypeData *selectedData) {
            @strongify(self);
            self.selectedYUVType = selectedData;
        };

        YUVTypeData *data1 = [YUVTypeData new];
        data1.tag = @"i420";
        data1.text = @"i420";
        data1.selected = YES;

        YUVTypeData *data2 = [YUVTypeData new];
        data2.tag = @"NV12";
        data2.text = @"NV12";

        YUVTypeData *data3 = [YUVTypeData new];
        data3.tag = @"NV21";
        data3.text = @"NV21";

        self.selectedYUVType = data1;
        _yuvTypeView.data = @[data1, data2, data3];
    }
    return _yuvTypeView;
}

- (YUVSettingView *)inputSettingView {
    if (!_inputSettingView) {
        _inputSettingView = [YUVSettingView new];
        @weakify(self)
        _inputSettingView.yuvPartChanged = ^(YUVSettingView *view, BOOL y, BOOL u, BOOL v) {
            @strongify(self)
            self.enableY = y;
            self.enableU = u;
            self.enableV = v;
            [self previewYUV];
        };
    }
    return _inputSettingView;
}



- (UIView *)previewView {
    if (!_previewView) {
        _previewView = [UIView new];
    }
    return _previewView;
}

- (UIImageView *)previewImageView {
    if (!_previewImageView) {
        _previewImageView = [UIImageView new];
        _previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _previewImageView;
}

- (UIImage *)convertYUVToImage:(NSData *)data width:(NSUInteger)width height:(NSUInteger)height {
    if ([@"i420" isEqualToString: self.selectedYUVType.tag]) {
        return [YUVConvertor createImageFromBuffer:data type:I420 width:width height:height enableY:self.enableY enableU:self.enableU enableV:self.enableV];
    } else if ([@"NV12" isEqualToString:self.selectedYUVType.tag]) {
        return [YUVConvertor createImageFromBuffer:data type:NV12 width:width height:height enableY:self.enableY enableU:self.enableU enableV:self.enableV];
    } else if ([@"NV21" isEqualToString:self.selectedYUVType.tag]) {
        return [YUVConvertor createImageFromBuffer:data type:NV21 width:width height:height enableY:self.enableY enableU:self.enableU enableV:self.enableV];
    }
    return nil;
}

- (void)previewYUV {
    NSData *data = [NSData dataWithContentsOfURL:self.openFilePath];
    NSUInteger w = [self.inputSettingView getWidth];
    NSUInteger h = [self.inputSettingView getHeight];
    if (data.length <= w * h * 4) {
        //是图片
        UIImage *image = [self convertYUVToImage:data width:w height:h];
        self.previewImageView.image = image;
        self.previewImageView.hidden = NO;

    } else if (data.length > w * h) {
        //是视频
    }
}

@end
