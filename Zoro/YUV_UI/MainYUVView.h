//
// Created by 刘科 on 2022/10/3.
//

#import <UIKit/UIKit.h>
#import "DetailViewControllerDelegate.h"


@interface MainYUVView : UIView<DetailSubViewDelegate>
@property (nonatomic, weak, nullable) id<DetailViewControllerDelegate> delegate;
@end