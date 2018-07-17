# iOS网络请求
1. NSData(基本不用)
```
[NSData dataWithContentsOfURL:url]
```
2. NSURLConnection(过时的苹果原生网络框架,iOS9废弃)
    * 通过Block
       ```
       + (void)sendAsynchronousRequest:(NSURLRequest*) request
                             queue:(NSOperationQueue*) queue
                 completionHandler:(void (^)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError))
       ```
    * 通过Delegate
       ```
       + (nullable NSURLConnection*)connectionWithRequest:(NSURLRequest *)request delegate:(nullable id)delegate
       ```
    **NSURLConnectionDataDelegate**
       ```
       //接收响应
       - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
       //接收数据
       - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
       //接收完成
       -(void)connectionDidFinishLoading:(NSURLConnection *)connection
       ```

3. NSURLSession(现在的苹果原生网络框架)
    * 通过Block
        * 基本步骤
            1. 创建请求对象NSURLRequest
            2. 创建会话对象NSURLSession
            3. 创建请求任务NSURLSessionDataTask
            4. 执行Task
            5. 解析
       ```
       - (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
       ```
    * 通过Delegate
        * 基本步骤与通过Block的方式差不多，需要配置NSURLSessionConfiguration

    **NSURLSessionDataDelegate**
       ```
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
