//
//  MainView.m
//  CarRoad
//
//  Created by Wenlong on 15-3-3.
//  Copyright (c) 2015年 hali. All rights reserved.
//

#import "MainView.h"
#import "UzysAssetsPickerController.h"
#import "cell/OrderListCell.h"

@interface MainView ()

@end

@implementation MainView

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
    
    [self.mTableView.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.mTableView.layer setBorderWidth:0];
    [self.mTableView setSeparatorColor:[UIColor clearColor]];
    [self.mTableView.layer setBackgroundColor:[UIColor clearColor].CGColor];
    
    [self OnTabChange:self.tabSelector];
}

- (IBAction)OnClickBack:(id)sender {
    [AppDelegate jumpToUserView];
}

- (IBAction)OnClickSetting:(id)sender {
}

- (IBAction)OnTabChange:(id)sender
{
    UISegmentedControl* control = sender;
    
    int state = (int)([control selectedSegmentIndex] + 1);
    
    int arr[4] = { 1, 5, 6, 2 };
    state = arr[state - 1];
    
    [NetWorkManager GetOrderListByState:state WithSuccess:^(AFHTTPRequestOperation *operation, id data) {
        NSArray* list = data[@"NewList"];
        [NetWorkManager SetNewOrderList:list];
        [self.mTableView initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView, NSInteger section) {
            return [list count];
        } setCellForIndexPathBlock:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderListCell" owner:self options:nil] objectAtIndex:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                NSDictionary* info = [list objectAtIndex:(NSUInteger)indexPath.row];
                
                [cell setInfo:info];
            }
            
            return cell;
        } setDidSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
            NSDictionary* info = [list objectAtIndex:(NSUInteger)indexPath.row];
            NSMutableDictionary* newInfo = [NSMutableDictionary dictionaryWithDictionary:info];
            [newInfo setObject:[NSNumber numberWithInt:state] forKey:@"OrderState"];
            [NetWorkManager SetCurOrderInfo:newInfo];
            [AppDelegate jumpToOrderDetail];
        }];
        [self.mTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (IBAction)OnChangeOrderType:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
