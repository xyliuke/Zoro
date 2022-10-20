//
// Created by 刘科 on 2022/10/16.
//

#import "YUVSettingView.h"
#import "UILabel+Simple.h"
#import "NSString+YYAdd.h"
#import "UIControl+YYAdd.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>

@interface YUVSettingView()
@property (nonatomic, strong) UIView *inputWrapView;
@property (nonatomic, strong) UILabel *widthLabel;
@property (nonatomic, strong) UITextField *widthView;
@property (nonatomic, strong) UILabel *heightLabel;
@property (nonatomic, strong) UITextField *heightView;
@end

@implementation YUVSettingView {

}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }

    return self;
}

- (NSUInteger)getWidth {
    return [self.widthView.text unsignedIntegerValue];
}

- (NSUInteger)getHeight {
    return [self.heightView.text unsignedIntegerValue];
}


- (void)setupUI {
    [self addSubview:self.inputWrapView];
    [self.inputWrapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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
        _widthView.text = @"0";
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
        _heightView.text = @"0";
        _heightView.textAlignment = NSTextAlignmentRight;
        _heightView.layer.masksToBounds = YES;
        _heightView.layer.cornerRadius = 4;
        _heightView.layer.borderColor = [UIColor colorNamed:@"button_bg_color"].CGColor;
        _heightView.layer.borderWidth = 0.5;
    }
    return _heightView;
}




@end
