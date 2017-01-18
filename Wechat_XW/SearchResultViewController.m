//
//  SearchResultViewController.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/12.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SearchResultViewController.h"
#import "AddressBookCell.h"
#import "FriendModel.h"

@interface SearchResultViewController (){
    UITableView *table;
    NSMutableArray *dataSource;
    UILabel *footerLabel;
}

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [[NSMutableArray alloc]init];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    table.showsVerticalScrollIndicator = NO;
    table.bouncesZoom = NO;
    table.delegate = self;
    table.dataSource = self;
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [table registerNib:[UINib nibWithNibName:NSStringFromClass([AddressBookCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddressBookCell class])];
    [self.view addSubview:table];
    //tableFooterView
    footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 40)];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.textColor = [UIColor lightGrayColor];
    if (dataSource.count==0) {
        footerLabel.text = @"无结果";
        table.tableFooterView = footerLabel;
    }else{
        footerLabel.text = @"";
    }
}

#pragma mark tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressBookCell *cell=(AddressBookCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressBookCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(dataSource.count>0){
        FriendModel *friends = [dataSource objectAtIndex:indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",friends.userName];
        [cell.photoIV sd_setImageWithURL:[NSURL URLWithString:friends.photo] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
        cell.photoIV.backgroundColor = [UIColor lightGrayColor];
        cell.photoIV.clipsToBounds = YES;
    }else{
        if (dataSource.count==0) {
            footerLabel.text = @"无结果";
            table.tableFooterView = footerLabel;
        }else{
            footerLabel.text = @"";
        }
    }
    return cell;
}



//添加数据
-(void)updateAddressBookData:(NSArray *)AddressBookDataArray{
    [dataSource removeAllObjects];
    [dataSource addObjectsFromArray:AddressBookDataArray];
    [table reloadData];
    if (dataSource.count==0) {
        footerLabel.text = @"无结果";
        table.tableFooterView = footerLabel;
    }else{
        footerLabel.text = @"";
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendModel *friends = [dataSource objectAtIndex:indexPath.row];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectPersonWithUserId:userName:photo:phoneNO:)]) {
        [self.delegate selectPersonWithUserId:friends.userId userName:friends.userName photo:friends.photo phoneNO:friends.phoneNO];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"搜索条件为：%@",searchController.searchBar.text);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
