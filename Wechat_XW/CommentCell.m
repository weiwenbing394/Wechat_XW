//
//  CommentCell.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/9.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //contentLabel
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.backgroundColor  = [UIColor clearColor];
        self.contentLabel.textColor=[UIColor blackColor];
        self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:13.0];
       [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).offset(3.0);//cell上部距离为3.0个间隙
            make.bottom.mas_equalTo(self.contentView).mas_equalTo(-3);
        }];
    }
    return self;
}

- (void)configCellWithModel:(CommentModel *)model {
    NSString *str  = nil;
    if (![model.commentByUserName isEqualToString:@""]) {
        str= [NSString stringWithFormat:@"%@回复%@:%@",
              model.commentUserName, model.commentByUserName, model.commentText];
    }else{
        str= [NSString stringWithFormat:@"%@:%@",
              model.commentUserName, model.commentText];
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]
                 range:NSMakeRange(0, model.commentUserName.length)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]
                 range:NSMakeRange(model.commentUserName.length + 2, model.commentByUserName.length)];
    self.contentLabel.attributedText = text;
}

@end
