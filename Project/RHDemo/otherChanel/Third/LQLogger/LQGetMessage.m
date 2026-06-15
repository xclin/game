

#import "LQGetMessage.h"
#import "LQConstants.h"
@implementation LQGetMessage
+ (instancetype) messageWithInput:(NSString*) input output:(NSString*) output succeed:(BOOL) succeed {
    NSString *apiName = @"";
    if ([input containsString:@"report-identity-card"]) {
        apiName = @"上报实名认证";
    }else if([input containsString:@"sub-user/create"]){
        apiName = @"创建小号";
    }else if([input containsString:@"get-token-by-phone"]){
        apiName = @"通过手机验证吗获取token";
    }else if([input containsString:@"get-token-by-phone"]){
        apiName = @"获取验证吗";
    }else if([input containsString:@"check-name"]){
        apiName = @"检查是否存在用户";
    }else if([input containsString:@"register-by-name"]){
        apiName = @"注册新用户";
    }else if([input containsString:@"user/login"]){
        apiName = @"登录";
    }else if([input containsString:@"report/active"]){
        apiName = @"初始化";
    }else if([input containsString:@"create-role"]){
        apiName = @"创角";
    }else if([input containsString:@"select-serverp"]){
        apiName = @"选服";
    }else if([input containsString:@"level-up"]){
        apiName = @"等级上报";
    }else if([input containsString:@"refresh-token"]){
        apiName = @"token刷新";
    }else if([input containsString:@"send-captcha"]){
        apiName = @"通过uid发送验证吗，修改密码";
    }else if([input containsString:@"check-name"]){
        apiName = @"根据用户名/手机获取用户信息,用于找回密码";
    }else if([input containsString:@"login-by-name"]){
        apiName = @"通过用户名和密码获取token";
    }
    LQGetMessage * message = [LQGetMessage messageWithTime:[NSDate new].timeIntervalSince1970 color:succeed ? LQColorGreen:LQColorRed message:[NSString stringWithFormat:@"\n-----%@接口-----\n:%@\n\n-----输出返回的信息:-----\n%@\n\n",apiName,input,output]];
    message.input = input;
    message.output = output;
    message.succeed = succeed;
    return message;
}
@end
