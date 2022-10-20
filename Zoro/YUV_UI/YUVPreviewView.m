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
@end

@implementation YUVPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showNum = YES;
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
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.collectionView.mas_bottom);
    }];
}

- (void)setImages:(NSArray<YUVImageData *> *)images {
    _images = images;
    [self.collectionView reloadData];
    self.imageView.image = images.firstObject.image;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
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
    self.imageView.image = self.images[indexPath.row].image;
}

@end
