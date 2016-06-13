//
//  CodeView.m
//  MyTestProjectB
//
//  Created by ljf on 16/5/6.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "CodeView.h"
#import "MyButton.h"
#import <QuartzCore/QuartzCore.h>


@interface CodeView () {
    CGContextRef context;
    CGPoint currentHandPoint;
    BOOL isErrorLine;
}
@property (nonatomic, strong) NSMutableArray *selectedResultArray;
@end

@implementation CodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        for (int i=0; i<9; i++) {
            float w = (frame.size.width-50*3)/4;
            CGRect rect = CGRectMake(w+(w+50)*(i%3), w+(w+50)*(i/3), 50, 50);
            MyButton *btn = [MyButton initBtnWithFrame:rect];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 25;
            btn.layer.masksToBounds = YES;
            btn.tag = 100+i;
            [self addSubview:btn];
        }
        self.coverView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.coverView];
        self.selectedResultArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)btnClicked:(MyButton *)btn {
    [btn btnSelected];
}

- (void)drawRect:(CGRect)rect {
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);
    if (isErrorLine) {
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    }else {
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    }
   
    if (_selectedResultArray.count) {
        CGPoint points[_selectedResultArray.count];
        for (int i=0; i<_selectedResultArray.count; i++) {
            NSInteger tag = [_selectedResultArray[i] integerValue]+100;
            MyButton *btn = (MyButton *)[self viewWithTag:tag];
            CGPoint point = btn.center;
            points[i] = point;
        }
        CGContextAddLines(context, points, _selectedResultArray.count);

        NSInteger lastBtnTag = [_selectedResultArray[_selectedResultArray.count-1] integerValue]+100;
        MyButton *lastBtn = (MyButton *)[self viewWithTag:lastBtnTag];
        //在还未撒手的情况下判断尾部的线段
        if (self.coverView.userInteractionEnabled) {
            //判断最后线的尾巴是否还在外面
            if (!(CGRectContainsPoint(lastBtn.frame, currentHandPoint))) {
                CGContextAddLineToPoint(context, currentHandPoint.x, currentHandPoint.y);
            }
        }
    }
    
    
    CGContextStrokePath(context);
    
}

//判断当前滑动停留的位置的按钮的状态
- (void)checkBtnCurrentStateWithPoint:(CGPoint)point {
    for (int i=0; i<9; i++) {
        MyButton *btn = (MyButton *)[self viewWithTag:100+i];
        if (CGRectContainsPoint(btn.frame, point)) {
            NSInteger index = btn.tag-100;
            if (!btn.isSelectedIn) {
                [_selectedResultArray addObject:@(index)];
                
            }
            [btn btnSelected];
        }
    }
    //画线开始
    if (_selectedResultArray.count) {
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touch began");
    CGPoint point = [[touches anyObject] locationInView:self.coverView];
    if (self.coverView.isUserInteractionEnabled) {
        currentHandPoint = point;
        [self checkBtnCurrentStateWithPoint:point];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.coverView];
//    NSLog(@"touch moving  x:%f y:%f",point.x,point.y);
 
    if (self.coverView.isUserInteractionEnabled) {
        currentHandPoint = point;
        [self checkBtnCurrentStateWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touch end");
    if (_selectedResultArray.count) {
        if (self.coverView.isUserInteractionEnabled) {
            self.coverView.userInteractionEnabled = NO;
            //松开手后检查是否有残余的线段
            [self setNeedsDisplay];
            //这里的方法需要延迟执行
            [self performSelector:@selector(codeSetEnd) withObject:nil afterDelay:0.5];
        }
    }
}

//显示错误
- (void)showErrorLine {
    for (int i=0; i<_selectedResultArray.count; i++) {
        MyButton *btn = (MyButton *)[self viewWithTag:100+[_selectedResultArray[i] intValue]];
        [btn btnShowError];
    }
    isErrorLine = YES;

    [self setNeedsDisplay];
}

//滑动结束
- (void)codeSetEnd {
    NSMutableString *resultSting = [NSMutableString stringWithCapacity:0];
    if (_selectedResultArray.count<3) {
        //当滑动的点少于三个时 显示错误
        [self showErrorLine];
        resultSting = [NSMutableString stringWithString:@"滑动的点必须大于两个"];
    }else {
        for (int i=0; i<_selectedResultArray.count; i++) {
            [resultSting appendString:[_selectedResultArray[i] stringValue]];
        }
    }
   
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showCodeResult" object:resultSting];
//    _selectedResultArray = [NSMutableArray arrayWithCapacity:0];
}

//清空画布 还原状态
- (void)resumeNormalState {
    for (int i=0; i<9; i++) {
        MyButton *btn = (MyButton *)[self viewWithTag:100+i];
        [btn btnUnSelected];
    }
    isErrorLine = NO;
    _selectedResultArray = [NSMutableArray arrayWithCapacity:0];
    self.coverView.userInteractionEnabled = YES;
    
    CGContextClearRect(context, self.frame);
    [self setNeedsDisplay];
}

@end
