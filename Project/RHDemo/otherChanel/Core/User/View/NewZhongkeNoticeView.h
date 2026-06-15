
#import "ZhongkeView.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,NoticeType){
    
    Text_Maintain = 0,
    Text_BeforeLogin = 1,
    Text_AftetLogin = 2
};

@interface NewZhongkeNoticeView : ZhongkeView
@property (nonatomic,strong)  UILabel   *titleMsg;
@property (nonatomic,strong)  UILabel   *timeLbl;
@property (nonatomic,strong)  UILabel   *line;
@property (nonatomic,strong)  UITextView   *contentview;
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic, copy) void(^goBackBlock)(NSString *type);
@end

NS_ASSUME_NONNULL_END
