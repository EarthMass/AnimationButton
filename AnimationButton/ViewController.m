//
//  ViewController.m
//  AnimationButton
//
//  Created by 郭海祥 on 2018/3/29.
//  Copyright © 2018年 ghx. All rights reserved.
//

#import "ViewController.h"

#import "LongPressProgressView.h"
#import "RoundAnimationButton.h"


@interface ViewController () {
    RoundAnimationButton * signBtn;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [self longPressProgressView];
    [self roundAnimationButton];
}

- (void)longPressProgressView {
    
   
    
    
//    LongPressProgressView * completeBtn = [[LongPressProgressView alloc] init];
//    completeBtn.frame = CGRectMake(50, 50, 100, 100);
    LongPressProgressView * completeBtn = [[LongPressProgressView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    completeBtn.backgroundColor = [UIColor clearColor];
    completeBtn.centerColor = [UIColor grayColor];
    completeBtn.titleLab.text = @"长按动画";
    
    completeBtn.progressColor = [UIColor redColor];

    completeBtn.titleLab.textColor = [UIColor whiteColor];

    completeBtn.centerScaleAnimation = YES;
    
    [self.view addSubview:completeBtn];

    
    [completeBtn longPressComplete:^{
        NSLog(@"完成");
    }];
    //点击显示
    [completeBtn tapPress:^{
        NSLog(@"点击");
    }];
    
    //放开显示
    [completeBtn relate:^{
       NSLog(@"放开");
    }];
    
    LongPressProgressView * completeBtn2 = [[LongPressProgressView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
    completeBtn2.backgroundColor = [UIColor clearColor];
    completeBtn2.centerColor = [UIColor grayColor];
    completeBtn2.titleLab.text = @"无动画";
    
    completeBtn2.progressColor = [UIColor redColor];
    
    completeBtn2.titleLab.textColor = [UIColor whiteColor];
    
    completeBtn2.centerScaleAnimation = NO;
    
    [self.view addSubview:completeBtn2];
}

- (void)roundAnimationButton {
//    UIView * tmpView = [[UIView alloc] init];
//    tmpView.frame = CGRectMake(50, 200, 100, 100);
//    tmpView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:tmpView];
    
    signBtn = [[RoundAnimationButton alloc] initWithFrame:CGRectMake(50, 200, 200, 100)];
    [signBtn setTitle:@"这就是个按钮" forState:UIControlStateNormal];
    signBtn.layer.cornerRadius = 50;
//    signBtn.clipsToBounds = YES;
    signBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:signBtn];
    
//    signBtn.spaceFromCenter = 2;
    
    [signBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [signBtn showAnnimation];
}

- (void)btnClick {
    if (signBtn.isShowAnnimation) {
        [signBtn hiddenAnnimation];
    } else {
        [signBtn showAnnimation];
    }
    
}

@end
