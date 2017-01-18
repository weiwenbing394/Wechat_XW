//
//  ChatroomViewController.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ChatroomViewController.h"
#import "EditorView.h"
#import "TextMessageTableViewCell.h"
#import "Messages.h"

static NSInteger const kEditorHeight = 50;

@interface ChatroomViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) EditorView *editorView;

//距离底部的距离
@property (assign, nonatomic) NSInteger contentOffsetYFarFromBottom;

//数据源
@property (strong, nonatomic) NSMutableArray<Messages*>* chatModelArray;

@end

@implementation ChatroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildView];
}

//设置视图
- (void)buildView{
    self.navigationItem.title=self.barTitle;
    [self buildTableView];
    [self buildEditorView];
    [self bindConstraints];
    [self loadData];
}

//创建tableview视图
- (void)buildTableView{
    if (self.tableView!=nil) {
        return;
    }
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    self.tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[TextMessageTableViewCell class] forCellReuseIdentifier:kCellIdentifierLeft];
    [self.tableView registerClass:[TextMessageTableViewCell class] forCellReuseIdentifier:kCellIdentifierRight];
    self.tableView.tableFooterView=[UIView new];
    [self.view addSubview:self.tableView];
    //添加手势，关闭键盘
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTextEditing)];
    tap.numberOfTapsRequired=1;
    [self.tableView addGestureRecognizer:tap];
}

//关闭键盘
- (void)endTextEditing{
    [self.view endEditing:YES];
}

//创建editorView视图
- (void)buildEditorView{
    if (self.editorView!=nil) {
        return;
    }
    self.editorView=[EditorView editor];
    [self.view addSubview:self.editorView];
    
    __weak typeof(self) weakSelf=self;
    //键盘将要弹出
    [weakSelf.editorView setKeyboardWasShown:^(NSInteger animCurveKey, CGFloat duration,CGSize keyboardSize) {
        if (keyboardSize.height==0) {
            return ;
        }
        //若要在修改约束的同时进行动画的话，需要调用其父视图的layoutIfNeeded方法，并在动画中再调用一次
        [weakSelf.editorView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-keyboardSize.height);
        }];
        [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-keyboardSize.height-kEditorHeight);
        }];
        [UIView animateWithDuration:duration delay:0 options:animCurveKey animations:^{
            [weakSelf.view layoutIfNeeded];
            //滚动动画必须在约束动画之后执行，不然会被中断
            [weakSelf scrollToBottom:true];
        } completion:nil];
    }];
    //键盘将要消失
    [weakSelf.editorView setKeyboardWillBeHidden:^(NSInteger animCurveKey, CGFloat duration,CGSize keyboardSize) {
        [weakSelf.view layoutIfNeeded];
        [weakSelf.editorView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
        }];
        [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-kEditorHeight);
        }];
        [UIView animateWithDuration:duration delay:0 options:animCurveKey animations:^{
            [weakSelf.view layoutIfNeeded];
        } completion:nil];
        
    }];
    //发送消息
    [weakSelf.editorView setMessageWasSend:^(id message, ChatMessageType messageType) {
        Messages *model=[[Messages alloc]init];
        model.message=message;
        model.messageType=ChatMessageTypeText;
        model.sender=1;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.chatModelArray.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath ] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

//滑动tableview到底部
- (void)scrollToBottom:(BOOL)animated{
    if (self.chatModelArray.count==0) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatModelArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

//添加视图约束
- (void)bindConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(-kEditorHeight);
    }];
    [self.editorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(kEditorHeight);
    }];
}

//加载数据
- (void)loadData{
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"我是机器人的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=0;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"用户的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=1;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"我是机器人的聊天记录，我是机器人的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=0;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"用户的聊天记录，用户的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=1;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=0;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"用户的聊天记录，用户的聊天记录，用户的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=1;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=0;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"用户的聊天记录，用户的聊天记录，用户的聊天记录，用户的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=1;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=0;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"用户的聊天记录，用户的聊天记录，用户的聊天记录，用户的聊天记录，用户的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=1;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录，我是机器人的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=0;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    for (int i=0; i<1; i++) {
        Messages *model=[[Messages alloc]init];
        model.message=@"用户的聊天记录，用户的聊天记录，用户的聊天记录，用户的聊天记录，用户的聊天记录，用户的聊天记录";
        model.messageType=ChatMessageTypeText;
        model.sender=1;
        model.showSendTime=NO;
        [self.chatModelArray addObject:model];
    }
    [self.tableView reloadData];
}


#pragma mark - tableview

- (CGFloat)tableView:(UITableView*)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    Messages* model = self.chatModelArray[indexPath.row];
    CGFloat height = model.height;
    
    if (!height) {
        height = [self.tableView
                  fd_heightForCellWithIdentifier:[self chatroomIdentifier:indexPath]
                  cacheByIndexPath:indexPath
                  configuration:^(TextMessageTableViewCell* cell) {
                      cell.model = model;
                  }];
        
        model.height = height;
    }
    
    return height;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModelArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    TextMessageTableViewCell* cell = [tableView
                                      dequeueReusableCellWithIdentifier:[self chatroomIdentifier:indexPath]];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)configureCell:(TextMessageTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    Messages* model = self.chatModelArray[indexPath.row];
    cell.model = model;
}

- (NSString*)chatroomIdentifier:(NSIndexPath*)indexPath{
    return self.chatModelArray[indexPath.row].sender == 1 ? kCellIdentifierRight
    : kCellIdentifierLeft;
}

+ (NSInteger)EditorHeight{
    return kEditorHeight;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.editorView removeFromSuperview];
    self.editorView=nil;
    
    [self.tableView removeFromSuperview];
    self.tableView=nil;
}

#pragma mark 懒加载
- (NSMutableArray *)chatModelArray{
    if (!_chatModelArray) {
        _chatModelArray=[NSMutableArray array];
    }
    return _chatModelArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scrollToBottom:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
