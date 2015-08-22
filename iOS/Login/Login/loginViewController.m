//
//  loginViewController.m
//  Login
//
//  Created by menuz on 14-2-23.
//  Copyright (c) 2014年 menuz's lab. All rights reserved.
//

#import "loginViewController.h"
#import "MBProgressHUD.h"
#import "fmdb/FMDB.h"
#define DATABASE @"database"
#define USERNAME @"username"
#define PWD @"pwd"



@interface loginViewController()<MBProgressHUDDelegate,UIGestureRecognizerDelegate>
{
    bool hasLogin;
}
@end

@implementation loginViewController
{
    MBProgressHUD *HUD;
    UIAlertView *LoadingMess;
    FMDatabase  *db;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
    HUD.delegate = self;
	HUD.labelText = @"正在登录";
    
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    //Massagebox show when error loading.
    LoadingMess=[[UIAlertView alloc] initWithTitle:@"失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    LoadingMess.delegate=self;
    
    //Get current path and then create data file named "database".
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ;
    NSString* path=[[paths objectAtIndex:0]stringByAppendingPathComponent:@"database"] ;
    self->db=[FMDatabase databaseWithPath:path];
    if(![self->db open])NSLog(@"Error:Open database file!");
    else
    {
        NSString *createSql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'( '%@' TEXT KEY,'%@' TEXT)",DATABASE,USERNAME,PWD];
        BOOL res=[self->db executeUpdate:createSql];
        if(!res)NSLog(@"createtableerror!");
        else
        {
            NSString *inserSql=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@') VALUES ('%@','%@')",DATABASE,USERNAME,PWD,@"tony",@"tony"];
            [self->db executeUpdate:inserSql];
        }
        
    }
    self->hasLogin=FALSE;
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.passwordTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Login:(id)sender {
    // MBProgressHUD后台新建子线程执行任务
    [HUD showWhileExecuting:@selector(loginWithUsername) onTarget:self withObject:nil animated:TRUE];
}


// Verifying.
-(void)loginWithUsername
{
    BOOL findUser=false;
    if([self->db open])
    {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM '%@'",DATABASE];
        FMResultSet * rs=[self->db executeQuery:sql];
        while ([rs next] && !findUser)
        {
            NSString *username=[rs stringForColumn:USERNAME];
            NSString *password=[rs stringForColumn:PWD];
            if ([username isEqualToString:self.usernameTF.text] )
            {
                findUser=true;
                if ([password isEqualToString:self.passwordTF.text])
                {
                    self->hasLogin=true;
                    [self  performSelectorOnMainThread:@selector(goToMainView) withObject:nil waitUntilDone:FALSE];
                }
                else
                {
                    [LoadingMess show];
                }
            }
        }
        if (!self->hasLogin)[LoadingMess show];
        [self->db close];
    }
}

//Login in successfully.
-(void) goToMainView {
    [self performSegueWithIdentifier:@"GoToMainViewSegue" sender:self];
}

@end