//
//  NSURLConnectionVC.m
//  iOSNetDemo
//
//  Created by 蔡晓阳 on 2018/7/14.
//  Copyright © 2018 cxy. All rights reserved.
//

#import "NSURLConnectionVC.h"

@interface NSURLConnectionVC ()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, assign) double fileLength;
@property (nonatomic, assign) double currentFileLength;
@property (nonatomic, strong) NSFileHandle *fileHandle;


@end

@implementation NSURLConnectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btn1 = [UIButton createNormalButtonWithFrame:CGRectMake(0, 100, 50, 50) title:@"Block" font:nil color:[UIColor blackColor] backColor:[UIColor orangeColor]];
    [self.btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn1];
    
    self.btn2 = [UIButton createNormalButtonWithFrame:CGRectMake(60, 100, 100, 50) title:@"Delegate" font:nil color:[UIColor blackColor] backColor:[UIColor orangeColor]];
    [self.btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn2];
    
    self.btn3 = [UIButton createNormalButtonWithFrame:CGRectMake(170, 100, 100, 50) title:@"获取缓存" font:nil color:[UIColor blackColor] backColor:[UIColor orangeColor]];
    [self.btn3 addTarget:self action:@selector(btn3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn3];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 200, 200, 200)];
    [self.view addSubview:self.imageView];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, 450, 200, 2)];
    [self.view addSubview:self.progressView];
}

-(void)btn1Click {
    self.imageView.image = nil;
    
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531548205251&di=f822988bcaeb9497f1f8fc5b5495d8b0&imgtype=0&src=http%3A%2F%2F4493bz.1985t.com%2Fuploads%2Fallimg%2F141124%2F4-141124100202.jpg"];
    
    //iOS9废除
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        self.imageView.image = [UIImage imageWithData:data];
    }];
}

-(void)btn2Click {
    self.imageView.image = nil;
    
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531548205251&di=f822988bcaeb9497f1f8fc5b5495d8b0&imgtype=0&src=http%3A%2F%2F4493bz.1985t.com%2Fuploads%2Fallimg%2F141124%2F4-141124100202.jpg"];
    
    //iOS9废除
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
}

//接收响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.fileLength = response.expectedContentLength;
    NSLog(@"fileLength %f",self.fileLength);
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"img_connection.png"];
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
}
//接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.fileHandle seekToEndOfFile];
    [self.fileHandle writeData:data];
    
    self.currentFileLength += data.length;
    [self.progressView setProgress:self.currentFileLength/self.fileLength animated:true];
    
}
//接收完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.fileHandle closeFile];
    self.fileHandle = nil;

    self.currentFileLength = 0;
    self.fileLength = 0;
}

-(void)btn3Click {
    self.imageView.image = nil;
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"img_connection.png"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.imageView.image = [UIImage imageWithData:data];
}

@end
