//
//  textField.m
//  test
//
//  Created by Ashes of time on 5/27/16.
//  Copyright © 2016 ZQ. All rights reserved.
//

#import "textField.h"

@implementation textField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10*1 , 0 );
}

// 控制文本的位置，左
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10*1 , 0 );
}
@end
