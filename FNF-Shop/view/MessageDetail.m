//
//  MessageDetail.m
//  FNF-Shop
//
//  Created by Wenlong on 15-9-7.
//  Copyright (c) 2015年 hali. All rights reserved.
//

#import "MessageDetail.h"
#import "YcKeyBoardView.h"

#define kWinSize [UIScreen mainScreen].bounds.size
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300

@interface MessageDetail () <YcKeyBoardViewDelegate>
{
    CGRect viewOrigin;
}

@property (nonatomic,strong)YcKeyBoardView *key;
@property (weak, nonatomic) IBOutlet UITextField *inputLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextVIew;
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
- (IBAction)OnClickInput:(id)sender {
}

-(void)addBtn:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    if(self.key==nil){
        self.key = [[YcKeyBoardView alloc] initWithFrame:CGRectMake(0, kWinSize.height-44, kWinSize.width, 44)];
    }
    self.key.delegate = self;
    [self.key.textView becomeFirstResponder];
    self.key.textView.returnKeyType=UIReturnKeySend;
    [self.view addSubview:self.key];
}
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.key.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.key.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        self.key.textView.text=@"";
        [self.key removeFromSuperview];
    }];
    
}
-(void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    [contentView resignFirstResponder];
    //接口请求
    [self.inputText setText:[contentView text]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
