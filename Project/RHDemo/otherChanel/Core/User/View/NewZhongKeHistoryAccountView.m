
#import "ZhongkeUserTableViewCell.h"
#import "NewZhongKeHistoryAccountView.h"
#import "NewZhongkeSetNewPwdTipsView.h"
#import "SDKUserAccountModel.h"
#import "UserDataModel.h"
#import "NSUserDefaults+Category.h"
#import "UserDataController.h"
#import "LQGetMessage.h"
@interface NewZhongKeHistoryAccountView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *accountList;
@property (nonatomic,strong) UITableView * accountTable;
@property (nonatomic,strong)UserModel *selectModel;
@end

@implementation NewZhongKeHistoryAccountView

- (void)setupUI{
    
    UserDataController * dc = [[UserDataController alloc]init];
    self.accountList= [dc getAllAccounds];
    
    for (UserModel *model in self.accountList) {
        if ([model.uid isEqualToString:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]]) {
            model.isSelect = YES;
            self.selectModel =model;
        }
    }
    
 
    
    self.titleLbl.hidden = YES;
    self.backBtn.hidden = YES;
    self.LogingTypeLbl.text = @"切换账号";
    self.backForPhoneView.hidden = YES;
    self.LogingTypeLbl.hidden = NO;
    [self addSubview:self.accountTable];
    self.backForPhoneView.backgroundColor = rgba(252, 197, 105, 1);
    [self addSubview:self.otherLogin];
    [self.loginBtn setTitle:@"确认登录" forState:UIControlStateNormal];
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkePhoneLoginView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

}


- (NSMutableArray *)accountList{
    if (!_accountList) {
        _accountList = [NSMutableArray new];
    }
    return _accountList;
    
}


- (UITableView *)accountTable{
    if (!_accountTable) {
        _accountTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _accountTable.delegate=self;
        _accountTable.dataSource = self;
        _accountTable.backgroundColor = [UIColor clearColor];
        _accountTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _accountTable.showsVerticalScrollIndicator = NO;
        _accountTable.showsHorizontalScrollIndicator = NO;
    }
    return _accountTable;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
     return 1;
}



//每一部分有几条数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.accountList.count;
  
}

//每一数据的具体显示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    //从空闲队列里取出一个cell
    ZhongkeUserTableViewCell *cell=[ZhongkeUserTableViewCell cellWithTableView:tableView withCellIdentifier:cellId];
    //cell的一些具体展示
    
    cell.paramsModel = self.accountList[indexPath.row];
    return cell;
}

//设置每一行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_FIT(60);
}

//每一行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (UserModel *model in self.accountList) {
        if (model == self.accountList[indexPath.row]) {
            model.isSelect = YES;
            self.selectModel = model;
        }else{
            model.isSelect = NO;
        }
    }
    [self.accountTable reloadData];
}



- (void)updateFrame{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait ||sataus ==  UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(45), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(45), SCREEN_FIT(30), SCREEN_FIT(30));

        self.accountTable.frame =CGRectMake(SCREEN_FIT(30),CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(20),ZKUserViewWidth-SCREEN_FIT(60),SCREEN_FIT(240));
        
         self.otherLogin.frame =CGRectMake(CGRectGetMinX(self.accountTable.frame), CGRectGetMaxY(self.accountTable.frame)+SCREEN_FIT(10), CGRectGetWidth(self.accountTable.frame),SCREEN_FIT(30));
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.otherLogin.frame),CGRectGetMaxY(self.otherLogin.frame)+SCREEN_FIT(20), CGRectGetWidth(self.accountTable.frame),SCREEN_FIT(50));
        
    }else {//横版
             self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
            self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(20), SCREEN_FIT(30), SCREEN_FIT(30));
            self.backForPhoneView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.backBtn.frame)+SCREEN_FIT(0), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(1));
            self.accountTable.frame =CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), CGRectGetMaxY(self.backForPhoneView.frame)+SCREEN_FIT(0), CGRectGetWidth(self.backForPhoneView.frame),windowHeight-CGRectGetMaxY(self.backForPhoneView.frame)-SCREEN_FIT(100));
            self.otherLogin.frame =CGRectMake(CGRectGetMinX(self.accountTable.frame), CGRectGetMaxY(self.accountTable.frame), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(20));
            self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.otherLogin.frame), windowHeight-SCREEN_FIT(65), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(45));

    }
}


- (BaseButton *)otherLogin{
    if (!_otherLogin) {
        _otherLogin = [BaseButton new];
        [_otherLogin setTitle:@"使用其他账号登录" forState:UIControlStateNormal];
        [_otherLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _otherLogin.backgroundColor = [UIColor clearColor];
        [_otherLogin addTarget:self action:@selector(oterLogin) forControlEvents:UIControlEventTouchUpInside];
        _otherLogin.titleLabel.font = font(15);
    }
    return _otherLogin;
}


//其他方式登录
- (void)oterLogin{
    if (self.otherLoginCallBlock) {
        self.otherLoginCallBlock();
    }
}


//登录
- (void)loginBtnAction{
    if (self.loginCallBlock) {
        COMMONMETHOD.expires_in = self.selectModel.expires_in;
        COMMONMETHOD.refresh_token_expires_in = self.selectModel.refresh_token_expires_in;
        COMMONMETHOD.userType = self.selectModel.user_type;
        COMMONMETHOD.phone =self.selectModel.phone;
        self.loginCallBlock(self.selectModel.uid,self.selectModel.userName,self.selectModel.passWord,self.selectModel.access_token,self.selectModel.sub_uid);
    }
}

- (void)changeRotateNewZhongkePhoneLoginView:(NSNotification*)noti {
    [self updateFrame];
    
}

@end
