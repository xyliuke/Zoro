//
// Created by 刘科 on 2022/10/3.
//

#import <View+MASAdditions.h>
#import "MainYUVView.h"
#import "MacOpenPanel.h"
#import "UILabel+Simple.h"
#import "UIButton+Simple.h"
#import "YUVTypeCollectionView.h"
#import "YUVConvertor.h"
#include <YYCategories/YYCategories.h>

@interface MainYUVView()
@property (nonatomic, strong) UIView *settingView;
@property (nonatomic, strong) UIButton *openFileButton;
@property (nonatomic, strong) UIButton *openPreviewButton;
@property (nonatomic, strong) UILabel *openFileLabel;
@property (nonatomic, strong) NSURL *openFilePath;
@property (nonatomic, strong) YUVTypeCollectionView *yuvTypeView;
@property (nonatomic, strong) YUVTypeData *selectedYUVType;
@property (nonatomic, strong) UIView *inputWrapView;
@property (nonatomic, strong) UILabel *widthLabel;
@property (nonatomic, strong) UITextField *widthView;
@property (nonatomic, strong) UILabel *heightLabel;
@property (nonatomic, strong) UITextField *heightView;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) UIImageView *previewImageView;
@end

@implementation MainYUVView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

    [self.settingView addSubview:self.inputWrapView];
    [self.inputWrapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.settingView).offset(-16);
        make.top.equalTo(self.settingView).offset(16);
        make.left.equalTo(self.yuvTypeView.mas_right).offset(8);
        make.height.equalTo(@120);
        make.width.equalTo(@320);
    }];

    [self.inputWrapView addSubview:self.widthLabel];
    [self.inputWrapView addSubview:self.widthView];
    [self.widthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputWrapView).offset(16);
        make.top.equalTo(self.inputWrapView).offset(8);
        make.width.equalTo(@40);
    }];
    [self.widthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.widthLabel.mas_right).offset(6);
        make.centerY.equalTo(self.widthLabel);
        make.width.equalTo(@60);
        make.height.equalTo(@24);
    }];

    [self.inputWrapView addSubview:self.heightLabel];
    [self.inputWrapView addSubview:self.heightView];
    [self.heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.widthView.mas_right).offset(16);
        make.centerY.equalTo(self.widthLabel);
        make.width.equalTo(@40);
    }];
    [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heightLabel.mas_right).offset(6);
        make.centerY.equalTo(self.heightLabel);
        make.width.equalTo(@60);
        make.height.equalTo(@24);
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
            NSData *data = [NSData dataWithContentsOfURL:self.openFilePath];
            NSUInteger w = [self.widthView.text unsignedIntegerValue];
            NSUInteger h = [self.heightView.text unsignedIntegerValue];
            if (data.length <= w * h * 4) {
                //是图片
                UIImage *image = [self convertYUVToImage:data width:w height:h];
                self.previewImageView.image = image;
                self.previewImageView.hidden = NO;

            } else if (data.length > w * h) {
                //是视频
            }
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

- (UIView *)inputWrapView {
    if (!_inputWrapView) {
        _inputWrapView = [UIView new];
        _inputWrapView.layer.masksToBounds = YES;
        _inputWrapView.layer.cornerRadius = 4;
        _inputWrapView.layer.borderColor = [UIColor colorNamed:@"button_bg_color"].CGColor;
        _inputWrapView.layer.borderWidth = 0.5;
    }
    return _inputWrapView;
}

- (UILabel *)widthLabel {
    if (!_widthLabel) {
        _widthLabel = [UILabel labelWithText:@"宽度:" fontSize:14 textColorName:nil];
    }
    return _widthLabel;
}

- (UILabel *)heightLabel {
    if (!_heightLabel) {
        _heightLabel = [UILabel labelWithText:@"高度:" fontSize:14];
    }
    return _heightLabel;
}

- (UITextField *)widthView {
    if (!_widthView) {
        _widthView = [UITextField new];
        _widthView.textAlignment = NSTextAlignmentRight;
        _widthView.keyboardType = UIKeyboardTypeNamePhonePad;
        _widthView.layer.masksToBounds = YES;
        _widthView.layer.cornerRadius = 4;
        _widthView.layer.borderColor = [UIColor colorNamed:@"button_bg_color"].CGColor;
        _widthView.layer.borderWidth = 0.5;
    }
    return _widthView;
}

- (UITextField *)heightView {
    if (!_heightView) {
        _heightView = [UITextField new];
        _heightView.textAlignment = NSTextAlignmentRight;
        _heightView.layer.masksToBounds = YES;
        _heightView.layer.cornerRadius = 4;
        _heightView.layer.borderColor = [UIColor colorNamed:@"button_bg_color"].CGColor;
        _heightView.layer.borderWidth = 0.5;
    }
    return _heightView;
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

- (UIImage *)convertYUVToImage:(NSData *)data width:(int)width height:(int)height {
    if ([@"i420" isEqualToString: self.selectedYUVType.tag]) {
        return [YUVConvertor createImageFromBuffer:data type:I420 width:width height:height];
    } else if ([@"NV12" isEqualToString:self.selectedYUVType.tag]) {
        return [YUVConvertor createImageFromBuffer:data type:NV12 width:width height:height];
    } else if ([@"NV21" isEqualToString:self.selectedYUVType.tag]) {
        return [YUVConvertor createImageFromBuffer:data type:NV21 width:width height:height];
    }
    return nil;
}

@end
