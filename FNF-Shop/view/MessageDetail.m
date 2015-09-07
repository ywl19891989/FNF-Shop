//
//  MessageDetail.m
//  FNF-Shop
//
//  Created by Wenlong on 15-9-7.
//  Copyright (c) 2015年 hali. All rights reserved.
//

#import "MessageDetail.h"

#define TOOLBARTAG		200
#define TABLEVIEWTAG	300

@interface MessageDetail ()
{
    CGRect viewOrigin;
}
@property (weak, nonatomic) IBOutlet UITextField *inputLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *tableView;
@end

@implementation MessageDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)OnClickSend:(id)sender {
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    viewOrigin = self.view.frame;
    
    NSDictionary* detailInfo = [NetWorkManager GetCurMsgInfo];
    
    [self.titleLabel setText:detailInfo[@"MerchantName"]];
}

- (IBAction)OnClickBack:(id)sender
{
    [AppDelegate jumpToMsgList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
