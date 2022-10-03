//
//  ViewController.m
//  Zoro
//
//  Created by 刘科 on 2022/10/3.
//

#import <Masonry/View+MASAdditions.h>
#import "ViewController.h"
#import "MainNavigationView.h"
#import "MainYUVView.h"

@interface ViewController ()
@property (nonatomic, strong) MainNavigationView *navigationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.navigationView];
    self.navigationView.backgroundColor = UIColor.cyanColor;
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(self.view).offset(28);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

- (MainNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [MainNavigationView new];

        NavigationItem *item1 = [NavigationItem new];
        item1.text = @"YUV";
        item1.icon = nil;
        item1.panelView = [MainYUVView new];

        NavigationItem *item2 = [NavigationItem new];
        item2.text = @"YUV-2";
        item2.icon = nil;
        item2.panelView = [UIView new];

        _navigationView.items = @[
                item1,
                item2
        ];
    }
    return _navigationView;
}


@end
