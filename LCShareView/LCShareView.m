//
//  LCShareView.m
//  LCShareView
//
//  Created by beike on 8/7/15.
//  Copyright (c) 2015 bawn. All rights reserved.
//

#import "LCShareView.h"
#import <UIImage+ImageEffects.h>

static CGFloat KButtonMargin = 16.0f;
static CGFloat KLeadingMargin = 44.0f;

@interface LCShareView ()

@property (nonatomic, weak) UIViewController  *sourceViewController;
@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, strong) NSMutableArray *socialButtons;
@property (nonatomic, strong) NSMutableArray *buttonLeadings;
@property (nonatomic, strong) NSArray *buttonImages;
@property (nonatomic, assign) CGFloat buttonMargin;

@end

@implementation LCShareView



+ (void)showShareViewInVC:(UIViewController *)viewController buttonImages:(NSArray *)images buttonMargin:(CGFloat)margin{
    LCShareView *shareView = [[LCShareView alloc] init];
    shareView.sourceViewController = viewController;
    shareView.buttonImages = images;
    shareView.buttonMargin = margin;
    shareView.backgroundColor = [UIColor redColor];
    
    [shareView.sourceViewController.view addSubview:shareView];
    shareView.frame = shareView.sourceViewController.view.frame;
    [shareView.sourceViewController.view addConstraints:@[
                                                          [NSLayoutConstraint constraintWithItem:shareView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:shareView.sourceViewController.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
                                                          [NSLayoutConstraint constraintWithItem:shareView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:shareView.sourceViewController.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
                                                          [NSLayoutConstraint constraintWithItem:shareView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:shareView.sourceViewController.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f],
                                                          [NSLayoutConstraint constraintWithItem:shareView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:shareView.sourceViewController.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]
                                                          ]];
//
//    [shareView addConstraints:@[
//                                [NSLayoutConstraint constraintWithItem:shareView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:shareView.sourceViewController.view.frame.size.width],
//                                [NSLayoutConstraint constraintWithItem:shareView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:shareView.sourceViewController.view.frame.size.height],
//                                ]];
//    [shareView performBlurImageView];
//    [shareView configButtons];
}

+ (void)showShareViewInVC:(UIViewController *)viewController buttonImages:(NSArray *)images{
    [self showShareViewInVC:viewController buttonImages:images buttonMargin:KButtonMargin];
    
}


- (void)configButtons{
    
    self.socialButtons = [NSMutableArray array];
    self.buttonLeadings = [NSMutableArray array];
    
    [self.buttonImages enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self.socialButtons addObject:button];
    }];
    
    NSInteger number = (NSInteger)floorf(self.socialButtons.count * 0.5f);
    CGFloat imageHeight = [[(UIButton *)self.socialButtons.firstObject imageView].image size].height;
    CGFloat imageWidth = [[(UIButton *)self.socialButtons.firstObject imageView].image size].width;;
    
    [self.socialButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:imageHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:imageWidth]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:(number - idx) * (self.buttonMargin + imageHeight) - self.buttonMargin * 0.5f]];
        NSLayoutConstraint *leadingCon = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
        [self.buttonLeadings addObject:leadingCon];
        [self addConstraint:leadingCon];
    }];
    
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.blurImageView.alpha = 1.0f;
    } completion:NULL];
    
    self.userInteractionEnabled = NO;
    self.sourceViewController.view.userInteractionEnabled = NO;
    
    [self.buttonLeadings enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        constraint.constant = -KLeadingMargin - imageWidth;
        [UIView animateWithDuration:0.5f delay:idx * 0.05f usingSpringWithDamping:0.7f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finish){
            if (idx == self.socialButtons.count - 1) {
                self.userInteractionEnabled = YES;
                self.sourceViewController.view.userInteractionEnabled = YES;
            }
        }];
    }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)];
    [self addGestureRecognizer:singleTap];
    
//    NSMutableArray *buttonSignals = [NSMutableArray array];
//    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop){
//        [buttonSignals addObject:[button rac_signalForControlEvents:UIControlEventTouchUpInside]];
//        
//    }];
    
}

- (void)performBlurImageView{
    
    UIGraphicsBeginImageContextWithOptions(_sourceViewController.view.frame.size, YES, 0.0);
    [self.sourceViewController.view.window drawViewHierarchyInRect:_sourceViewController.view.frame afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor *tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
    snapshot = [snapshot applyBlurWithRadius:5.5 tintColor:tintColor saturationDeltaFactor:0.8 maskImage:nil];
    
    self.blurImageView = [[UIImageView alloc] initWithImage:snapshot];
    self.blurImageView.userInteractionEnabled = NO;
    
    [self addSubview:_blurImageView];

    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:_blurImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
                           [NSLayoutConstraint constraintWithItem:_blurImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f],
                           [NSLayoutConstraint constraintWithItem:_blurImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
                           [NSLayoutConstraint constraintWithItem:_blurImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]
                           ]];

    
    self.blurImageView.alpha = 0.0f;
}

- (void)dismissShareView{
    
    [self.buttonLeadings enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        constraint.constant = 0;
        [UIView animateWithDuration:0.1 delay:idx * 0.05f  options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self layoutIfNeeded];
        } completion:NULL];
    }];
    self.userInteractionEnabled = NO;
    self.sourceViewController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.blurImageView.alpha = 0.0f;
    } completion:^(BOOL finish){
        self.userInteractionEnabled = YES;
        self.sourceViewController.view.userInteractionEnabled = YES;
        [self.blurImageView removeFromSuperview];
        [self removeFromSuperview];
        self.blurImageView = nil;
    }];
}


@end

