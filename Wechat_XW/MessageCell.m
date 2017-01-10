//
//  MessageCell.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/9.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"

@interface MessageCell ()<UITableViewDelegate,UITableViewDataSource>

//说说的发布者
@property (nonatomic, strong) UILabel *nameLabel;
//说说的内容
@property (nonatomic, strong) UILabel *descLabel;
//说说发布者的头像
@property (nonatomic, strong) UIImageView *headImageView;
//说说的评论列表
@property (nonatomic, strong) UITableView *tableView;
//查看全文按钮
@property (nonatomic, strong) UIButton *moreBtn;
//评论按钮
@property (nonatomic, strong) UIButton *commentBtn;
//model
@property (nonatomic, strong) MessageModel *messageModel;
//点击的indexPath
@property (nonatomic, strong) NSIndexPath *indexPath;


@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        //头像
        self.headImageView = [[UIImageView alloc] init];
        self.headImageView.backgroundColor = [UIColor whiteColor];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kGAP);
            make.width.height.mas_equalTo(kAvatar_Size);
        }];
        //说说发布者名称
        self.nameLabel = [UILabel new];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.textColor = [UIColor colorWithRed:(54/255.0) green:(71/255.0) blue:(121/255.0) alpha:0.9];
        self.nameLabel.preferredMaxLayoutWidth = screenWidth - kGAP-kAvatar_Size - 2*kGAP-kGAP;
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
            make.top.mas_equalTo(self.headImageView.mas_top);
            make.right.mas_equalTo(-kGAP);
        }];
        //说说的内容
        self.descLabel = [UILabel new];
        //self.descLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.descLabel];
        self.descLabel.preferredMaxLayoutWidth =screenWidth - kGAP-kAvatar_Size ;
        self.descLabel.numberOfLines = 0;
        self.descLabel.font = [UIFont systemFontOfSize:14.0];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom);
        }];
        //查看全文
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [self.moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateSelected];
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.moreBtn.selected = NO;
        [self.moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
        //九宫格图片
        self.jggView = [JGGView new];
        [self.contentView addSubview:self.jggView];
        [self.jggView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kGAP);
            make.size.mas_equalTo(CGSizeZero);
        }];
        //评论
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentBtn.backgroundColor = [UIColor whiteColor];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentBtn setTitle:@"评论" forState:UIControlStateSelected];
        [self.commentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.commentBtn.layer.borderWidth = 1;
        self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateNormal];
        [self.commentBtn setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateSelected];
        [self.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.commentBtn];
        self.commentBtn.layer.cornerRadius = 24/2;
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.jggView.mas_bottom).offset(kGAP);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(24);
        }];
        //评论列表
        self.tableView = [[UITableView alloc] init];
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"Cell"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        //self.tableView.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.jggView);
            make.top.mas_equalTo(self.commentBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(screenWidth - kGAP-kAvatar_Size - 2*kGAP-kGAP, 0));
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_equalTo(0);
        }];
    }
    return self;
}

//查看全文
-(void)moreAction:(UIButton *)sender{
    if (self.MoreBtnClickBlock) {
        self.MoreBtnClickBlock(sender,self.indexPath);
    }
}

//评论
-(void)commentAction:(UIButton *)sender{
    if (self.CommentBtnClickBlock) {
        self.CommentBtnClickBlock(sender,self.indexPath);
    }
}

//配置model
- (void)configCellWithModel:(MessageModel *)model indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    self.messageModel = model;
    //姓名
    self.nameLabel.text = model.userName;
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //说说内容
    self.descLabel.textAlignment=NSTextAlignmentLeft;
    self.descLabel.font=[UIFont systemFontOfSize:14];
    self.descLabel.highlightedTextColor = [UIColor blackColor];//设置文本高亮显示颜色，与highlighted一起使用。
    self.descLabel.highlighted = YES; //高亮状态是否打开
    self.descLabel.enabled = YES;//设置文字内容是否可变
    self.descLabel.userInteractionEnabled = YES;//设置标签是否忽略或移除用户交互。默认为NO
    self.descLabel.text = model.message;
    //说说内容的高度
    CGFloat h=[model.message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+0.5;
    //说说内容是否展开
    if (model.isExpand) {
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
            make.height.mas_equalTo(h);
        }];
    }else{//闭合
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.nameLabel);
                make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP);
                make.height.mas_equalTo(h>=60?60:h);
        }];
    }
    if (h<=60) {
        //查看全文按钮
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }else{
        //查看全文按钮
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
    }
    self.moreBtn.selected = model.isExpand;
    //说说图片九宫格
    CGFloat jjg_height = 0.0;
    CGFloat jjg_width  = 0.0;
    if (model.messageBigPics.count>0) {
        jjg_width  =3*([JGGView imageWidth]+kJGG_GAP)-kJGG_GAP;
        jjg_height =([JGGView imageHeight]+kJGG_GAP)*((model.messageBigPics.count+2)/3)-kJGG_GAP;
    }
    //解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //初始化九宫格
    [self.jggView JGGView:self.jggView DataSource:model.messageBigPics completeBlock:^(NSInteger index, NSArray *dataSource,NSIndexPath *indexpath) {
        self.tapImageBlock(index,dataSource,self.indexPath);
    }];
    [self.jggView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreBtn);
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kJGG_GAP);
        make.size.mas_equalTo(CGSizeMake(jjg_width, jjg_height));
    }];
    //评论列表
    [self.tableView reloadData];
    CGFloat tableViewHeight = 0;
    for (int i=0;i<model.commentModelArray.count;i++) {
        CommentModel *commentmodel=model.commentModelArray[i];
        CGFloat cellHeight = [self.tableView fd_heightForCellWithIdentifier:@"Cell" cacheByIndexPath:[NSIndexPath indexPathForRow:i inSection:0] configuration:^(id cell) {
            [cell configCellWithModel:commentmodel];
        }];
        tableViewHeight += cellHeight;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.jggView);
        make.top.mas_equalTo(self.commentBtn.mas_bottom).offset(kGAP);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP-kGAP, tableViewHeight));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_equalTo(0);
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CommentModel *model = [self.messageModel.commentModelArray objectAtIndex:indexPath.row];
    [cell configCellWithModel:model];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModel.commentModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *model = [self.messageModel.commentModelArray objectAtIndex:indexPath.row];
    CGFloat cell_height = [tableView fd_heightForCellWithIdentifier:@"Cell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell configCellWithModel:model];
    }];
    return cell_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentModel *commentModel = [self.messageModel.commentModelArray objectAtIndex:indexPath.row];
    CGFloat cell_height = [tableView fd_heightForCellWithIdentifier:@"Cell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell configCellWithModel:commentModel];
    }];
    if ([self.delegate respondsToSelector:@selector(passCellHeightWithMessageModel:commentModel:atCommentIndexPath:cellHeight:commentCell:messageCell:)]) {
        self.messageModel.shouldUpdateCache = YES;
        CommentCell *commetCell =  (CommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self.delegate passCellHeightWithMessageModel:_messageModel commentModel:commentModel atCommentIndexPath:indexPath cellHeight:cell_height commentCell:commetCell messageCell:self];
    }
}

@end
