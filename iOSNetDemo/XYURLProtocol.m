//
//  XYURLProtocol.m
//  iOSNetDemo
//
//  Created by 蔡晓阳 on 2018/8/20.
//  Copyright © 2018 cxy. All rights reserved.
//

#import "XYURLProtocol.h"

@interface XYURLProtocol()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation XYURLProtocol

//所有的NSURLConnection都会通过这个方法
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"%s",__func__);
    NSLog(@"init %@",[NSURLProtocol propertyForKey:@"XYURLProtocol" inRequest:request]);
    if ([NSURLProtocol propertyForKey:@"XYURLProtocol" inRequest:request]) {
        return NO;
    }
    return YES;
}

//可以对request进行修改然后转发
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSLog(@"%s",__func__);
    return request;
}

//判断url是否相同，相同可以使用相同的缓存空间
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    NSLog(@"%s",__func__);
    return [super requestIsCacheEquivalent:a toRequest:b];
}

//开始连接
- (void)startLoading {
    NSLog(@"%s",__func__);
    
    NSMutableURLRequest *request = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"XYURLProtocol" inRequest:request];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

//停止连接
- (void)stopLoading {
    NSLog(@"%s",__func__);
    
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%s",__func__);
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s",__func__);
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s",__func__);
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%s",__func__);
    [self.client URLProtocol:self didFailWithError:error];
}

@end
