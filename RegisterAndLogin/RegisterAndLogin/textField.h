//
//  textField.h
//  test
//
//  Created by Ashes of time on 5/27/16.
//  Copyright © 2016 ZQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface textField : UITextField

//控制 placeHolder 的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds;

// 控制文本的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds;
@end
