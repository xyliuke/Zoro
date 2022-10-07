//
// Created by 刘科 on 2022/10/5.
//

#import <Masonry/Masonry.h>
#import "NavigationViewController.h"
#import "NSObject+YYAdd.h"
#import "NSArray+YYAdd.h"

@implementation NavigationItem
@end


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
        self.contentView.layer.borderColor = UIColor.blackColor.CGColor;

        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.width.height.equalTo(@24);
            make.centerY.equalTo(self.contentView);
        }];

        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(6);
            make.centerY.equalTo(self.contentView);
        }];
        self.contentView.backgroundColor = [UIColor colorNamed:@"nav_item_bg_color"];
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
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor colorNamed:@"normal_text_color"];
    }
    return _label;
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorNamed:@"selected_nav_item"];
    } else {
        self.contentView.backgroundColor = [UIColor colorNamed:@"nav_item_bg_color"];
    }
}

- (void)setTitle:(NSString *)title icon:(UIImage *)icon {
    self.label.text = title;
    self.imageView.image = icon;
}


@end


@interface NavigationViewController() <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation NavigationViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(100);
    }];
    [self.collectionView reloadData];
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
//        _collectionView.contentInset = UIEdgeInsetsZero;
    }
    return _collectionView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
    [self.collectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    NavigationItem *item = self.items[indexPath.row];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    MainNavigationItemCollectionViewCell *navCell = (MainNavigationItemCollectionViewCell *)cell;
    [navCell setTitle:item.text icon:item.icon];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate itemSelected:indexPath.row];
    }
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width, 30);
}
@end