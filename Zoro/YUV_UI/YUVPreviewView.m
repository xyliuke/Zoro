//
//  YUVPreviewView.m
//  Zoro
//
//  Created by 刘科 on 2022/10/19.
//

#import "YUVPreviewView.h"
#import <Masonry/Masonry.h>
#import "UILabel+Simple.h"
#import <AVBase/YUVConvertor.h>
#import <YYCategories/YYCategories.h>

@interface YUVFrameCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *numLabel;
@end

@implementation YUVFrameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        self.numLabel = [UILabel labelWithText:@"" fontSize:14];
        self.numLabel.layer.masksToBounds = YES;
        self.numLabel.layer.cornerRadius = 4;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
        [self.imageView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView);
            make.bottom.equalTo(self.imageView.mas_bottom).offset(-8);
            make.height.equalTo(@24);
            make.width.equalTo(@36);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.imageView.layer.borderColor = UIColor.redColor.CGColor;
        self.imageView.layer.borderWidth = 1;
    } else {
        self.imageView.layer.borderColor = nil;
        self.imageView.layer.borderWidth = 0;
    }
    
}
@end

@interface YUVPreviewView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *settingView;

@property (nonatomic, strong) UISwitch *ySwitch;//Y分量是否可用
@property (nonatomic, strong) UISwitch *uSwitch;
@property (nonatomic, strong) UISwitch *vSwitch;
@property (nonatomic) BOOL enableY;
@property (nonatomic) BOOL enableU;
@property (nonatomic) BOOL enableV;

@end

@implementation YUVPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showNum = YES;
        self.enableY = YES;
        self.enableU = YES;
        self.enableV = YES;
        [self setupUI];
    }
    return self;
}

- (void)show:(NSUInteger)index {
    if (index < self.images.count) {
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathWithIndex:index] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathWithIndex:index] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        self.imageView.image = self.images[index].image;
    }
}


- (void)setupUI {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@80);
    }];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.collectionView.mas_bottom);
    }];
    
    [self addSubview:self.settingView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.equalTo(self.imageView.mas_right);
        make.bottom.equalTo(self);
        make.width.equalTo(@300);
        make.right.equalTo(self);
    }];
    
    UIView *yuvView = [UIView new];
    [self.settingView addSubview:yuvView];
    [yuvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.settingView);
        make.top.equalTo(self.settingView).offset(8);
        make.height.equalTo(@24);
        make.right.equalTo(self.settingView);
    }];
    UILabel *yuvLabel = [UILabel labelWithText:@"YUV分量" fontSize:14];
    [yuvView addSubview:yuvLabel];
    [yuvView addSubview:self.ySwitch];
    [yuvView addSubview:self.uSwitch];
    [yuvView addSubview:self.vSwitch];
    
    [yuvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yuvView).offset(8);
        make.centerY.equalTo(yuvView);
        make.width.equalTo(@100);
    }];
    
    [self.ySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yuvLabel.mas_right).offset(8);
        make.centerY.equalTo(yuvView);
    }];

    [self.uSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ySwitch.mas_right);
        make.centerY.equalTo(yuvView);
        make.width.equalTo(self.ySwitch);
    }];

    [self.vSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uSwitch.mas_right);
        make.centerY.equalTo(yuvView);
        make.width.equalTo(self.uSwitch);
        make.right.equalTo(yuvView);
    }];
}

- (void)setImages:(NSArray<YUVImageData *> *)images {
    _images = images;
    [self.collectionView reloadData];
    self.imageView.image = images.firstObject.image;
    if (images.count > 0) {
        self.settingView.hidden = NO;
    } else {
        self.settingView.hidden = YES;
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIView *)settingView {
    if (!_settingView) {
        _settingView = [UIView new];
        _settingView.layer.borderColor = [UIColor colorWithRGBA:0x05050550].CGColor;
        _settingView.layer.borderWidth = 1;
        _settingView.hidden = YES;
    }
    return _settingView;
}

- (UISwitch *)ySwitch {
    if (!_ySwitch) {
        _ySwitch = [UISwitch new];
        _ySwitch.title = @"Y";
        _ySwitch.on = YES;
        _ySwitch.preferredStyle = UISwitchStyleCheckbox;
        @weakify(self)
        [_ySwitch addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
            @strongify(self)
            UISwitch *aSwitch = (UISwitch *)sender;
            self.enableY = aSwitch.on;
            [self modifySelectedImageYUV];
        }];
    }
    return _ySwitch;
}

- (UISwitch *)uSwitch {
    if (!_uSwitch) {
        _uSwitch = [UISwitch new];
        _uSwitch.title = @"U";
        _uSwitch.on = YES;
        _uSwitch.preferredStyle = UISwitchStyleCheckbox;
        @weakify(self)
        [_uSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
            @strongify(self)
            UISwitch *aSwitch = (UISwitch *)sender;
            self.enableU = aSwitch.on;
            [self modifySelectedImageYUV];
        }];
    }
    return _uSwitch;
}

- (UISwitch *)vSwitch {
    if (!_vSwitch) {
        _vSwitch = [UISwitch new];
        _vSwitch.on = YES;
        _vSwitch.title = @"V";
        _vSwitch.preferredStyle = UISwitchStyleCheckbox;
        @weakify(self)
        [_vSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
            @strongify(self)
            UISwitch *aSwitch = (UISwitch *)sender;
            self.enableV = aSwitch.on;
            [self modifySelectedImageYUV];
        }];
    }
    return _vSwitch;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(120, 80);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:YUVFrameCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
        _collectionView.showsHorizontalScrollIndicator = YES;
    }
    return _collectionView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YUVFrameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = self.images[indexPath.row].image;
    if (self.showNum) {
        cell.numLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    }
    cell.numLabel.hidden = !self.showNum;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self modifyImageYUVByIndex:indexPath.row];
}

- (void)modifySelectedImageYUV {
    [self modifyImageYUVByIndex:[self.collectionView indexPathsForSelectedItems].firstObject.row];
}

- (void)modifyImageYUVByIndex:(NSUInteger)index {
    if (index < self.images.count) {
        YUVImageData *data = self.images[index];
        self.imageView.image = [YUVConvertor createImageFromBuffer:data.data type:data.type width:data.width height:data.height enableY:self.enableY enableU:self.enableU enableV:self.enableV];
    }
}

@end
