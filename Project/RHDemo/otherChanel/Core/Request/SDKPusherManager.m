
#import "ZhongkeUserViewController.h"
#import "SDKPusherManager.h"
@interface AuthRequestBuilder : NSObject<AuthRequestBuilderProtocol>

- (NSMutableURLRequest *)requestForSocketID:(NSString *)socketID channel:(PusherChannel *)channel;
- (NSURLRequest *)requestForSocketID:(NSString *)socketID channelName:(NSString *)channelName;

@end

@implementation AuthRequestBuilder

- (NSMutableURLRequest *)requestForSocketID:(NSString *)socketID channel:(PusherChannel *)channel {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [[NSURL alloc] initWithString:@"http://apisdk.020richang.com/broadcasting/auth"]];
    NSString *dataStr = [NSString stringWithFormat: @"socket_id=%@&channel_name=%@&access_token=%@uid=%@", socketID, [channel name],COMMONMETHOD.access_token,COMMONMETHOD.uid];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    request.HTTPMethod = @"POST";
    [request addValue:COMMONMETHOD.access_token forHTTPHeaderField:@"Authorization"];
    return request;
}

- (NSURLRequest *)requestForSocketID:(NSString *)socketID channelName:(NSString *)channelName {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"http://apisdk.020richang.com/broadcasting/auth"]];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL: [[NSURL alloc] initWithString:@"http://apisdk.020richang.com/broadcasting/auth"]];

    NSString *dataStr = [NSString stringWithFormat: @"socket_id=%@&channel_name=%@&access_token=%@&uid=%@", socketID, channelName,COMMONMETHOD.access_token,COMMONMETHOD.uid];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    mutableRequest.HTTPBody = data;
    mutableRequest.HTTPMethod = @"POST";
    [mutableRequest addValue:COMMONMETHOD.access_token forHTTPHeaderField:@"Authorization"];
    request = [mutableRequest copy];

    return request;
}

@end


static SDKPusherManager *sharedManager = nil;

@implementation SDKPusherManager

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
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
     // 把定时器添加到当前运行循环,并且调为通用模式
    [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];

}

- (void)longConnectToSocket{

    //发送在线时长
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"60" forKey:@"cycle_time"];
    [params setValue:COMMONMETHOD.uid forKey:@"uid"];
    [params setValue:COMMONMETHOD.sub_uid forKey:@"sub_uid"];
    [params setValue:INITCONFIGURE.gid forKey:@"gid"];
    NSLog(@"longConnectToSocket--%@",params);
    [ self.myPrivateChannel triggerWithEventName:@"client-cycle.playing" data:params];

}


- (void)startConnectServer{
    NSLog(@"startConnectServer");

    OCAuthMethod *authMethod = [[OCAuthMethod alloc] initWithAuthRequestBuilder:[[AuthRequestBuilder alloc] init]];


    OCPusherHost *host = [[OCPusherHost alloc]initWithHost:@"apisdk.020richang.com"];
    PusherClientOptions *options = [[PusherClientOptions alloc]
                                    initWithOcAuthMethod:authMethod
                                    autoReconnect:YES
                                    ocHost:host
                                    port:@6001
                                    useTLS:NO
                                    activityTimeout:nil];
    self.client = [[Pusher alloc] initWithAppKey:@"api-pusher-app-key" options:options];


    self.client.connection.delegate = self;

    self.client.connection.userDataFetcher = ^PusherPresenceChannelMember* () {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        return [[PusherPresenceChannelMember alloc] initWithUserId:uuid userInfo:nil];
    };

    self.myPrivateChannel = [self.client subscribeWithChannelName:[NSString stringWithFormat:@"private-user.%@",COMMONMETHOD.uid]];


//     bind a callback to an event on that channel
    [ self.myPrivateChannel bindWithEventName:@"user.play.timeout" eventCallback:^void (PusherEvent *event) {//踢下线
//        NSString *dataString = event.data;
//        NSString * eventNameStr = event.eventName;
//        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error;
//        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        NSString *name = jsonObject[@"name"];
//        NSString *message = jsonObject[@"message"];
//        NSLog(@"user.play.timeout    %@ says %@", name, message);
        COMMONMETHOD.bannedORplayout = YES;
    COMMONMETHOD.bannedORplayoutString = @"根据防沉迷规定，除每周五、六、日的20点至21点外，其它时间未成年人不能进入游戏";
       [SDKComPlatform.shared logout];
//    [[NSUserDefaults standardUserDefaults] setValue:message forKey:@"pushMessage"];
//[[NSUserDefaults standardUserDefaults] synchronize];
        [self.client disconnect];

    }];

    [ self.myPrivateChannel bindWithEventName:@"user.banned" eventCallback:^void (PusherEvent *event) {//封禁
//        NSString *dataString = event.data;
//        NSString * eventNameStr = event.eventName;
//        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error;
//        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        NSString *name = jsonObject[@"name"];
//        NSString *message = jsonObject[@"message"];
//        NSLog(@"user.banned    %@ says %@", name, message);
//        [[NSUserDefaults standardUserDefaults] setValue:message forKey:@"pushMessage"];
// [[NSUserDefaults standardUserDefaults] synchronize];
         COMMONMETHOD.bannedORplayout = YES;
    COMMONMETHOD.bannedORplayoutString = @"您的账号已被封禁，请联系客服";
         [SDKComPlatform.shared logout];

        [self.client disconnect];

    }];

    [self.client connect];

    [self addTimer];
}

- (void)changedConnectionStateFrom:(enum ConnectionState)old to:(enum ConnectionState)new_ {
    NSLog(@"Old connection: %d, new connection: %d", (int)old, (int)new_);

}

- (void)debugLogWithMessage:(NSString *)message {
    NSLog(@"debugLogWithMessage--%@", message);
}

- (void)subscribedToChannelWithName:(NSString *)name {
    NSLog(@"Subscribed to channel %@", name);


}

- (void)failedToSubscribeToChannelWithName:(NSString *)name response:(NSURLResponse *)response data:(NSString *)data error:(NSError *)error {
    NSLog(@"Failed to subscribe to channel %@", name);
}

- (void)receivedError:(PusherError *)error {
    NSNumber *code = error.codeOC;
    if(code) {
        NSLog(@"Received error: (%ld) %@", [code longValue], error.message);
    } else {
        NSLog(@"Received error: %@", error.message);
    }
}

@end
