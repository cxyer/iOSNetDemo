//
//  WebVC.m
//  iOSNetDemo
//
//  Created by 蔡晓阳 on 2018/8/20.
//  Copyright © 2018 cxy. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()

@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://app.llkotori.com/cn.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}
@end
