//
//  ViewController.m
//  LCShareView
//
//  Created by beike on 8/7/15.
//  Copyright (c) 2015 bawn. All rights reserved.
//

#import "ViewController.h"
#import "LCShareView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showButtonPress:(id)sender{
    NSArray *images = @[
                        @"btn_share_wechat",
                        @"btn_share_moments",
                        @"btn_share_weibo",
                        @"btn_share_qq",
                        @"btn_share_zone",
                        @"btn_share_message",
                        ];
    [LCShareView showShareViewInVC:self.navigationController buttonImages:images buttonPress:^(UIButton *button) {
        NSLog(@"%@", button);
    } dissmisBlock:^{
        NSLog(@"%s", __func__);
    }];
    
}

@end
