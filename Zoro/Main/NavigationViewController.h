//
// Created by 刘科 on 2022/10/5.
//

#import <UIKit/UIKit.h>

@protocol NavigationViewControllerDelegate <NSObject>
- (void)itemSelected:(NSInteger)index;
@end

@interface NavigationItem : NSObject
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIView *panelView;//右侧显示view
@end

@interface NavigationViewController : UIViewController
@property (nonatomic, strong) NSArray<NavigationItem *> *items;
@property (nonatomic, weak) id<NavigationViewControllerDelegate> delegate;
@end