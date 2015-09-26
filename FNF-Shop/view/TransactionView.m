//
//  TransactionView.m
//  FNF-Shop
//
//  Created by Wenlong on 15-8-31.
//  Copyright (c) 2015年 hali. All rights reserved.
//

#import "TransactionView.h"
#import "CKCalendarView.h"
#import "TransacationCell.h"

#define STR(val) [NSString stringWithFormat:@"%.2f", [val floatValue]]

@interface TransactionView () <CKCalendarDelegate>
{
    int m_iSelectCout;
    CKCalendarView* canlendarView;
    NSDate * m_pStartDate;
    NSDate * m_pEndDate;
}

@property (weak, nonatomic) IBOutlet UILabel *titleOrder;
@property (weak, nonatomic) IBOutlet TableViewWithBlock *m_pTableView;
@property (weak, nonatomic) IBOutlet UILabel *selectDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDiscount;
@property (weak, nonatomic) IBOutlet UILabel *totalSurchage;
@property (weak, nonatomic) IBOutlet UILabel *totalFreightee;
@property (weak, nonatomic) IBOutlet UILabel *totalCommission;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;

@end

@implementation TransactionView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addBottomBarWithTag:0];
    }
    return self;
}

- (NSString*) stringFromDate:(NSDate*) date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    canlendarView = [[CKCalendarView alloc] initWithStartDay: startMonday];
    canlendarView.frame = CGRectMake(10, 10, 300, 470);
    [canlendarView setSelectedDate:nil];
    [self.view addSubview:canlendarView];
    
    canlendarView.delegate = self;
    [canlendarView setHidden:YES];
    
    m_iSelectCout = 1;
    m_pStartDate = [NSDate date];
    [self calendar:nil didSelectDate:[NSDate date]];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    m_iSelectCout = m_iSelectCout + 1;
    if (m_iSelectCout == 1) {
        m_pStartDate = date;
    }
    if (m_iSelectCout == 2) {
        m_pEndDate = date;
        [canlendarView setHidden:YES];
        
        NSString* startDateStr = [self stringFromDate:m_pStartDate];
        NSString* endDateStr = [self stringFromDate:m_pEndDate];
        
        [self.selectDateLabel setText:[NSString stringWithFormat:@"%@ - %@", startDateStr, endDateStr]];
        
        [self.titleOrder setText:@"Date"];
        if ([startDateStr isEqualToString:endDateStr]) {
            [self.titleOrder setText:@"OrderNo"];
        }
        
        [NetWorkManager GetSellListStartDate:startDateStr EndDate:endDateStr WithSuccessWithSuccess:^(AFHTTPRequestOperation *operation, id data) {
            
            NSArray* dataList = data[@"OrderSellerList"];
            
            [self.totalNumLabel setText:STR(data[@"TotalIncome"])];
            [self.totalDiscount setText:STR(data[@"TotalDiscount"])];
            [self.totalSurchage setText:STR(data[@"TotalSurcharge"])];
            [self.totalFreightee setText:STR(data[@"TotalFreightFee"])];
            [self.totalCommission setText:STR(data[@"TotalCommission"])];
            [self.totalAmount setText:STR(data[@"TotalAmount"])];
            
            [self.m_pTableView initTableViewDataSourceAndDelegate:^NSInteger(UITableView *tableView, NSInteger section) {
                return (NSUInteger)[dataList count];
            } setCellForIndexPathBlock:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
                
                TransacationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransacationCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"TransacationCell" owner:self options:nil] objectAtIndex:0];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                
                
                NSDictionary* info = [dataList objectAtIndex:(NSUInteger)indexPath.row];
                
                [cell.orderIdLabel setText:info[@"OrderCode"]];
                [cell.amountLabel setText:info[@"Amount"]];
                [cell.carriageLabel setText:info[@"Carriage"]];

                
                return cell;
                
            } setDidSelectRowBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
                
            }];
            
            [self.m_pTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (IBAction)OnClickBack:(id)sender
{
    [AppDelegate jumpToUserView];
}

- (IBAction)OnClickSetting:(id)sender
{
    
}

- (IBAction)OnClickSelectDate:(id)sender
{
    m_iSelectCout = 0;
    m_pStartDate = nil;
    m_pEndDate = nil;
    [canlendarView setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
