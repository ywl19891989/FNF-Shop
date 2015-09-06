//
//  WebView.m
//  FNF-Shop
//
//  Created by Wenlong on 15-9-6.
//  Copyright (c) 2015年 hali. All rights reserved.
//

#import "WebView.h"

@interface WebView ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        CGRect rect = self.view.bounds;
        rect.origin.y = 0;
        [self.view setBounds:rect];
    }
    return self;
}

- (IBAction)OnClickBack:(id)sender {
    [AppDelegate jumpToUserView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString* urlStr = [NSString stringWithFormat:@"http://www.fnf.net.au/StoreProductDetail2.aspx?MerchantID=%@", [NetWorkManager GetUserId]];
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:req];
    
    NSLog(@"load web %@", urlStr);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
