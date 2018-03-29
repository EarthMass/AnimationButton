//
//  LongPressProgressView.h
//  YUAnimation
//
//  Created by 郭海祥 on 2017/12/19.
//  Copyright © 2017年 animation.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)(void);
typedef void(^RelateBlock)(void);
typedef void(^TapBlock)(void);

@interface LongPressProgressView : UIView

@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic) UIColor * centerColor; //内环颜色
@property (nonatomic) UIColor * progressColor; //进度的颜色【没设置就是centerColor】

@property (nonatomic,assign) CGFloat completeTime; ///<执行结束时间 default 1.5s

@property (nonatomic, assign) BOOL centerScaleAnimation; ///<中间缩放 动画，default NO

- (void)tapPress:(TapBlock)tap;
- (void)relate:(RelateBlock)relate; //放开
- (void)longPressComplete:(CompleteBlock)completeBlock;

@end
