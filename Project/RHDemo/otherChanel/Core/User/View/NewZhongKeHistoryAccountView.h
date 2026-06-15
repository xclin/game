
#import "ZhongkeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewZhongKeHistoryAccountView : ZhongkeView
@property (nonatomic,strong) BaseButton *otherLogin;
@property (nonatomic,copy)  void (^loginCallBlock)( NSString * _Nullable uid,NSString * _Nullable userName,NSString * _Nullable pwd,NSString *_Nullable token,NSString *sub_uid);
@property (nonatomic,copy)  void (^otherLoginCallBlock)();
@end

NS_ASSUME_NONNULL_END
