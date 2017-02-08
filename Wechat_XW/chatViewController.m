//
//  chatViewController.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/16.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "chatViewController.h"
#import "ContactsTableViewCell.h"
#import "UIImage+RandomImage.h"
#import "ChatroomViewController.h"

@interface chatViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, copy) NSArray* dataArr;

@end

@implementation chatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initializeData];
    [self buildTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initializeData
{
    self.dataArr = @[
                     @[ @"吴正祥", @"*Github: https://github.com/Seanwong933" ],
                     @[ @"陈维", @"*博客地址: http://siegrain.wang" ],
                     @[ @"赖杰", @"*本应用集成了图灵机器人的自动聊天功能" ],
                     @[ @"范熙丹", @"*麻麻再也不怕进来之后没有事干了..." ],
                     @[
                         @"丁亮",
                         @"*PS: 聊天内容使用CoreData进行缓存"
                         ],
                     @[ @"赵雨彤",
                        @"您已添加了Darui Li，现在可以开始聊天了。" ],
                     @[ @"落落",
                        @"刚翻到了之前给肉团儿拍的小时候皂片！！！" ],
                     @[ @"Leo琦仔", @"Leo琦仔 领取了您的红包" ],
                     @[ @"廖宇超", @"[动画表情]" ],
                     @[ @"Darui Li",
                        @"关于刘亦菲美貌的8歌秘密，你知道几个？" ],
                     @[ @"刘洋", @"逼乎日报" ]
                     ];
}
- (void)buildTableView
{
    // tableviewstyle为groupped的话，会有莫名其妙的contentInsets出现
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,
                                               self.view.frame.size.height-64-49)
                      style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:self.tableView];
}
#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"chatCellIdentifier";
    ContactsTableViewCell* cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell =
        [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identifier];
        
        cell.preservesSuperviewLayoutMargins = false;
        cell.separatorInset = UIEdgeInsetsMake(5, 0, 0, 0);
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.avatarCornerRadius = 3;
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView
  willDisplayCell:(ContactsTableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath
{
    cell.style = ContactsTableViewCellStyleSubtitle;
    cell.avatar = [UIImage randomImageInPath:@"Images/cell_icons"];;
    cell.name = self.dataArr[indexPath.row][0];
    cell.descriptionText = self.dataArr[indexPath.row][1];
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatroomViewController *chatRoom=[[ChatroomViewController alloc]init];
    chatRoom.barTitle=self.dataArr[indexPath.row][0];
    chatRoom.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:chatRoom animated:YES];
}


@end
