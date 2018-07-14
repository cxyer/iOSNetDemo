//
//  NSURLSessionVC.m
//  iOSNetDemo
//
//  Created by 蔡晓阳 on 2018/7/14.
//  Copyright © 2018 cxy. All rights reserved.
//

#import "NSURLSessionVC.h"

@interface NSURLSessionVC ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, assign) double fileLength;
@property (nonatomic, assign) double currentFileLength;
@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation NSURLSessionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btn1 = [UIButton createNormalButtonWithFrame:CGRectMake(0, 50, 50, 50) title:@"Block" font:nil color:[UIColor blackColor] backColor:[UIColor orangeColor]];
    [self.btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn1];
    
    self.btn2 = [UIButton createNormalButtonWithFrame:CGRectMake(60, 50, 100, 50) title:@"Delegate" font:nil color:[UIColor blackColor] backColor:[UIColor orangeColor]];
    [self.btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn2];
    
    self.btn3 = [UIButton createNormalButtonWithFrame:CGRectMake(170, 50, 100, 50) title:@"获取缓存" font:nil color:[UIColor blackColor] backColor:[UIColor orangeColor]];
    [self.btn3 addTarget:self action:@selector(btn3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn3];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 150, 200, 200)];
    [self.view addSubview:self.imageView];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, 400, 200, 2)];
    [self.view addSubview:self.progressView];
}

- (void)btn1Click{
    self.imageView.image = nil;
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531548205251&di=f822988bcaeb9497f1f8fc5b5495d8b0&imgtype=0&src=http%3A%2F%2F4493bz.1985t.com%2Fuploads%2Fallimg%2F141124%2F4-141124100202.jpg"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithData:data];
            });
        }
    }];
    [dataTask resume];
}

- (void)btn2Click{
    self.imageView.image = nil;
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531548205251&di=f822988bcaeb9497f1f8fc5b5495d8b0&imgtype=0&src=http%3A%2F%2F4493bz.1985t.com%2Fuploads%2Fallimg%2F141124%2F4-141124100202.jpg"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    self.fileLength = response.expectedContentLength;
    NSLog(@"fileLength %f",self.fileLength);
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"img_session.png"];
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.fileHandle seekToEndOfFile];
    [self.fileHandle writeData:data];
    
    self.currentFileLength += data.length;
    [self.progressView setProgress:self.currentFileLength/self.fileLength animated:true];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    self.currentFileLength = 0;
    self.fileLength = 0;
    
}

-(void)btn3Click {
    self.imageView.image = nil;
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"img_session.png"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.imageView.image = [UIImage imageWithData:data];
}

@end
