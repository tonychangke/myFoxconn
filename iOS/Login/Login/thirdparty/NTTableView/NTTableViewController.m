//
//  NTTableViewController.m
//  TableView
//
//  Created by MD101 on 14-10-10.
//  Copyright (c) 2014年 NT. All rights reserved.
//

#import "NTTableViewController.h"
#import "NTContact.h"
#import "NTContactGroup.h"
#define kSearchbarHeight 44

@interface NTTableViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>{
    
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    NSMutableArray *_contacts;//联系人模型
    NSMutableArray *_searchContacts;//符合条件的搜索联系人
//    BOOL _isSearching;

}

@end

@implementation NTTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化数据
    [self initContactData];
    
    //添加搜索框
    [self addSearchBar];
}

#pragma mark 初始化数据
- (void)initContactData{
    
//    _contacts = [NSMutableArray array];
//    
//    NTContact * contact1 = [NTContact initWithFirstName:@"Cao" andLastName:@"aman" andMobileNumber:@"13222226666"];
//    NTContact * contact2 = [NTContact initWithFirstName:@"Cao" andLastName:@"zijian" andMobileNumber:@"13233336666"];
//    NTContactGroup * group1 = [NTContactGroup initWithName:@"C" andDetail:@"With names beginning with C" andContacts:[NSMutableArray arrayWithObjects:contact1,contact2, nil]];
//    [_contacts addObject:group1];
//    
//    NTContact * contact3 = [NTContact initWithFirstName:@"Liu" andLastName:@"xuande" andMobileNumber:@"13712346666"];
//    NTContact * contact4 = [NTContact initWithFirstName:@"Liu" andLastName:@"adou" andMobileNumber:@"13812347777"];
//    NTContact * contact10 = [NTContact initWithFirstName:@"Liu" andLastName:@"adou" andMobileNumber:@"13812347777"];
//    NTContactGroup * group2 = [NTContactGroup initWithName:@"L" andDetail:@"With names beginning with L" andContacts:[NSMutableArray arrayWithObjects:contact3,contact4,contact10, nil]];
//    [_contacts addObject:group2];
//    
//    NTContact * contact5 = [NTContact initWithFirstName:@"Sun" andLastName:@"jian" andMobileNumber:@"13222221234"];
//    NTContact * contact6 = [NTContact initWithFirstName:@"Sun" andLastName:@"quan" andMobileNumber:@"13233335678"];
//    NTContactGroup * group3 = [NTContactGroup initWithName:@"S" andDetail:@"With names beginning with S" andContacts:[NSMutableArray arrayWithObjects:contact5,contact6, nil]];
//    [_contacts addObject:group3];
//    
//    NTContact * contact7 = [NTContact initWithFirstName:@"Yuan" andLastName:@"shao" andMobileNumber:@"13566661234"];
//    NTContact * contact8 = [NTContact initWithFirstName:@"Yuan" andLastName:@"shu" andMobileNumber:@"13533336666"];
//    NTContact * contact9 = [NTContact initWithFirstName:@"Yuan" andLastName:@"shu" andMobileNumber:@"13533336666"];
//    NTContactGroup * group4 = [NTContactGroup initWithName:@"Y" andDetail:@"With names beginning with Y" andContacts:[NSMutableArray arrayWithObjects:contact7,contact8,contact9, nil]];
//    [_contacts addObject:group4];
    
}

//#pragma mark 添加搜索栏
//-(void)addSearchBar{
//    CGRect searchBarRect = CGRectMake(0, 0, self.view.frame.size.width, kSearchbarHeight);
//    _searchBar = [[UISearchBar alloc]initWithFrame:searchBarRect];
//    _searchBar.placeholder = @"Please input key word...";
//    //_searchBar.keyboardType=UIKeyboardTypeAlphabet;//键盘类型
//    //_searchBar.autocorrectionType=UITextAutocorrectionTypeNo;//自动纠错类型
//    //_searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;//哪一次shitf被自动按下
//    _searchBar.showsCancelButton = YES;//显示取消按钮
//    //添加搜索框到页眉位置
//    _searchBar.delegate = self;
//    self.tableView.tableHeaderView = _searchBar;
//}

#pragma mark 添加搜索栏
-(void)addSearchBar{
    _searchBar=[[UISearchBar alloc]init];
    [_searchBar sizeToFit];//大小自适应容器
    _searchBar.placeholder=@"Please input key word...";
    _searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _searchBar.showsCancelButton=YES;//显示取消按钮
    //添加搜索框到页眉位置
    _searchBar.delegate=self;
    self.tableView.tableHeaderView=_searchBar;
    _searchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate=self;
    _searchDisplayController.searchResultsDataSource=self;
    _searchDisplayController.searchResultsDelegate=self;
    [_searchDisplayController setActive:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
//    if (_isSearching) {
//        return 1;
//    }
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return _contacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    if (_isSearching) {
//        return _searchContacts.count;
//    }
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return _searchContacts.count;
    }
    NTContactGroup * group = _contacts[section];
    return group.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTContact * contact = nil;
//    if (_isSearching) {
//        
//        contact = _searchContacts[indexPath.row];
//        
//    }else{
//        NTContactGroup * group = _contacts[indexPath.section];
//        contact = group.contacts[indexPath.row];
//    }
    
    if (tableView == _searchDisplayController.searchResultsTableView) {
        contact = _searchContacts[indexPath.row];
    }else{
    
        NTContactGroup * group = _contacts[indexPath.section];
        contact = group.contacts[indexPath.row];
    }
    
    static NSString * identifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [contact getName];
//    cell.detailTextLabel.text = contact.mobileNumber;
    // Configure the cell...
    
    return cell;
}

#pragma mark - 代理方法
#pragma mark 设置分组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _searchDisplayController.searchResultsTableView) {
        return @"搜索结果";
    }
    
    NTContactGroup * group = _contacts[section];
    return group.groupName;
}
#pragma mark 选中之前
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar resignFirstResponder];//退出键盘
    return indexPath;
}

//#pragma mark - 搜索框代理
//#pragma mark  取消搜索
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    _isSearching=NO;
//    _searchBar.text=@"";
//    [self.tableView reloadData];
//    [_searchBar resignFirstResponder];
//}
//#pragma mark 输入搜索关键字
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    if([_searchBar.text isEqual:@""]){
//        _isSearching=NO;
//        [self.tableView reloadData];
//        return;
//    }
//    [self searchDataWithKeyWord:_searchBar.text];
//}
//#pragma mark 点击虚拟键盘上的搜索时
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    
//    [self searchDataWithKeyWord:_searchBar.text];
//    
//    [_searchBar resignFirstResponder];//放弃第一响应者对象，关闭虚拟键盘
//}

#pragma mark - UISearchDisplayController代理方法
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self searchDataWithKeyWord:searchString];
    return YES;
}
#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord{
//    _isSearching=YES;
    _searchContacts=[NSMutableArray array];
    [_contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NTContactGroup * group = obj;
        [group.contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NTContact * contact = obj;
           
//            if ([contact.firstName.uppercaseString rangeOfString:keyWord.uppercaseString].location != NSNotFound ||[contact.lastName.uppercaseString rangeOfString:keyWord.uppercaseString].location != NSNotFound ||[contact.mobileNumber rangeOfString:keyWord].location != NSNotFound) {
//                [_searchContacts addObject:contact];
//            }
//        }];
//    }];
//    
//    //刷新表格
////    [self.tableView reloadData];
//}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
