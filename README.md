# AnimationButton
按钮动画， 长按 以及 旋转动画 两种效果

# 效果图片
## ![展示效果](https://github.com/EarthMass/AnimationButton/blob/master/%E6%8C%89%E9%92%AE%E5%8A%A8%E7%94%BB.gif)

# 使用
# LongPressProgressView 继承自UIView 通过手势来实现 长按效果
```
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
```
## RoundAnimationButton 按钮旋转动画 本身就是UIButton
* 使用
```
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
```
    
