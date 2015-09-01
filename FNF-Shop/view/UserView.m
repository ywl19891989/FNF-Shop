//
//  UserView.m
//  FNF-Shop
//
//  Created by Wenlong on 15-8-30.
//  Copyright (c) 2015年 hali. All rights reserved.
//

#import "UserView.h"

@interface UserView ()

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
}

- (IBAction)OnClickBack:(id)sender
{
    
}

- (IBAction)OnClickSetting:(id)sender
{
    
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
    
}

- (IBAction)OnClickBtn4:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
