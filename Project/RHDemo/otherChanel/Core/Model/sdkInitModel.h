
#import <Foundation/Foundation.h>

@interface sdkInitModel : NSObject

@property (nonatomic, copy) NSString *cs_qq_url;  //客服qq地址
@property (nonatomic, copy) NSString *cs_qq_group;  //客服qq群
@property (nonatomic, copy) NSString *cs_qq;  //客服qq
@property (nonatomic, copy) NSString *cs_contact;  //客服联系方式
@property (nonatomic, assign) BOOL enable_sandbox;  //沙盒
@property (nonatomic, assign) BOOL enable_third_part_pay;  //第三方支付
@property (nonatomic, copy) NSString *package_url;  //包链接
@property (nonatomic, assign) int pay_status;  //支付状态
@property (nonatomic, copy) NSString *domain;  //悬浮窗域名
@property (nonatomic, copy) NSString *privacy;  //隐私
@property (nonatomic, copy) NSString *userPrivacy;  //用户协议
@property (nonatomic, copy) NSString *link1;  //
@property (nonatomic, copy) NSString *link2;  //
@property (nonatomic, copy) NSString *link3;  //
@property (nonatomic, copy) NSString *link4;  //
@property (nonatomic, copy) NSString *link5;  //
@property (nonatomic, copy) NSString *user;  //
@property (nonatomic, copy) NSString *anti;  //
@property (nonatomic, copy) NSString *status;  //
@property (nonatomic, copy) NSString *version;  //
@property (nonatomic, strong) NSArray *maintain;  //
@property (nonatomic, strong) NSArray *beforelogin;  //
@property (nonatomic, strong) NSArray *afterlogin;  //
@property (nonatomic, copy) NSString *active_time;  //激活接口时间
@property (nonatomic, copy) NSString *register_time;  //注册接口时间
@property (nonatomic, copy) NSString *login_time;  //登录接口时间
@property (nonatomic, assign) float behavior_time;  //记录轨迹行为上报时间
@property (nonatomic, copy) NSString *insue;
@property (nonatomic, copy) NSString *appstore;//苹果内购
@property (nonatomic, copy) NSString *gameUrl; //游戏链接
@property (nonatomic, copy) NSString *h5sdk_urltr;  //h5sdk
@property (nonatomic, copy) NSString *payon;  
@property (nonatomic, assign) int monthly_recharge_sum;//当前用户当月已充值金额
@property (nonatomic, assign) int each;//当前用户的每次充值限制金额
@property (nonatomic, assign) int monthly;//当前用户每月充值限制金额
@property (nonatomic, copy) NSString *h5web_urltr;  //网页url
@property (nonatomic, copy) NSString *h5PrivateKey;  //h5的私钥key，研发提供
@property (nonatomic, copy) NSString *extra_data;  //需要透传的参数

@property (nonatomic, copy) NSString *website;  //官网地址
@property (nonatomic, copy) NSString *qq;  //qq号地址
@property (nonatomic, copy) NSString *phone;  //客户电话号码
@property (nonatomic, copy) NSString *qq_official_url;  //企业qq跳转地址
@property (nonatomic, assign) float delay_time;  //请求时间,超过多少秒后，返回弹窗错误 ,提示 网络连接超时
@property (nonatomic, copy) NSString *protocol_url;  //协议的url地址
@property (nonatomic, copy) NSString *savemsg;  //一键注册截图文字提示
@property (nonatomic, copy) NSString *gid;  //对应的游戏id值
@property (nonatomic, copy) NSString *app_key;  //app的key,需要加密
@property (nonatomic, copy) NSString *private_key;  //privatekey,需要加密
@property (nonatomic, copy) NSString *h5playurl;  //h5登录url
@property (nonatomic, copy) NSString *h5playkey;  //h5的key
@property (nonatomic, copy) NSString *bg_color;  //sdk背景图颜色
@property (nonatomic, copy) NSString *button_color;  //sdk按钮颜色
@property (nonatomic, copy) NSString *center_logo_type;  //中心图片类型


@property (nonatomic, assign) BOOL is_open_url;   //是否需要开启加载页面url,该功能防止，特殊加载如，必须弹出实名认证，否则所有应用下架等原因,发放公告等原因
@property (nonatomic, copy) NSString *url;   //该功能对应的连接地址
@property (nonatomic, copy) NSString *logo_index;  //游戏的logo
@property (nonatomic, assign) BOOL hide_logo;  //是否隐藏主图logo ,0显示,1隐藏
@property (nonatomic, assign) BOOL hide_closeButton;  //是否隐藏X关闭按钮,0显示,1隐藏
@property (nonatomic, copy) NSString *logo_autoregister;  //一键注册logo
@property (nonatomic, assign) BOOL hide_autoregister;  //是否隐藏一键注册
@property (nonatomic, assign) BOOL hide_phone_login_register;   //是否隐藏手机帐号
@property (nonatomic, copy) NSString *logo_phone_login_register;  //手机注册logo
@property (nonatomic, assign) BOOL hide_register; //是否隐藏普通注册
@property (nonatomic, copy) NSString *logo_register;  //普通注册logo

@property (nonatomic, assign) BOOL pay_switch;  //支付开关
@property (nonatomic, assign) BOOL logswitch;   //日志开关
@property (nonatomic, assign) BOOL sandbox;     //沙盒开关
@property (nonatomic, assign) BOOL orieint_show; //横坚屏显示
@property (nonatomic, assign) BOOL hide_switchUser; //账号切换开关
@property (nonatomic, copy) NSString *max_ver;  //最大版本号
@property (nonatomic, copy) NSString *max_ver_name;  //最大版本号名
@property (nonatomic, assign) BOOL sdk_update;
@property (nonatomic, copy) NSString *sdk_max_version;

+ (instancetype)share;

@end
