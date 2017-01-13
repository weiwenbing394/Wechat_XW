//
//  ContactViewController.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/12.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ContactViewController.h"
#import "AddressBookCell.h"
#import "FriendModel.h"
#import "SearchResultViewController.h"
#import "TestViewController.h"

@interface ContactViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SearchResultSelectedDelegate>{
    //搜索controller
    UISearchController *searchController;
    //搜索结果Controller
    SearchResultViewController *resultController;
    //通讯录列表
    UITableView *friendTableView;
    //所有的通讯录朋友集合
    NSMutableArray *dataSource;
    //符合搜索条件的朋友集合
    NSMutableArray *updateArray;
}

//所有的首字母集合
@property(nonatomic,strong) NSArray *lettersArray;
//排序分类后的朋友字典
@property(nonatomic,strong) NSMutableDictionary *nameDic;
//转换成汉子拼音的规则
@property(nonatomic,strong) HanyuPinyinOutputFormat *formatter;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    dataSource=[NSMutableArray array];
    updateArray=[NSMutableArray array];
    self.lettersArray=[NSMutableArray array];
    self.nameDic=[NSMutableDictionary dictionary];
    [self initUI];
    [self loadAddressBookData];
    [searchController.view bringSubviewToFront:searchController.searchBar];
}

//页面布局
- (void)initUI{
    self.definesPresentationContext = YES;
    // 将searchBar的cancel按钮改成中文的
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
    //通讯录列表
    friendTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [friendTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressBookCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddressBookCell class])];
    friendTableView.delegate=self;
    friendTableView.dataSource=self;
    friendTableView.tableFooterView=[UIView new];
    //设置右边索引index的字体颜色和背景颜色
    friendTableView.sectionIndexBackgroundColor=[UIColor clearColor];
    friendTableView.sectionIndexColor=[UIColor darkGrayColor];
    [self.view addSubview:friendTableView];
    //搜索结果控制器
    resultController=[[SearchResultViewController alloc]init];
    resultController.delegate=self;
    //搜索控制器
    searchController=[[UISearchController alloc]initWithSearchResultsController:resultController];
    searchController.searchResultsUpdater =resultController;
    searchController.searchBar.placeholder=@"搜索";
    searchController.searchBar.tintColor=kThemeColor;
    searchController.searchBar.delegate=self;
    searchController.hidesNavigationBarDuringPresentation=YES;
    //设置searchBar的边框颜色，四周的颜色
    searchController.searchBar.barTintColor=[UIColor groupTableViewBackgroundColor];
    UIImageView *view=[[[searchController.searchBar.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    view.layer.borderWidth=1;
    //把UISearchBar的右边图标显示出来
    searchController.searchBar.showsBookmarkButton=YES;
    //把UISearchBar的右边图标替换为VoiceSearchStartBtn这个图标
    [searchController.searchBar setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    friendTableView.tableHeaderView=searchController.searchBar;
    //解决iOS 8.4中searchBar看不到的bug
    UISearchBar *bar=searchController.searchBar;
    bar.barStyle=UIBarStyleDefault;
    bar.translucent=YES;
    CGRect rect=bar.frame;
    rect.size.height=44;
    bar.frame=rect;
}

//通讯里数据
- (void)loadAddressBookData{
    NSData *frendsData=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AddressBook" ofType:@"json"]]];
    NSDictionary *JSONDic=[NSJSONSerialization JSONObjectWithData:frendsData options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *eachDic in JSONDic[@"friends"][@"row"]) {
        [dataSource addObject:[[FriendModel alloc] initWithDic:eachDic]];
    }
    //处理通讯录元数据（排序筛选）
    [self handleLettersArray];
    [friendTableView reloadData];
}

#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==friendTableView) {
        return self.lettersArray.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==friendTableView) {
        NSArray *nameArray = [self.nameDic objectForKey:self.lettersArray[section]];
        return nameArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"AddressBookCell";
    AddressBookCell *cell = (AddressBookCell *)[tableView dequeueReusableCellWithIdentifier:identifer];
    if (tableView==friendTableView) {
        if (dataSource.count) {
            FriendModel *frends = [[self.nameDic objectForKey:[self.lettersArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            cell.nameLabel.text = frends.userName;
            [cell.photoIV sd_setImageWithURL:[NSURL URLWithString:frends.photo] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
            cell.photoIV.backgroundColor = [UIColor lightGrayColor];
            cell.photoIV.clipsToBounds = YES;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendModel *friends;
    if (tableView==friendTableView) {
        friends = [[self.nameDic objectForKey:[self.lettersArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        TestViewController *test=[[TestViewController alloc]init];
        test.hidesBottomBarWhenPushed=YES;
        test.userName=friends.userName;
        [self.navigationController pushViewController:test animated:YES];

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==friendTableView) {
        return 20.0;
    }
    return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    for (UIView *aView in friendTableView.subviews) {
        if ([aView isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
        }
        if ([aView isKindOfClass:NSClassFromString(@"UISearchBar")]) {
            [self.view bringSubviewToFront:aView];
        }
    }
    return [self.lettersArray objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView==friendTableView) {
        NSInteger count = 0;
        for(NSString *letter in self.lettersArray){
            if([letter isEqualToString:title]){
                return count;
            }
            count++;
        }
        return 0;
    }
    return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView==friendTableView) {
        return self.lettersArray;
    }
    return nil;
}

#pragma mark SearchResultSelectedDelegate  点击搜索结果的代理方法
-(void)selectPersonWithUserId:(NSString *)userId userName:(NSString *)userName photo:(NSString *)photo phoneNO:(NSString *)phoneNO{
    searchController.searchBar.text = @"";
    TestViewController *test=[[TestViewController alloc]init];
    test.hidesBottomBarWhenPushed=YES;
    test.userName=userName;
    [self.navigationController pushViewController:test animated:YES];
}


#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText) {
        [updateArray removeAllObjects];
        if ([PinyinHelper isIncludeChineseInString:searchText]) {// 如果是中文
            for(int i=0;i<dataSource.count;i++){
                FriendModel *friends = dataSource[i];
                if ([friends.userName rangeOfString:searchText].location!=NSNotFound) {
                    [updateArray addObject:friends];
                }
            }
        }else{//如果是拼音
            for(int i=0;i<dataSource.count;i++){
                FriendModel *friends = dataSource[i];
                NSString *outputPinyin=[[PinyinHelper toHanyuPinyinStringWithNSString:friends.userName withHanyuPinyinOutputFormat:self.formatter withNSString:@""] lowercaseString];
                if ([outputPinyin rangeOfString:[searchText lowercaseString]].location!=NSNotFound){
                    [updateArray addObject:friends];
                }
            }
        }
    }
    [resultController updateAddressBookData:updateArray];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchController.searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
}


//处理通讯录元数据（排序筛选）
- (void)handleLettersArray{
    //遍历所有对象数据，取出所有对象首字母去重，保存去重后的首字母集合
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    for (FriendModel *friends in dataSource) {
        NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:friends.userName withHanyuPinyinOutputFormat:self.formatter withNSString:@""];
        [tempDic setObject:friends forKey:[[outputPinyin substringToIndex:1] uppercaseString]];
    }
    self.lettersArray=tempDic.allKeys;
    //根据去重后的首字母，取出首字母对应的对象的集合
    for (NSString *letter in self.lettersArray) {
        NSMutableArray *tempArry = [[NSMutableArray alloc] init];
        for (FriendModel *friends in dataSource) {
            NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:friends.userName withHanyuPinyinOutputFormat:self.formatter withNSString:@""];
            if ( [letter isEqualToString:[[outputPinyin substringToIndex:1] uppercaseString]]) {
                [tempArry addObject:friends];
            }
        }
        [self.nameDic setObject:tempArry forKey:letter];
    }
    //排序，排序的根据是字母
    NSComparator cmptr=^(id obj1, id obj2){
        if ([obj1 characterAtIndex:0] > [obj2 characterAtIndex:0]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 characterAtIndex:0] < [obj2 characterAtIndex:0]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    //排序后的所有大写字母集合
    self.lettersArray=[[NSMutableArray alloc]initWithArray:[self.lettersArray sortedArrayUsingComparator:cmptr]];
}



#pragma mark 懒加载
- (HanyuPinyinOutputFormat *)formatter{
    if (!_formatter) {
        _formatter=[[HanyuPinyinOutputFormat alloc]init];
        _formatter.caseType=CaseTypeLowercase;
        _formatter.vCharType=VCharTypeWithV;
        _formatter.toneType=ToneTypeWithoutTone;
    }
    return _formatter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
