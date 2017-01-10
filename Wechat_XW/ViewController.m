//
//  ViewController.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/6.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ViewController.h"
#import "CommentCell.h"
#import "CommentModel.h"
#import "MessageCell.h"
#import "MessageModel.h"

//键盘
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceThemeModel.h"

@interface ViewController ()<ChatKeyBoardDelegate, ChatKeyBoardDataSource,MessageCellDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

//记录table的offset.y
@property (nonatomic, assign) CGFloat history_Y_offset;

//记录点击cell的高度，高度由代理传过来
@property (nonatomic, assign) CGFloat seletedCellHeight;

//专门用来回复选中的cell的model
@property (nonatomic, strong) CommentModel *replayTheSeletedCellModel;

//控制是否刷新table的offset
@property (nonatomic, assign) BOOL needUpdateOffset;

@property (nonatomic,copy)NSIndexPath *currentIndexPath;

//回复的消息的位置
@property (nonatomic,copy)NSIndexPath *commentCellIndexPath;


@end

@implementation ViewController

- (instancetype)init{
    if (self=[super init]) {
        //注册键盘出现NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        //注册键盘隐藏NSNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    //注册键盘出现NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.tableview registerClass:[MessageCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview setTableFooterView:[UIView new]];
    
}

#pragma mark keyboardWillShow
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    if (keyboardHeight==0) {
        return;
    }
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGFloat delta = 0.0;
    if (self.seletedCellHeight){//点击某行，进行回复某人
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-self.seletedCellHeight-kChatToolBarHeight);
    }else{//点击评论按钮
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-kChatToolBarHeight-24-10);//24为评论按钮高度，10为评论按钮上部的5加评论按钮下部的5
    }
    CGPoint offset = self.tableview.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    if (self.needUpdateOffset) {
        [self.tableview setContentOffset:offset animated:YES];
    }
}
#pragma mark keyboardWillHide
- (void)keyboardWillHide:(NSNotification *)notification {
    self.needUpdateOffset = NO;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.chatKeyBoard keyboardDownForComment];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.chatKeyBoard keyboardDownForComment];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark ChatKeyBoardDelegate
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    return @[item1];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}

- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems{
    return nil;
};


-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}

- (void)chatKeyBoardSendText:(NSString *)text{
    MessageModel *messageModel = [self.dataSource objectAtIndex:self.currentIndexPath.row];
    messageModel.shouldUpdateCache = YES;
    //创建一个新的CommentModel,并给相应的属性赋值，然后加到评论数组的最后，reloadData
    CommentModel *commentModel = [[CommentModel alloc]init];
    commentModel.commentUserName = @"文明";
    commentModel.commentUserId = @"274";
    commentModel.commentPhoto = @"http://q.qlogo.cn/qqapp/1104706859/189AA89FAADD207E76D066059F924AE0/100";
    commentModel.commentByUserName = self.replayTheSeletedCellModel?self.replayTheSeletedCellModel.commentUserName:@"";
    commentModel.commentId = [NSString stringWithFormat:@"%i",[self getRandomNumber:100 to:1000]];
    commentModel.commentText = text;
    if (self.commentCellIndexPath&&self.commentCellIndexPath.row<messageModel.commentModelArray.count) {
        [messageModel.commentModelArray insertObject:commentModel atIndex:self.commentCellIndexPath.row+1];
    }else{
        [messageModel.commentModelArray addObject:commentModel];
    }
    [self reloadCellHeightForModel:messageModel atIndexPath:self.currentIndexPath];
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
}

- (void)chatKeyBoardFacePicked:(ChatKeyBoard *)chatKeyBoard faceStyle:(NSInteger)faceStyle faceName:(NSString *)faceName delete:(BOOL)isDeleteKey{
    NSLog(@"%@",faceName);
}
- (void)chatKeyBoardAddFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
}
- (void)chatKeyBoardSetFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
    
}

#pragma mark MessageCellDelegate
- (void)reloadCellHeightForModel:(MessageModel *)model atIndexPath:(NSIndexPath *)indexPath{
    model.shouldUpdateCache = YES;
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)passCellHeightWithMessageModel:(MessageModel *)messageModel commentModel:(CommentModel *)commentModel atCommentIndexPath:(NSIndexPath *)commentIndexPath cellHeight:(CGFloat )cellHeight commentCell:(CommentCell *)commentCell messageCell:(MessageCell *)messageCell{
    self.needUpdateOffset = YES;
    self.replayTheSeletedCellModel = commentModel;
    self.currentIndexPath = [self.tableview indexPathForCell:messageCell];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",commentModel.commentUserName];
    self.history_Y_offset = [commentCell.contentLabel convertRect:commentCell.contentLabel.bounds toView:window].origin.y;
    self.commentCellIndexPath=commentIndexPath;
    self.seletedCellHeight = cellHeight;
    [self.chatKeyBoard keyboardUpforComment];
}

#pragma mark tableviewdelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate=self;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak __typeof(self) weakSelf= self;
    __weak __typeof(tableView) weakTable= tableView;
    __weak __typeof(window) weakWindow= window;

    __block MessageModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    //评论
    cell.CommentBtnClickBlock = ^(UIButton *commentBtn,NSIndexPath * indexPath){
        //不是点击cell进行回复，则置空replayTheSeletedCellModel，因为这个时候是点击评论按钮进行评论，不是回复某某某
        self.replayTheSeletedCellModel = nil;
        weakSelf.seletedCellHeight = 0.0;
        weakSelf.needUpdateOffset = YES;
        weakSelf.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"评论 %@",model.userName];
        weakSelf.history_Y_offset = [commentBtn convertRect:commentBtn.bounds toView:weakWindow].origin.y;
        weakSelf.commentCellIndexPath=nil;
        weakSelf.currentIndexPath = indexPath;
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
    //查看全文
    cell.MoreBtnClickBlock = ^(UIButton *moreBtn,NSIndexPath * indexPath){
        [weakSelf.chatKeyBoard keyboardDownForComment];
        weakSelf.chatKeyBoard.placeHolder = nil;
        model.isExpand = !model.isExpand;
        model.shouldUpdateCache = NO;
        [weakTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    //点击九宫格
    cell.tapImageBlock = ^(NSInteger index,NSArray *dataSource,NSIndexPath *indexpath){
        [weakSelf.chatKeyBoard keyboardDownForComment];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"cell" cacheByIndexPath:indexPath configuration:^(id cell) {
        MessageModel *messageModel = [self.dataSource objectAtIndex:indexPath.row];
        [cell configCellWithModel:messageModel indexPath:indexPath];
    }];
}

#pragma mark 懒加载
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]];
        NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary *eachDic in JSONDic[@"data"][@"rows"]) {
            MessageModel *messageModel = [[MessageModel alloc] initWithDic:eachDic];
            [self.dataSource addObject:messageModel];
        }
    }
    return _dataSource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
