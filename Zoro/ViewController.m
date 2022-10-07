//
//  ViewController.m
//  Zoro
//
//  Created by 刘科 on 2022/10/3.
//

#import <Masonry/View+MASAdditions.h>
#import "ViewController.h"
#import "NavigationViewController.h"
#import "DetailViewController.h"
#import "YUV_UI/MainYUVView.h"

@interface ViewController ()<NavigationViewControllerDelegate>
@property (nonatomic, strong) UISplitViewController *splitViewController;
@property (nonatomic, strong) NavigationViewController *leftNavigationViewController;
@property (nonatomic, strong) DetailViewController *detailViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    NavigationItem *item1 = [NavigationItem new];
    item1.text = @"YUV检测";
    item1.icon = nil;
    item1.panelView = [MainYUVView new];

    NavigationItem *item2 = [NavigationItem new];
    item2.text = @"test";
    item2.icon = nil;
    item2.panelView = [UIView new];

    self.leftNavigationViewController.items = @[item1];
    [self.splitViewController showColumn:UISplitViewControllerColumnSecondary];
}

- (UISplitViewController *)splitViewController {
    if (!_splitViewController) {
        _splitViewController = [[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleDoubleColumn];
        [_splitViewController setViewController:self.leftNavigationViewController forColumn:UISplitViewControllerColumnPrimary];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
        [_splitViewController setViewController:navigationController forColumn:UISplitViewControllerColumnSecondary];
        _splitViewController.displayModeButtonVisibility = UISplitViewControllerDisplayModeButtonVisibilityNever;
        [_splitViewController setPreferredPrimaryColumnWidth:250];
        [_splitViewController setMinimumPrimaryColumnWidth:250];
        [_splitViewController setMaximumPrimaryColumnWidth:350];
        [self addChildViewController:_splitViewController];
        [self.view addSubview:_splitViewController.view];
        _splitViewController.view.frame = self.view.bounds;
        [self didMoveToParentViewController:_splitViewController];
    }
    return _splitViewController;
}

- (NavigationViewController *)leftNavigationViewController {
    if (!_leftNavigationViewController) {
        _leftNavigationViewController = [NavigationViewController new];
        _leftNavigationViewController.delegate = self;
    }
    return _leftNavigationViewController;
}

- (DetailViewController *)detailViewController {
    if (!_detailViewController) {
        _detailViewController = [DetailViewController new];
    }
    return _detailViewController;
}

- (void)itemSelected:(NSInteger)index {
    NavigationItem *item = self.leftNavigationViewController.items[index];
    [self.detailViewController updateView:item.panelView];
}

@end
