//
// Created by 刘科 on 2022/10/6.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@protocol DetailViewControllerDelegate;

@protocol DetailSubViewDelegate <NSObject>
@property (nonatomic, weak, nullable) id<DetailViewControllerDelegate> delegate;
@end

@protocol DetailViewControllerDelegate <NSObject>
- (void)detailPushViewController:(nullable UIViewController *)viewController animated:(BOOL)animated;
- (void)detailPresentViewController:(nullable UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;
@end
