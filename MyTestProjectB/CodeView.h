//
//  CodeView.h
//  MyTestProjectB
//
//  Created by ljf on 16/5/6.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeView : UIView
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, copy) NSString *codeString; //滑动的路径经过的点 对应编号的字符串
//还原开始未滑动状态
- (void)resumeNormalState;

@end
