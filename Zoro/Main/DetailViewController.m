//
// Created by 刘科 on 2022/10/6.
//

#import "DetailViewController.h"
#import "View+MASAdditions.h"
#import "DetailViewControllerDelegate.h"


@interface DetailViewController()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation DetailViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorNamed:@"normal_bg_color"];
}

- (void)updateView:(__kindof id<DetailSubViewDelegate>)view {
    if ([view isKindOfClass:UIView.class]) {
        [(UIView *)view removeFromSuperview];
        [self.contentView removeFromSuperview];
        self.contentView = (UIView *)view;
        view.delegate = self;
        [self.view addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(28);
        }];
    }
}

- (void)detailPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)detailPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
