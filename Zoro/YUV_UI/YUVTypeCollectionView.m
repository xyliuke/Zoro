//
// Created by 刘科 on 2022/10/7.
//

#import "YUVTypeCollectionView.h"
#import "View+MASAdditions.h"
#import <YYCategories/YYCategories.h>

@implementation YUVTypeData
@end

@interface YUVTypeCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UISwitch *yuvSwitch;
@property (nonatomic, strong) BOOL(^selectChanged)(YUVTypeCollectionViewCell *cell, BOOL on);
- (void)update:(YUVTypeData *)data;
@end

@implementation YUVTypeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.yuvSwitch];
        [self.yuvSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }

    return self;
}


- (UISwitch *)yuvSwitch {
    if (!_yuvSwitch) {
        _yuvSwitch = [UISwitch new];
        _yuvSwitch.preferredStyle = UISwitchStyleCheckbox;
        _yuvSwitch.title = @"i420";
        @weakify(self)
        [_yuvSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
            @strongify(self)
            if (self.selectChanged) {
                BOOL ret = self.selectChanged(self, self.yuvSwitch.on);
                if (!ret) {
                    self.yuvSwitch.on = !self.yuvSwitch.on;
                }
            }
        }];
    }
    return _yuvSwitch;
}

- (void)update:(YUVTypeData *)data {
    self.yuvSwitch.title = data.text;
    self.yuvSwitch.on = data.selected;
}

@end

@interface YUVTypeCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation YUVTypeCollectionView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(6);
            make.right.bottom.equalTo(self).offset(-6);
        }];
    }

    return self;
}

- (void)setData:(NSArray<YUVTypeData *> *)data {
    _data = data;
    [self.collectionView reloadData];
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(60, 24);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:YUVTypeCollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YUVTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    YUVTypeData *data = self.data[indexPath.row];
    @weakify(self)
    cell.selectChanged = ^(YUVTypeCollectionViewCell *c, BOOL on) {
        @strongify(self)
        if (on) {
            for (YUVTypeData *d in self.data) {
                d.selected = NO;
            }
            data.selected = on;
            [self.collectionView reloadData];
            if (self.selectedChange) {
                self.selectedChange(self, data);
            }
            return YES;
        } else {
            return NO;
        }
    };
    [cell update:data];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}


@end