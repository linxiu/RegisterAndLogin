//
//  LoginViewController.m
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/25.
//  Copyright © 2016年 甘真辉. All rights reserved.

#import "LoginViewController.h"
#import "Masonry.h"
#import "CannotLoginViewController.h"
#import "RigisterViewController.h"
#import "UnderlineField.h"
#import "Validate.h"
#import "DNTool.h"
#import "User.h"
#import "Encryption.h"
#import "VPKCRequestManager.h"

#define DMWindow ((UIWindow *)[[[UIApplication sharedApplication] windows] lastObject])
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define DMScreenWidth [UIScreen mainScreen].bounds.size.width
#define DMScreenHeight [UIScreen mainScreen].bounds.size.height
#define DMViewWidth(view) view.frame.size.width
#define DMViewHeight(view) view.frame.size.height
static CGFloat const logoY = 196/3; // logo图标Y坐标
static CGFloat const logoW = 303; // logo图标宽
static CGFloat const logoH = 363; // logo图标高
static CGFloat const inputX = 10; // 输入框X坐标
static CGFloat const inputH = 39; // 输入框高
static CGFloat const iconBottomInterval = 30; // 图标底部间距
static CGFloat const logButtonBottomInterval = 20; // 登录按钮底部间距
static CGFloat const loginButtonH = 45; // 登录按钮高度
static CGFloat const findWordButtonH = 20; // 忘记密码按钮高度
@interface LoginViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *myscrollView;
@property (nonatomic, strong) UnderlineField *nameTextField;
@property (nonatomic, strong) UnderlineField *passwordTextField;

@property (strong, nonatomic) UIButton *loginBtn,*cannotLoginBtn,*registerBtn;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (strong, nonatomic) UIImageView *iconUserView, *bgBlurredView;
@property (strong, nonatomic) UIView *bottomView;
@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //背景图片
 
    _bgBlurredView = ({
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:kScreen_Bounds];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        bgView.image = [UIImage imageNamed:@"STARTIMAGE.jpg"];
        [self.view addSubview:bgView];
        
        bgView;
    
    });
    //添加scrollview
    _myscrollView = ({
    
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        scrollView.delegate = self;
        scrollView.alwaysBounceVertical = YES; //支持垂直滚动
        [self.view addSubview:scrollView];
        
        [scrollView  mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.view);
        }];
        scrollView;
    });
    
    [self configUI];
    [self configBottomView]; //添加底部的View和去注册按钮
}

#pragma mark - Table view Header Footer
-(void)configUI{
     //logo
     CGFloat canleW = DMScreenWidth/1242;
    _iconUserView = [[UIImageView alloc] initWithFrame:CGRectMake((DMViewWidth(_myscrollView)-logoW*canleW)/2, logoY, logoW*canleW, logoH*canleW)];
    _iconUserView.contentMode = UIViewContentModeScaleAspectFit;
    _iconUserView.layer.masksToBounds = YES;
    _iconUserView.layer.cornerRadius = _iconUserView.frame.size.width/2;
//    _iconUserView.layer.borderWidth = 1;
//    _iconUserView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_iconUserView setImage:[UIImage imageNamed:@"icon_user_monkey"]];
    [_myscrollView addSubview:_iconUserView];
 
    
 //textField
    self.nameTextField = [[UnderlineField alloc]initWithFrame:CGRectMake(inputX, _iconUserView.frame.origin.y+_iconUserView.frame.size.height+iconBottomInterval, DMViewWidth(_myscrollView)-inputX*2, inputH)];
    [_myscrollView addSubview:self.nameTextField];
    _nameTextField.delegate = self;
    _nameTextField.font = [UIFont systemFontOfSize:15];
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.textColor = [UIColor whiteColor];
    UIColor *color = [UIColor whiteColor]; //placeholder的文字颜色
    _nameTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"手机号码/电子邮箱/个性后缀" attributes:@{NSForegroundColorAttributeName: color}];
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // phoneImage
//    _nameTextField.leftView = [self creatLabelForText:@"账号"];
//    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField = [[UnderlineField alloc]initWithFrame:CGRectMake(inputX, _nameTextField.frame.origin.y+_nameTextField.frame.size.height+inputX, DMViewWidth(_myscrollView)-inputX*2, inputH)];
    [_myscrollView addSubview:self.passwordTextField];
    _passwordTextField.delegate = self;
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.returnKeyType = UIReturnKeyGo;
    _passwordTextField.textColor = [UIColor whiteColor];
   _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_passwordTextField setSecureTextEntry:YES];
    
    // phoneImage
//    _passwordTextField.leftView =  [self creatLabelForText:@"密码"];
//    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //按钮
    _loginBtn =[[UIButton alloc]initWithFrame:CGRectMake(inputX, _passwordTextField.frame.origin.y+_passwordTextField.frame.size.height+logButtonBottomInterval, self.view.frame.size.width-inputX*2, loginButtonH)];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:[UIColor greenColor]];
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = loginButtonH/2;
    [_loginBtn addTarget:self action:@selector(sendLogin) forControlEvents:UIControlEventTouchUpInside];
    [_myscrollView addSubview:_loginBtn];
    
    CGFloat findButtonW = 100;
    CGFloat findbuttonInterval = 30;
    _cannotLoginBtn = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((_myscrollView.frame.size.width-findButtonW)/2, _loginBtn.frame.origin.y+_loginBtn.frame.size.height+findbuttonInterval,findButtonW, findWordButtonH)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.5] forState:UIControlStateHighlighted];
        
        [button setTitle:@"找回密码" forState:UIControlStateNormal];
        [_myscrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.centerX.equalTo(_myscrollView);
            make.top.equalTo(_loginBtn.mas_bottom).offset(20);
        }];
        button;
    });
    [_cannotLoginBtn addTarget:self action:@selector(cannotLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark BottomView
- (void)configBottomView{

    CGFloat RegisterBtnH = 40; // zhuce按钮高
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _myscrollView.frame.size.height - 55, _myscrollView.frame.size.width, 55)];
        _bottomView.backgroundColor = [UIColor clearColor];
        UIButton *registerBtn = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, RegisterBtnH)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.5] forState:UIControlStateHighlighted];
            
            [button setTitle:@"去注册" forState:UIControlStateNormal];
            [_bottomView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100, 30));
                make.centerX.equalTo(_bottomView);
                make.top.equalTo(_bottomView);
            }];
            button;
        });
        [registerBtn addTarget:self action:@selector(goRegisterVC:) forControlEvents:UIControlEventTouchUpInside];
        [_myscrollView addSubview:_bottomView];
    }

}
#pragma mark - ---------------- 代理 -----------------
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
 self.loginBtn.enabled = YES;
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.loginBtn.enabled = NO; //用户还没有输入的时候登录不能被点击
    CGFloat fixedTop = DMScreenHeight-252; // 当键盘出现时 文本输入框距离顶端的固定距离
    CGRect convertRect = [_myscrollView convertRect:textField.frame fromView:textField.superview];
    CGFloat textFiledTop = convertRect.origin.y + textField.frame.size.height;
    
    CGFloat dispersion = 0.0f;
    CGFloat offsetY = _myscrollView.contentOffset.y;
    if (textFiledTop > fixedTop) {
        dispersion = textFiledTop-fixedTop-offsetY;
        CGPoint offset = _myscrollView.contentOffset;
        offset.y += dispersion;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        _myscrollView.contentOffset = offset;
        [UIView commitAnimations];
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:_nameTextField]) {
        [_passwordTextField becomeFirstResponder];
    } else if ([textField  isEqual:_passwordTextField]) {
        [self sendLogin];
    }

    return YES;
}

//限制输入空格
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboardAction];
}
#pragma mark - 隐藏键盘
- (void)hideKeyboardAction
{
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}
-(BOOL)validateInput{
    if ([Validate isBlankString:_nameTextField.text]) {//判断输入为空
        [_nameTextField becomeFirstResponder];
        return NO;
    }else if ([Validate isBlankString:_passwordTextField.text]){
        [_passwordTextField becomeFirstResponder];
        return NO;
    }else if ([self AuthAccount]){ //读取信息
        if (![Validate isLegalMobilePhoneNumber:_nameTextField.text]) {
            [_nameTextField becomeFirstResponder];
            [DNTool HUDTextOnly:@"手机号不合法" toView:DMWindow];
            return NO;
        }
}
   return YES;
  
}
#pragma mark - 用户登录信息读取
- (NSString *)AuthAccount
{
     return [User readUserID];
}
#pragma mark - 用户登录信息保存与删除
- (void)storeAuthAccount:(NSString *)account
{
    if (![[self AuthAccount]isEqualToString:account]) {
        //推出登录清除用户数据
        [User deleteUserData];
        [User deletePassWord];
        [User deleteUserHeadImageUrl];
    }
    [User saveUserID:account];
   
}

#pragma mark - 列表复原
- (void)scrollViewRecovery
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _myscrollView.contentOffset = CGPointMake(0, -_myscrollView.contentInset.top);
    [UIView commitAnimations];
}
#pragma mark  click event
-(void)sendLogin{
    NSLog(@"--点击--");

    if ([self validateInput]) { //认证手机号
        [self hideKeyboardAction];  //收起键盘
        [self scrollViewRecovery];
        
        if ([self AuthAccount]) {//读取账号信息
            
          [self storeAuthAccount:_nameTextField.text]; //保存账号信息
        }
    }
//    self.hud = [DNTool HUDLoadingOnView:self.view delegate:self];
//    NSDictionary *parameters;
//    if ([self AuthAccount]) {  //登录加密
//            NSDictionary *dicWithEncryption = [Encryption loginEncryptionAttestationWithMobile:_nameTextField.text withpassword:[DNTool md5: [NSString stringWithFormat:@"%@%@",[DNTool md5:_passwordTextField.text],DMPWD]]];
//        
//                parameters = @{@"mobile": _nameTextField.text,
//                                             @"password": [DNTool md5: [NSString stringWithFormat:@"%@%@",[DNTool md5:_passwordTextField.text],DMPWD]],
//                                             @"login_sign":dicWithEncryption[@"login_sign"],
//                                             @"login_random":dicWithEncryption[@"login_random"] };
//         [self loginRequestWithDictionary:parameters]; //发送请求
//    }
    
 
}
#pragma mark - ---------------- 请求 -----------------
#pragma mark - 登录
- (void)loginRequestWithDictionary:(NSDictionary *)dictionary{

    [VPKCRequestManager POST:@"http://dmallapi.dm188.cn/v200/member/login" withParame:dictionary withComplete:^(VPKCResponse *responseObj) {
        
        if ([responseObj.status isEqualToNumber:@200]) {
            
            NSLog(@"***%@***",responseObj);
            [self.hud hide:YES];
        }
    }];

}
-(void)cannotLoginBtnClicked:(UIButton *)btn{
   CannotLoginViewController *forgetwordVC = [[CannotLoginViewController alloc]init];
    [self.navigationController pushViewController:forgetwordVC animated:YES];
  
}
-(void)goRegisterVC:(id)sender{
    RigisterViewController *rigisterVC = [[RigisterViewController alloc]init];
    [self.navigationController pushViewController:rigisterVC animated:YES];
}
@end
