//
//  MessageCell.h
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/9.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGView.h"
#import "CommentCell.h"
@class MessageCell;
@class MessageModel;

@protocol MessageCellDelegate <NSObject>

//刷新在指定indexPath的tableviewcell的height
- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath;

- (void)passCellHeightWithMessageModel:(MessageModel *)messageModel commentModel:(CommentModel *)commentModel atCommentIndexPath:(NSIndexPath *)commentIndexPath cellHeight:(CGFloat )cellHeight commentCell:(CommentCell *)commentCell messageCell:(MessageCell *)messageCell;

@end

@interface MessageCell : UITableViewCell

/**
 * 朋友圈九宫格图片视图
 */
@property (nonatomic, strong) JGGView *jggView;
/**
 *  全文按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(UIButton *moreBtn,NSIndexPath * indexPath);

/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,NSIndexPath * indexPath);
/**
 *  点击图片的block
 */
@property (nonatomic, copy)TapBlcok tapImageBlock;
/**
 *  delegate
 */
@property (nonatomic, weak) id<MessageCellDelegate> delegate;
/**
 *  配置cell的model
 */
- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath;

@end
