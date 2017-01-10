//
//  CommentCell.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/9.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;

//评论内容的uitableviewcell
@interface CommentCell : UITableViewCell

//显示评论内容的uilabel
@property (nonatomic, strong) UILabel *contentLabel;

- (void)configCellWithModel:(CommentModel *)model;

@end
