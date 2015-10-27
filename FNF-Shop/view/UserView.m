//
//  UserView.m
//  FNF-Shop
//
//  Created by Wenlong on 15-8-30.
//  Copyright (c) 2015年 hali. All rights reserved.
//

#import "UserView.h"
#import "APService.h"

@interface UserView ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@end

@implementation UserView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addBottomBarWithTag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString* alias = [NetWorkManager GetUserName];
    [APService setTags:[NSSet setWithArray:@[@"123"]] alias:alias callbackSelector:@selector(tagsAliasCallback: tags:alias:) object:self];
    
    [self.btn3 setHidden:YES];
    [self.btn4 setHidden:YES];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"set alias（%@）tags %@ %@!", alias, tags, iResCode == 0 ? @"Success" : @"Failed");
}

- (IBAction)OnClickBack:(id)sender
{
    
}

- (IBAction)OnClickSetting:(id)sender
{
    UIAlertView* confirm = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [confirm show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [NetWorkManager SetUserInfo:@{}];
        [AppDelegate jumpToLogin];
    }
}

- (IBAction)OnClickBtn1:(id)sender
{
    [AppDelegate jumpToMain];
}

- (IBAction)OnClickBtn2:(id)sender
{
    [AppDelegate jumpToTransaction];
}

- (IBAction)OnClickBtn3:(id)sender
{
//    [AppDelegate jumpToWeb2];
    [AppDelegate ShowTips:@"Coming soon!"];
}

- (IBAction)OnClickBtn4:(id)sender
{
//    [AppDelegate jumpToWeb1];
    [AppDelegate ShowTips:@"Coming soon!"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
