//
//  CoverHeaderView.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/18.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)coverHeaderWithCover:(UIImage*)cover avatar:(UIImage*)image name:(NSString*)name;

@end
