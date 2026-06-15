
#ifndef LQConstants_h
#define LQConstants_h   
#define RootPresentedViewController [LQLogger rootPresentedController]

#define ReturnIfFullFunctionalityIsNotAvaliable if([[[NSUserDefaults standardUserDefaults] objectForKey:@"FullFunctionalityIsAvaliable"] integerValue] != 13234)return;
/**
 单例的接口方法

 @param instancetype 返回类型
 @return 单例的实例
 */
#define LQSingletonInstanceHMethod + (instancetype) shared;

/**
 单例的实现方法

 @param ClassName 类名
 @param block 代码块
 @return 单例的实例
 */
#define LQSingletonInstanceMMethod(ClassName,block) static ClassName * instance = nil;\
+ (instancetype) shared {\
static dispatch_once_t pred = 0;\
dispatch_once(&pred, ^{\
if (instance == nil) {\
instance = [[self alloc] init];\
block();\
}\
});\
return instance;\
}


/**
 由顶层控制器present的方法。
 @return 实现方法
 */
#define LQPresentHMethod -(void) isPresentedBy:(UIViewController*) controller;\
- (void) present;
#define LQPresentMMethod -(void) isPresentedBy:(UIViewController*) controller {\
UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:self];\
[controller presentViewController:nav animated:YES completion:nil];\
}\
- (void) present {\
    [self isPresentedBy:RootPresentedViewController];\
}
#define LQAddBackItem UIImage * backImage = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/btn_back.png"];\
UIImageView * imageV = [[UIImageView alloc] initWithImage:backImage];\
[imageV sizeToFit];\
imageV.userInteractionEnabled = YES;\
[imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)]];\
self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageV];

#define LQBackMethod - (void) back:(id) item { if (self.navigationController.viewControllers.firstObject == self) {\
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];\
} else {\
    [self.navigationController popViewControllerAnimated:YES];\
}\
}

#define LQLog(msg) [[LQLogger shared] log:msg]
#define DebugMessage(msg)  [[LQDebugMessage alloc] initWithMessage:msg]

//蓝色
#define LQColorGreen 0x00ff00
//红色
#define LQColorRed  0xff0000
//橙色
#define LQColorOrange 0xff4500
/**
 绿色的消息，通常用来打印正常或成功的操作
 
 @param msg 消息
 @return 绿色的日志消息实例
 */
#define GreenMessage(msg) [LQMessage messageWithColor:LQColorGreen message:msg]

/**
 橙色的消息，通常用来打印警告
 
 @param msg 消息
 @return 橙色的日志消息实例
 */
#define OrangeMessage(msg) [LQMessage messageWithColor:LQColorOrange message:msg]

/**
 红色的消息，通常用来打印错误的信息
 
 @param msg 消息
 @return 红色的消息
 */
#define RedMessage(msg) [LQMessage messageWithColor:LQColorRed message:msg]

/**
 错误消息
 
 @param msg 消息
 @return 错误消息
 */
#define ErrorMessage(msg) RedMessage(msg)

/**
 警告消息
 
 @param msg 消息
 @return 警告消息
 */
#define WarningMessage(msg) OrangeMessage(msg)

#endif /* LQConstants_h */
