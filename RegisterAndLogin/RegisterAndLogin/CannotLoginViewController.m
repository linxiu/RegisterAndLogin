//
//  CannotLoginViewController.m
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/25.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import "CannotLoginViewController.h"
#import "textField.h"
static const CGFloat textFieldH = 45;
@interface CannotLoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)textField *phoneTextField;
@end

@implementation CannotLoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"找回密码";
//    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
//    paddingView1.backgroundColor = [UIColor lightGrayColor];
//    self.phoneTextField .leftView = paddingView1;
//    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
//    [self.view addSubview:paddingView1];
//    
//    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width,textFieldH )];
//    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"手机" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.phoneTextField.delegate = self;
//    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.phoneTextField.returnKeyType = UIReturnKeyDone;
//    [paddingView1 addSubview:self.phoneTextField];
//
    self.phoneTextField = [[textField alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,textFieldH )];
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"手机" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.phoneTextField.delegate = self;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.returnKeyType = UIReturnKeyDone;
    self.phoneTextField.backgroundColor = [UIColor lightGrayColor];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
