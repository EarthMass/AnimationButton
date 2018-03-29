//
//  LongPressProgressView.m
//  YUAnimation
//
//  Created by 郭海祥 on 2017/12/19.
//  Copyright © 2017年 animation.com. All rights reserved.
//

#import "LongPressProgressView.h"

#define kCompletePressTime 1.5 //秒
#define kCornerSpace 5 //内环距离外环的距离
#define kCornerW 3 //进度条宽度

#define kTimerSpace 0.05 ///<定时器时间间隔[越小圆环的动画越流畅]

@interface LongPressProgressView()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) NSTimer * timer;
@property (assign, nonatomic) float touchTime;// 触摸时间
@property (strong, nonatomic)  UIView * centerView;

@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, copy) TapBlock tapBlock;
@property (nonatomic, copy)  RelateBlock relateBlock;
@end

@implementation LongPressProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    //调整为内环位置
    if (self = [super initWithFrame:frame]) {
        [self addLongPress];
        [self addCenterCycle];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    //设置 frame 为内环显示的位置，view重新计算
    [super setFrame:[self calculateFrame:frame]];
}

- (instancetype)init {
    if (self = [super init]) {
        [self addLongPress];
        [self addCenterCycle];
    }
    return self;
}

#pragma mark- Init
- (void)addCenterCycle {
    
    self.centerView = [[UIView alloc] init];
    [self addSubview:_centerView];
    self.titleLab = [[UILabel alloc] init];
    [_centerView addSubview:self.titleLab];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.centerView.frame = [self calculateCenterFrame];
        _centerView.userInteractionEnabled = NO;
        _centerView.layer.cornerRadius = _centerView.frame.size.width/2;
        _centerView.clipsToBounds = YES;
        _centerView.backgroundColor = (self.centerColor)?self.centerColor:[UIColor greenColor];
        
        
        self.titleLab.frame = CGRectMake(0, _centerView.bounds.size.height/2 - 15, _centerView.bounds.size.width, 30);
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        
        
    });
    
}

- (void)setCenterColor:(UIColor *)centerColor {
    _centerColor = centerColor;
    _centerView.backgroundColor = _centerColor;
}

- (void)addLongPress {
    
    self.userInteractionEnabled = YES;
    //实例化长按手势监听
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleTableviewCellLongPressed:)];
    //代理
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.2;
    //将长按手势添加到需要实现长按操作的视图里
    [self addGestureRecognizer:longPress];
    
    
    //单击手势
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired =1;
    singleTapGesture.numberOfTouchesRequired =1;
    [self addGestureRecognizer:singleTapGesture];
}


- (void)tapPress:(TapBlock)tap {
    self.tapBlock = tap;
}

- (void)relate:(RelateBlock)relate {
    self.relateBlock = relate;
}

- (void)longPressComplete:(CompleteBlock)completeBlock {
    self.completeBlock = completeBlock;
}

#pragma mark- Event
-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    if (self.tapBlock) {
        self.tapBlock();
    }
    
}



- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        [self reset];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerSpace target:self selector:@selector(timerRepeat:) userInfo:nil repeats:YES];
        
        
        if (_centerScaleAnimation) {
            [UIView animateWithDuration:0.5 animations:^{
                CGAffineTransform  transform = CGAffineTransformMakeScale(0.9, 0.9);
                [self.centerView setTransform:transform];
            }];
        }
        
    }
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        if (_touchTime < [self completeTime] && _touchTime != 0) {
            if (self.relateBlock) {
                self.relateBlock();
            }
        }
        [self reset];
    }
    
    
}

- (void)timerRepeat:(NSTimer *)timer {
    _touchTime += kTimerSpace;
    
    if (_touchTime <= [self completeTime] + kTimerSpace) { //+ 0.02 不会有结束没 达到环封闭
        [UIView animateWithDuration:0
                         animations:^{
                             _progress = _touchTime/[self completeTime];
                             //                             NSLog(@"%f",_progress);
                             [self setNeedsDisplay];
                             
                         }];
        return;
    }
    
    if (_touchTime > [self completeTime]) {
        // 结束
        [self reset];
        
        //长按完成
        if (self.completeBlock) {
            self.completeBlock();
        }
        
        
    }
}

- (void)reset {
    _progress = 0;
    _touchTime = 0;
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (_centerScaleAnimation) {
        [UIView animateWithDuration:0.5 animations:^{
            CGAffineTransform  transform = CGAffineTransformMakeScale(1, 1);
            [self.centerView setTransform:transform];
        }];
    }
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);  //设置圆心位置
    CGFloat radius = [self cycleRadio];  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    //    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:10];
    
    CGContextSetLineWidth(ctx, kCornerW); //设置线条宽度
    
    [(self.progressColor)?self.progressColor:self.centerColor setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
    
}

#pragma mark- Other
- (CGRect)calculateFrame:(CGRect)frame {
    CGRect currFrame = frame;
    currFrame.size = CGSizeMake(currFrame.size.width + 2*kCornerSpace + 2*kCornerW, currFrame.size.height + 2*kCornerSpace + 2*kCornerW);
    currFrame.origin = CGPointMake(currFrame.origin.x - kCornerSpace - kCornerW, currFrame.origin.y - kCornerSpace - kCornerW);
    return currFrame;
}

- (CGRect)calculateCenterFrame {
    return CGRectMake(kCornerSpace + kCornerW, kCornerSpace + kCornerW, self.bounds.size.width - 2*kCornerSpace - 2*kCornerW, self.bounds.size.height - 2*kCornerSpace - 2*kCornerW);
}

- (CGFloat)completeTime {
    CGFloat completeTime = _completeTime?:kCompletePressTime;
    return completeTime;
}
- (CGFloat)cycleRadio {
    return _centerScaleAnimation?
    self.centerView.bounds.size.width/2.0:
    self.centerView.bounds.size.width/2.0 + kCornerSpace;
}


@end

