//
//  AddressBookCell.h
//  IHKApp
//
//  Created by 郑文明 on 15/4/23.
//  Copyright (c) 2015年 www.ihk.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
