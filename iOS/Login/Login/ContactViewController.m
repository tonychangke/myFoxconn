//
//  NTViewController.m
//  TableView
//
//  Created by MD101 on 14-10-9.
//  Copyright (c) 2014年 NT. All rights reserved.
//

#import "ContactViewController.h"
#import "NTContact.h"
#import "NTContactGroup.h"
#import "CustomIOSAlertView.h"
#import "comWithDB.h"
#import "loginAppDelegate.h"
#import "TBController.h"

#define kContactToolbarHeight 64

@interface ContactViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,CustomIOSAlertViewDelegate>
{

    UITableView * _tableView;
    NSMutableArray * _contacts;//联系人模型
    NSIndexPath * _selectedIndexPath;//当前选中的组和行

    UIToolbar * _toolbar;
    BOOL _isInsert;//记录是点击了插入还是删除按钮
}

@end

@implementation ContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.hidden = YES;
    //初始化数据
    [self initContactData];
    
    //创建一个分组样式的tablev
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.contentInset=UIEdgeInsetsMake(kContactToolbarHeight-20, 0, 0, 0);
    //注意必须实现对应的UITableViewDataSource协议(设置数据源)
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    [self addToolbar];
}

#pragma mark 添加工具栏
-(void)addToolbar{
    CGRect frame=self.view.frame;
    _toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kContactToolbarHeight)];
    //    _toolbar.backgroundColor=[UIColor colorWithHue:246/255.0 saturation:246/255.0 brightness:246/255.0 alpha:1];
    [self.view addSubview:_toolbar];
    //UIBarButtonItem *removeButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(remove)];
    UIBarButtonItem *flexibleButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *addButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    NSArray *buttonArray=[NSArray arrayWithObjects:flexibleButton,addButton, nil];
    _toolbar.items=buttonArray;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showFriendPosition"])
    {
        [segue.destinationViewController setSelectedIndex:0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [UIView commitAnimations];
    }
}

#pragma mark 删除
- (void)remove{
    _isInsert = false;
    [_tableView setEditing:!_tableView.isEditing animated:true];
}

-(void)add{
    [self performSegueWithIdentifier:@"addFriend" sender:self];
    
}

#pragma mark 初始化数据
- (void)initContactData{
//    comWithDB *communicator=[[comWithDB alloc] init];
//    loginAppDelegate *delegate=(loginAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSString *temString=[communicator getFriendList:delegate.userid];
    _contacts=[NSMutableArray array];
    NSString *infoString = @"Changke,Tony;Dcag,Be;Boy,djfkkf;Big,konw;Change,nfdn";
    NSMutableArray *infoArray=[[infoString componentsSeparatedByString:@";"]mutableCopy];
    infoArray=[[infoArray sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    
    NSArray *friArray=[NSArray array];
    NTContact *temContact=[[NTContact alloc]init];
    NTContactGroup *lastGroup=[[NTContactGroup alloc]init];
    NSMutableArray *currentGroup=[NSMutableArray array];
    unichar currentName,lastName;
    NSInteger length=0;
    
    for(NSString *friInfo in infoArray){
        length++;
        friArray = [friInfo componentsSeparatedByString:@","];
        temContact=[NTContact initWithName:friArray[0] andUserid:friArray[1]];
        currentName=[temContact.Name characterAtIndex:0];
        if (length == 1 ) {
            lastName=currentName;
            [currentGroup addObject:temContact];
        }
        else{
            if (currentName != lastName){
                lastGroup=[NTContactGroup initWithName:[NSString stringWithFormat:@"%c",lastName] andDetail:@" " andContacts:currentGroup];
                [_contacts addObject:lastGroup];
                currentGroup=[NSMutableArray array];
                [currentGroup addObject:temContact];
                lastName=currentName;
            }
            else [currentGroup addObject:temContact];
        }
    }
    lastGroup=[NTContactGroup initWithName:[NSString stringWithFormat:@"%c",currentName] andDetail:@" " andContacts:currentGroup];
    [_contacts addObject:lastGroup];
}

#pragma mark - 实现delegate(数据源方法)

#pragma mark 分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _contacts.count;
}

#pragma mark 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NTContactGroup * group = _contacts[section];
    return group.contacts.count;

}
#pragma mark 每个单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //由于此方法调用十分频繁，cell的标示声明成静态变量有利于性能优化
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
//    static NSString *cellIdentifierForFirstRow=@"UITableViewCellIdentifierKeyWithSwitch";
    
    UITableViewCell * cell;
    
//    if (indexPath.row == 0) {
//        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForFirstRow];
//    }else{
    
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    }
    
    if (!cell) {
//        if (indexPath.row == 0) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifierForFirstRow];
//            UISwitch * sw = [[UISwitch alloc]init];
//            [sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
//            cell.accessoryView = sw;
//        }else{
        
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
//        }
    }
//    if (indexPath.row == 0) {
//        cell.accessoryView.tag = indexPath.section;
//    }
    NTContactGroup * group = _contacts[indexPath.section];
    NTContact * contact = group.contacts[indexPath.row];
    cell.textLabel.text = [contact getName];
    cell.detailTextLabel.text = contact.userid;
    return cell;

}

#pragma mark 分组的标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NTContactGroup * group = _contacts[section];
    return group.groupName;
}


#pragma mark 编辑操作（删除或添加）
//实现了此方法向左滑动就会显示删除（或添加）图标
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NTContactGroup * group = _contacts[indexPath.section];
    NTContact * contact = group.contacts[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [group.contacts removeObject:contact];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        if (group.contacts.count == 0) {
            [_contacts removeObject:group];
            [tableView reloadData];
        }
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        
        NTContact * addContact = [[NTContact alloc]init];
//        addContact.firstName = @"Guan";
//        addContact.lastName = @"yu";
//        addContact.mobileNumber = @"12345678901";
        [group.contacts insertObject:addContact atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

#pragma mark 排序
//只要实现这个方法在编辑状态右侧就有排序图标
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NTContactGroup * sourceGroup = _contacts[sourceIndexPath.section];
    NTContact * sourceContact = sourceGroup.contacts[sourceIndexPath.row];
    NTContactGroup * destinationGroup = _contacts[destinationIndexPath.section];
    [sourceGroup.contacts removeObject:sourceContact];
    
    if(sourceGroup.contacts.count == 0){
        [_contacts removeObject:sourceGroup];
        [tableView reloadData];
    }
    [destinationGroup.contacts insertObject:sourceContact atIndex:destinationIndexPath.row];
    
}

#pragma mark 取得当前操作状态，根据不同的状态左侧出现不同的操作按钮
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isInsert) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
    
}



#pragma mark 尾部详情
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{

    return @"";
    //NTContactGroup * group = _contacts[section];
    //return group.groupDetail;
}

#pragma mark 索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    NSMutableArray * indexs = [NSMutableArray array];
    for (NTContactGroup * group in _contacts) {
        [indexs addObject:group.groupName];
    }
    
    return indexs;
}

#pragma mark - 代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 50;
    }
    return 40;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

#pragma mark 设置尾部说明内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    NTContactGroup * group = _contacts[indexPath.section];
    NTContact *contact = group.contacts[indexPath.row];
//    CustomIOSAlertView *alertview = [[CustomIOSAlertView alloc]init];
   UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否在地图中显示%@的位置?",contact.Name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认" , nil];
  
//    UITextField *firstName=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
//    //firstName.placeholder=contact.firstName;
//
//    UITextField *lastName=[[UITextField alloc]initWithFrame:CGRectMake(0, 45, 290, 40)];
//    //lastName.placeholder=contact.lastName;
//    
//    UITextField *mobileNum=[[UITextField alloc]initWithFrame:CGRectMake(0, 90, 290, 40)];
//    mobileNum.placeholder=contact.userid;
//
    
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 40)];
//    label.text=[NSString stringWithFormat:@"是否在地图中显示%@的位置?",contact.Name];
//    
//    UIView *containerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
//    [containerView addSubview:label];
//
//    [alertview setContainerView:containerView];
//    [alertview setButtonTitles:[NSMutableArray arrayWithObjects:@"确认",@"取消", nil]];
//    [alertview setDelegate:self];
//    [alertview setUseMotionEffects:true];
    [alertView show];

//
//    [alertview setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
//        if (buttonIndex ==0)
//        {
//                        [tableView reloadData];
//        }
//        [alertView close];
//    }];
    
}


#pragma mark alertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"showFriendPosition" sender:self];
//        //修改数据模型
//        NTContactGroup * group = _contacts[_selectedIndexPath.section];
//        NTContact * contanct = group.contacts[_selectedIndexPath.row];
//        //刷新列表
//        [_tableView reloadData];//修改某一数据而刷新整个列表 不可取
//        NSArray * indexPaths = @[_selectedIndexPath];//需要局部刷新的组、行
//        [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];////后面的参数代表更新时的动画
    }

}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;

}

#pragma mark 切换开关转化事件
-(void)switchValueChange:(UISwitch *)sw{
    NSLog(@"section:%ld,switch:%i",sw.tag, sw.on);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
