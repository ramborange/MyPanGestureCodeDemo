//
//  MyButton.m
//  MyTestProjectB
//
//  Created by ljf on 16/5/6.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

+ (MyButton *)initBtnWithFrame:(CGRect)rect {
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    selectedView.layer.cornerRadius = 15;
    selectedView.layer.masksToBounds = YES;
    selectedView.userInteractionEnabled = YES;
    [btn addSubview:selectedView];
    return btn;
}


- (void)btnSelected {
    self.isSelectedIn = YES;
    self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
    for (UIView *view in [self subviews]) {
        view.backgroundColor = [UIColor greenColor];
    }
}


- (void)btnUnSelected {
    self.isSelectedIn = NO;
    self.backgroundColor = [UIColor whiteColor];
    for (UIView *view in [self subviews]) {
        view.backgroundColor = [UIColor clearColor];
    }
}


- (void)btnShowError {
    self.isSelectedIn = YES;
    self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    for (UIView *view in [self subviews]) {
        view.backgroundColor = [UIColor redColor];
    }
}


@end
