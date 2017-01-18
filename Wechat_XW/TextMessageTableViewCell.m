//
//  TextMessageTableViewCell.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "TextMessageTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "Messages.h"

static UIFont *textFont;

@interface TextMessageTableViewCell ()

//聊天内容
@property (nonatomic,strong)TTTAttributedLabel * messageLabel;

@end

@implementation TextMessageTableViewCell

+(void)initialize{
    textFont=[UIFont systemFontOfSize:16];
}

- (void)setModel:(Messages *)model{
    self.messageLabel.text=(NSString*)model.message;
    [super setModel:model];
}

- (void)buildCell{
    [super buildCell];
    self.messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.messageLabel.preferredMaxLayoutWidth =kScreenWidth-10-kAvatar_Size-5-50-40 ;
    self.messageLabel.font = textFont;
    self.messageLabel.numberOfLines = 0;
    [super.bubbleView addSubview:self.messageLabel];
}

- (void)bindConstraints{
    [super bindConstraints];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.insets(UIEdgeInsetsMake(13, 20, 20, 20));
    }];
    [self.messageLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
}

//长按
- (void)longPressOnBubble:(UILongPressGestureRecognizer *)press{
    if (press.state==UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        super.bubbleView.highlighted=YES;
        UIMenuItem *copy=[[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(menuCopy:)];
        UIMenuItem *remove=[[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(menuRemove:)];
        UIMenuController *menu=[UIMenuController sharedMenuController];
        [menu setMenuItems:@[copy,remove]];
        [menu setTargetRect:super.bubbleView.frame inView:self];
        [menu setMenuVisible:YES animated:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIMenuControllerWillHideMenu) name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}

//长按取消
- (void)UIMenuControllerWillHideMenu{
    super.bubbleView.highlighted=NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//能响应的action
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action==@selector(menuCopy:)||action == @selector(menuRemove:));
}

//复制
- (void)menuCopy:(id)sender{
    [UIPasteboard generalPasteboard].string=self.messageLabel.text;
}

//删除
- (void)menuRemove:(id)sender{
}


@end
