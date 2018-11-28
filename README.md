# iOS网络请求
1. NSData(基本不用)
   ```objc
   [NSData dataWithContentsOfURL:url]
   ```
2. NSURLConnection(过时的苹果原生网络框架,iOS9废弃)
    * 通过Block
       ```objc
       //异步
       + (void)sendAsynchronousRequest:(NSURLRequest*) request
                             queue:(NSOperationQueue*) queue
                 completionHandler:(void (^)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError))
                 
       //同步
       + (nullable NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError **)error
                 completionHandler:(void (^)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError))
       ```
    * 通过Delegate
       ```objc
       + (nullable NSURLConnection*)connectionWithRequest:(NSURLRequest *)request delegate:(nullable id)delegate
       ```
       * NSURLConnectionDataDelegate
       ```objc
       //接收响应
       - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
       //接收数据
       - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
       //接收完成
       -(void)connectionDidFinishLoading:(NSURLConnection *)connection
       ```

3. NSURLSession(现在的苹果原生网络框架)
    * 后续学习补充，了解各类网络API，仅仅是熟悉，有些api不知道怎么做demo。。
        1. [NSURLRequest](https://github.com/cxyer/iOSNote/wiki/NSURLRequest)
        1. [NSURLResponse](https://github.com/cxyer/iOSNote/wiki/NSURLResponse)
        1. [NSURLSessionConfiguration](https://github.com/cxyer/iOSNote/wiki/NSURLSessionConfiguration)
        1. [NSURLSessionDelegate](https://github.com/cxyer/iOSNote/wiki/NSURLSessionDelegate)
        1. [NSURLSession](https://github.com/cxyer/iOSNote/wiki/NSURLSession)
        1. [NSURLCredential
        ](https://github.com/cxyer/iOSNote/wiki/NSURLCredential)
        1. [NSURLCahce](https://github.com/cxyer/iOSNote/wiki/NSURLCahce)
        1. [NSURLAuthenticationChallenge以及NSURLProtectionSpace](https://github.com/cxyer/iOSNote/wiki/NSURLAuthenticationChallenge%E4%BB%A5%E5%8F%8ANSURLProtectionSpace)
    * 通过Block
        * 基本步骤
            1. 创建会话对象NSURLSession
            2. 创建请求任务NSURLSessionTask(有三种)
               1. NSURLSessionDataTask
               2. NSURLSessionUploadTask
               3. NSURLSessionDownloadTask
            3. 启动 resume
       ```objc
       - (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
       ```
    * 通过Delegate
        * 基本步骤与通过Block的方式差不多，只能在初始化的时候配置delegate
        * NSURLSessionDataDelegate
        ```objc
        //接收响应
        -(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler

        //NSURLSessionResponseDisposition
        /*
            NSURLSessionResponseCancel = 0,
            //取消，默认
            NSURLSessionResponseAllow = 1,
            //接收数据
            NSURLSessionResponseBecomeDownload = 2
            //变成下载请求
            NSURLSessionResponseBecomeStream
            //变成流
            */

        //接收数据
        - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
        //接收完成
        - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
        ```

4. AFNetworking
    * todo:分析源码

# NSURLProtocol
可以对URL请求进行拦截，主要用于离线缓存策略
1. 使用NSURLProtocol需要在AppDelegate中进行注册
    ```objc
    [NSURLProtocol registerClass:[XYURLProtocol class]];

    XYURLProtocol是继承NSURLProtocol的类
    ```
2. NSURLProtocol中的方法
    ```objc
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
    ```
    其中有一个问题，canInitWithRequest返回YES的时候会调用startLoading，然后会继续调用canInitWithRequest，陷入死循环，解决方式是使用[NSURLProtocol setProperty:@YES forKey:@"XYURLProtocol" inRequest:request]然后在canInitWithRequest进行判断
3. 离线缓存：可以把获得的数据进行缓存，然后在startLoading中进行判断是否使用离线缓存
