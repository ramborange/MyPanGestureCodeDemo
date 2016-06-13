//
//  MyButton.h
//  MyTestProjectB
//
//  Created by ljf on 16/5/6.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton

@property (nonatomic, assign) BOOL isSelectedIn;
+ (MyButton *)initBtnWithFrame:(CGRect)rect;

- (void)btnSelected;
- (void)btnUnSelected;

- (void)btnShowError;

@end
