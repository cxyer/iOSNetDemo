//
//  NSDataVC.m
//  iOSNetDemo
//
//  Created by 蔡晓阳 on 2018/7/14.
//  Copyright © 2018 cxy. All rights reserved.
//

#import "NSDataVC.h"

@interface NSDataVC ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NSDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btn = [UIButton createNormalButtonWithFrame:CGRectMake(50, 100, 50, 50) title:@"按钮" font:nil color:[UIColor blackColor] backColor:[UIColor orangeColor]];
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 200, 200, 200)];
    [self.view addSubview:self.imageView];
}

-(void)btnClick {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531548205251&di=f822988bcaeb9497f1f8fc5b5495d8b0&imgtype=0&src=http%3A%2F%2F4493bz.1985t.com%2Fuploads%2Fallimg%2F141124%2F4-141124100202.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:data];
        });
    });
}


@end
