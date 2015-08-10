//
//  LCShareView.h
//  LCShareView
//
//  Created by beike on 8/7/15.
//  Copyright (c) 2015 bawn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LCButtonPressBlock)(UIButton *button);
typedef void(^LCDismissBlock)();

@interface LCShareView : UIView

+ (void)showShareViewInVC:(UIViewController *)viewController buttonImages:(NSArray *)images buttonPress:(LCButtonPressBlock)pressBlock dissmisBlock:(LCDismissBlock)dissmisBlock;
+ (void)showShareViewInVC:(UIViewController *)viewController buttonImages:(NSArray *)images buttonMargin:(CGFloat)margin buttonPress:(LCButtonPressBlock)pressBlock dissmisBlock:(LCDismissBlock)dissmisBlock;


@end
