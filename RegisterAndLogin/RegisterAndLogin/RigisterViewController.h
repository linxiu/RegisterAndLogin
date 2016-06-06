//
//  RigisterViewController.h
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/25.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSInteger,RegisterMethodType){

    RegisterMethodEamil = 0,
    RegisterMethodPhone,
};

@interface RigisterViewController : BaseViewController

@property(nonatomic,assign) RegisterMethodType methodType;

@end
