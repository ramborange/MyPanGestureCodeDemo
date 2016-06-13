//
//  ViewController.m
//  MyTestProjectB
//
//  Created by ljf on 16/5/6.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "ViewController.h"
#import "CodeView.h"
@interface ViewController ()

@property (nonatomic, strong) CodeView *codeview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _codeview = [[CodeView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width)];
    _codeview.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_codeview];
    
    UILabel *label = [self getLabelWithFontSize:18 textColor:[UIColor blackColor] frame:CGRectMake(0, 50, self.view.frame.size.width, 20) labelText:@"滑动解锁Demo"];
    [self.view addSubview:label];
    
    
    UILabel *resultLabel = [self getLabelWithFontSize:18 textColor:[UIColor blackColor] frame:CGRectMake(0, self.view.bounds.size.width+120, self.view.bounds.size.width, 20) labelText:@"这里显示解锁结果"];
    resultLabel.tag = 111;
    [self.view addSubview:resultLabel];


    UIButton *resumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resumeBtn setTitle:@"还原" forState:UIControlStateNormal];
    [resumeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    resumeBtn.frame = CGRectMake(0, self.view.bounds.size.width+180, self.view.bounds.size.width, 20);
    [resumeBtn addTarget:self action:@selector(resumeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowCodeResult:) name:@"showCodeResult" object:nil];
}

//滑动结束 显示滑动的路径对应的编号
- (void)ShowCodeResult:(NSNotification *)notif {
    UILabel *label = (UILabel *)[self.view viewWithTag:111];
    NSString *result = [notif object];
    label.text = result;
}

//还原重置reset
- (void)resumeBtnClicked {
    [_codeview resumeNormalState];
    UILabel *label = (UILabel *)[self.view viewWithTag:111];
    label.text = @"这里显示解锁结果";
}


//返回一个label
- (UILabel *)getLabelWithFontSize:(NSInteger)fontSize textColor:(UIColor *)textColor frame:(CGRect)rect labelText:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
