//
//  InsetsTextField.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "InsetsTextField.h"

@implementation InsetsTextField

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, self.textFieldInset.x, self.textFieldInset.y);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, self.textFieldInset.x, self.textFieldInset.y);
}

@end
