//
//  BaseMessageTableViewCell.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseMessageTableViewCell.h"
#import "DateUtil.h"
#import "Messages.h"
#import "InsetsTextField.h"
//头像大小
static NSInteger const kAvatarSize = 40;
//边框间隙
static NSInteger const kAvatarMarginH = 10;

@interface BaseMessageTableViewCell ()
//发送时间
@property (nonatomic,strong)InsetsTextField* sendTimeField;
//头像
@property (strong, nonatomic) UIImageView* avatarImageView;

@end

@implementation BaseMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.alignement = [reuseIdentifier isEqualToString:kCellIdentifierLeft]
        ? MessageAlignementLeft
        : MessageAlignementRight;
        
        [self buildCell];
        [self bindConstraints];
        [self bindGestureRecognizer];
    }
    return self;

}

//创建uitableviewcell
- (void)buildCell{
    //发送消息时间
    self.sendTimeField=[[InsetsTextField alloc]init];
    self.sendTimeField.backgroundColor=[UIColor colorWithWhite:.83 alpha:1];
    self.sendTimeField.textColor=[UIColor whiteColor];
    self.sendTimeField.font = [UIFont systemFontOfSize:12];
    self.sendTimeField.textAlignment = NSTextAlignmentCenter;
    self.sendTimeField.layer.cornerRadius = 5;
    self.sendTimeField.textFieldInset = CGPointMake(3, 3);
    self.sendTimeField.userInteractionEnabled = false;
    [self.contentView addSubview:self.sendTimeField];
    //头像
    self.avatarImageView=[[UIImageView alloc]init];
    self.avatarImageView.image=self.alignement==MessageAlignementRight?[UIImage imageNamed:@"flappy doge-original"]:[UIImage imageNamed:@"robot"];
    [self.contentView addSubview:self.avatarImageView];
    //聊天气泡背景
    self.bubbleView=[[UIImageView alloc]init];
    self.bubbleView.userInteractionEnabled = true;
    UIImage *bubbleImage=self.alignement==MessageAlignementRight?[UIImage imageNamed:@"SenderTextNodeBkg"]:[UIImage imageNamed:@"ReceiverTextNodeBkgHL"];
    self.bubbleView.image=[bubbleImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    [self.contentView addSubview:self.bubbleView];
};

//更改视图约束
- (void)bindConstraints{
    __weak typeof(self) weakSelf = self;
    //发送时间
    [self.sendTimeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.avatarImageView.mas_top).offset(-10);
        make.centerX.offset(0);
    }];
    //头像
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(kAvatarSize);
        if (weakSelf.alignement==MessageAlignementLeft) {
            make.leading.mas_equalTo(kAvatarMarginH);
        }else{
            make.trailing.mas_equalTo(-kAvatarMarginH);
        }
    }];
    //气泡
    [self.bubbleView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(weakSelf.avatarImageView).offset(-2);
        make.width.lessThanOrEqualTo(weakSelf.contentView);
        if (self.alignement == MessageAlignementLeft) {
            //指view的左边在avatar的右边，边距为5
            make.left.equalTo(weakSelf.avatarImageView.mas_right).offset(5);
            //这个地方必须制定contentView，不指定的话没有效果
            make.right.lessThanOrEqualTo(weakSelf.contentView).offset(-50);
        } else {
            make.right.equalTo(weakSelf.avatarImageView.mas_left).offset(-5);
            make.left.greaterThanOrEqualTo(weakSelf.contentView).offset(50);
        }
        /*惯例*/
        //make.bottom.offset(-5).priorityLow();
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
};

//长按气泡
- (void)bindGestureRecognizer{
    UILongPressGestureRecognizer *bubblelongPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnBubble:)];
    [self.bubbleView addGestureRecognizer:bubblelongPress];
}

- (void)longPressOnBubble:(UILongPressGestureRecognizer*)press{
    
}


//设置内容
- (void)setModel:(Messages *)model{
    _model=model;
    if (self.model.showSendTime) {
        self.sendTimeField.text= [DateUtil localizedShortDateStringFromInterval:self.model.sendTime];
        self.sendTimeField.hidden=false;
        [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40);
        }];
        
    }else{
        self.sendTimeField.hidden = true;
        [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.top.offset(5);
        }];
    }
    
}


@end
