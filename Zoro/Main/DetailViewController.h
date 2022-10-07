//
// Created by 刘科 on 2022/10/6.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerDelegate;
@protocol DetailSubViewDelegate;


@interface DetailViewController : UIViewController<DetailViewControllerDelegate>
- (void)updateView:(nonnull __kindof id<DetailSubViewDelegate>)view;
@end