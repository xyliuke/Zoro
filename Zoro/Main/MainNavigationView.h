//
//  MainNavigationView.h
//  Zoro
//
//  Created by 刘科 on 2022/10/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationItem : NSObject
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIView *panelView;//右侧显示view
@end

@interface MainNavigationView : UIView
@property (nonatomic, strong) NSArray<NavigationItem*> *items;
@end

NS_ASSUME_NONNULL_END
