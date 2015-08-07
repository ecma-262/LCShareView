//
//  LCShareView.h
//  LCShareView
//
//  Created by beike on 8/7/15.
//  Copyright (c) 2015 bawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCShareView : UIView

//@property (nonatomic, strong, readonly) RACSignal *selectSignal;
//@property (nonatomic, strong, readonly) RACSignal *dismissSignal;

+ (void)showShareViewInVC:(UIViewController *)viewController buttonImages:(NSArray *)images;
+ (void)showShareViewInVC:(UIViewController *)viewController buttonImages:(NSArray *)images buttonMargin:(CGFloat)margin;


@end
