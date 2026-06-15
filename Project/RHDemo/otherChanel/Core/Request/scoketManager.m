

#import "scoketManager.h"
#import "SDKAsyncSocket.h"
#import "SDKComPlatform+User.h"
#import "apiManager.h"
#import "SDKComPlatformError.h"
#import "SDKCommonMethod.h"
@interface scoketManager()<GCDAsyncSocketDelegate>
// 客户端socket
@property (strong, nonatomic) SDKAsyncSocket *asyncSocket;
@property (nonatomic, assign) BOOL connected;
 // 计时器
@property (nonatomic, strong) NSTimer *connectTimer;
@end
static scoketManager *sharedManager = nil;

@implementation scoketManager

+ (instancetype)shared {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (sharedManager == nil) {
            sharedManager = [[self alloc]init];
        }
    });
    return sharedManager;
}


// 添加计时器
- (void)addTimer{
     // 长连接定时器
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
     // 把定时器添加到当前运行循环,并且调为通用模式
    [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];

}



//开始链接
- (void)startConnectServer{
    if (!self.connected){
        if (!self.asyncSocket) {
            self.asyncSocket = [[SDKAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        }
        NSLog(@"开始连接%@",self.asyncSocket);
        NSError *error = nil;

        self.connected = [self.asyncSocket connectToHost:sdkDomain onPort:[socktePort integerValue] viaInterface:nil withTimeout:-1 error:&error];
    
        if(self.connected){
            NSLog(@"链接成功！");
        }
    }
}

//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


// 向服务器发送数据
- (void)sendMessageAction{
    NSDictionary *dict = @{@"Access-Token":COMMONMETHOD.access_token,@"user.":COMMONMETHOD.uid,@"event:":@"user.banned"};
      NSData  *loginbyteData;
        if ([dict isKindOfClass:[NSDictionary class]]) {//协议编号为登录的data
            NSString *loginStr = [self  dictionaryToJson:dict];
            NSData *loginData = [loginStr dataUsingEncoding:NSUTF8StringEncoding];
            Byte *loginbyte = (Byte *)[loginData bytes];
           loginbyteData = [NSData dataWithBytes:loginbyte length:loginData.length];

        }

    NSLog(@"发送数据");
//     withTimeout -1 : 无穷大,一直等
//     tag : 消息标记
    [self.asyncSocket writeData:loginbyteData withTimeout:- 1 tag:0];
}


#pragma mark - GCDAsyncSocketDelegate
/**
消息发送成功

@param sock socket套接字
@param tag 哈哈
*/
- (void)socket:(SDKAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
   NSLog (@"tcp 消息发送成功");
    
    NSLog(@"written tag:%ld",tag);
    
    
}


/**
 当成功连接上,该方法会立刻返回
@param host 主机地址
@param port 端口地址
*/
- (void)socket:(SDKAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"链接成功");
    
    [self addTimer];
    // 发送数据
    [self sendMessageAction];
    
    // 连接后,可读取服务器端的数据
    self.connected = YES;
    
    //读取
//     [self.asyncSocket readDataWithTimeout:- 1 tag:0];
}

// 心跳连接
- (void)longConnectToSocket{
    // 发送固定格式的数据,指令@"longConnect"
    
      [self.asyncSocket readDataWithTimeout:- 1 tag:0];
}


/**
  接收到的数据
 @param sock 客户端socket
 @param data 读取到的数据
 @param tag 当前读取的标记
 */
- (void)socket:(SDKAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@" 接收到的消息---%@",text);
    if ([text containsString:@"for"]) {
        self.asyncSocket.delegate = nil;
        self.asyncSocket = nil;
        self.connected = NO;
        [self.connectTimer  invalidate];
        self.connectTimer = nil;
        //踢下线
        AccountStatus * user = [[AccountStatus alloc] init];
        user.fySDKAccountStatus = _ACCOUNT_STATUS_LOGOUT;
        MessageStatus * message = [[MessageStatus alloc] init];
        message.code = 0;
        message.msg = @"账号在线状态";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
    }
    // 读取到服务器数据值后,能再次读取
    [self.asyncSocket readDataWithTimeout:- 1 tag:0];
}



/**
 客户端socket断开

 @param sock 客户端socket
 @param err 错误描述
 */
- (void)socketDidDisconnect:(SDKAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"socket断开，socket--%@,err--%@",sock,err);
        self.asyncSocket.delegate = nil;
        self.asyncSocket = nil;
        self.connected = NO;
}

@end
