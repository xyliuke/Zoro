//
//  MainNavigationView.m
//  Zoro
//
//  Created by 刘科 on 2022/10/3.
//

#import <Masonry/View+MASAdditions.h>
#import <YYCategories/UIColor+YYAdd.h>
#import "MainNavigationView.h"

@interface MainNavigationItemCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
- (void)setTitle:(NSString *)title icon:(UIImage *)icon;
@end

@implementation MainNavigationItemCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];

        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.width.height.equalTo(@24);
            make.centerY.equalTo(self.contentView);
        }];

        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(6);
            make.centerY.equalTo(self.contentView);
        }];
        self.contentView.backgroundColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.1];
    }

    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    if (selected) {
        self.backgroundColor = UIColor.blueColor;
    } else {
        self.backgroundColor = UIColor.clearColor;
    }
}

- (void)setTitle:(NSString *)title icon:(UIImage *)icon {
    self.label.text = title;
    self.imageView.image = icon;
}


@end

@interface MainNavigationPanelCollectionViewCell : UICollectionViewCell
- (void)update:(UIView *)view;
@end

@implementation MainNavigationPanelCollectionViewCell
- (void)update:(UIView *)view {
    [view removeFromSuperview];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end

@implementation NavigationItem
@end

@interface MainNavigationView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *splitView;
@property (nonatomic, strong) UICollectionView *panelCollectionView;
@end

@implementation MainNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.collectionView];
    [self addSubview:self.splitView];
    [self addSubview:self.panelCollectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@200);
    }];

    [self.splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.collectionView.mas_right);
        make.width.equalTo(@20);
    }];

    [self.panelCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.splitView.mas_right);
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:MainNavigationItemCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
//        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.contentInset = UIEdgeInsetsZero;
    }
    return _collectionView;
}

- (UIView *)splitView {
    if (!_splitView) {
        _splitView = [UIView new];
        _splitView.backgroundColor = [UIColor redColor];
    }
    return _splitView;
}

- (UICollectionView *)panelCollectionView {
    if (!_panelCollectionView) {
        UICollectionViewLayout *layout = [UICollectionViewFlowLayout new];
        _panelCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _panelCollectionView.delegate = self;
        _panelCollectionView.dataSource = self;
        [_panelCollectionView registerClass:MainNavigationPanelCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
        _panelCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _panelCollectionView.scrollEnabled = NO;
        _panelCollectionView.showsHorizontalScrollIndicator = NO;
        _panelCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _panelCollectionView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView reloadData];
    [self.panelCollectionView reloadData];
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    NavigationItem *item = self.items[indexPath.row];
    if ([collectionView isEqual:self.collectionView]) {
        //左侧导航
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        MainNavigationItemCollectionViewCell *navCell = (MainNavigationItemCollectionViewCell *)cell;

        navCell.imageView.image = item.icon;
        navCell.label.text = item.text;
    } else if ([collectionView isEqual:self.panelCollectionView]) {
        //右侧显示
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        MainNavigationPanelCollectionViewCell *panelCell = (MainNavigationPanelCollectionViewCell *)cell;
        [panelCell update:item.panelView];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        [self.panelCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        return CGSizeMake(self.collectionView.bounds.size.width, 30);
    } else if ([collectionView isEqual:self.panelCollectionView]) {
        return self.panelCollectionView.bounds.size;
    }
    return CGSizeZero;
}


@end
