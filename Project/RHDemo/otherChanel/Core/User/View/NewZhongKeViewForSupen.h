
#import "ZhongkeView.h"
#import "zhongkeIAPManager.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NewZhongKeViewForSupen : ZhongkeView
@property (nonatomic,retain) WKWebView * webView;

@property (nonatomic, retain) NSString *url;

- (void)reloadASDFModel:(WebASDFModel *)model;
- (void)reloadAtUrl:(NSString*)urlString;
- (void)btnChangeViewFrame:(UIButton *)sender;
- (void)dismissAction;
@end

NS_ASSUME_NONNULL_END
