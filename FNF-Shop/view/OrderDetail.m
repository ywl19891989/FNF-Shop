//
//  OrderDetail.m
//  FNF-Drives
//
//  Created by Wenlong on 15-8-16.
//  Copyright (c) 2015年 hali. All rights reserved.
//

#import "OrderDetail.h"
#import "SerialGATT.h"
#import "DXPopover.h"
#import "FoodListCell.h"

#define ALIGN_LEFT 0
#define ALIGN_RIGHT 2
#define ALIGN_CENTER 1

@interface OrderDetail () <UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary* m_pCurOrderInfo;
    NSDictionary* m_pCurOrderDetailInfo;
    int m_iCurOrderState;
    int m_iCurOrderID;
    UITextField* m_pInputCache;
    UITableView* m_pTableView;
    DXPopover* m_pPop;
}
@property (weak, nonatomic) IBOutlet UIView *estamiteView;
@property (weak, nonatomic) IBOutlet UIButton *itemListBtn;
@property (weak, nonatomic) IBOutlet UIButton *printBtn;
@end

@implementation OrderDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addBottomBarWithTag:0];
    }
    return self;
}

- (IBAction)OnClickItemList:(id)sender
{
    [m_pTableView reloadData];
    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(self.itemListBtn.frame), CGRectGetMaxY(self.itemListBtn.frame) + 5);
    [m_pPop showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:m_pTableView
                       inView:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_pTableView = [[UITableView alloc] init];
    m_pTableView.frame = CGRectMake(0, 0, 300, 350);
    m_pTableView.dataSource = self;
    m_pTableView.delegate = self;
    [m_pTableView setSeparatorColor:[UIColor clearColor]];
    
    m_pPop = [DXPopover new];

    NSDictionary* curOrderInfo = [NetWorkManager GetCurOrderInfo];
    m_pCurOrderInfo = curOrderInfo;
    m_iCurOrderID = [curOrderInfo[@"ID"] intValue];
    m_iCurOrderState = [curOrderInfo[@"OrderState"] intValue];
    
    switch (m_iCurOrderState) {
        case 1:
            m_iCurOrderState = 1;
            break;
        case 5:
            m_iCurOrderState = 2;
            break;
        case 6:
            m_iCurOrderState = 3;
            break;
        case 2:
            m_iCurOrderState = 4;
            break;
        default:
            break;
    }

    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, 550);
    
    [self.pickerView setHidden:YES];
    [self.onlyBtn setHidden:m_iCurOrderState != 1];
    [self.printBtn setHidden:m_iCurOrderState != 1];
    
    [self.onlyBtn setHidden:m_iCurOrderState != 1 && m_iCurOrderState != 2];
    [self.printBtn setHidden:m_iCurOrderState != 1 && m_iCurOrderState != 2];
    
    [self.estamiteView setHidden:m_iCurOrderState != 4 && m_iCurOrderState != 3];
    
    [NetWorkManager GetOrderDetailByID:[curOrderInfo[@"ID"] intValue] WithSuccess:^(AFHTTPRequestOperation *operation, id data) {
//        msg =     {
//            AddressDetail = "25 Rakaia Way,Docklands,Vic";
//            DeliveryTime = "15:00-17:00";
//            DrvActTime = "";
//            DrvEstTime = "";
//            ID = 160;
//            MerchantMobile = "";
//            MerchantPhone = 0398885003;
//            Mobile = 0469900846;
//            OrderCode = SO20150729134218184;
//            Pay = "Cash on delivery";
//            Remark = "";
//            RestaurantFinishTime = "";
//            TotalAmount = "24.8";
//        };
        m_pCurOrderDetailInfo = data;
        [self.titleLable setText:[NSString stringWithFormat:@"%d", [data[@"ID"] intValue]]];
        [self.addressLable setText:data[@"AddressDetail"]];
        [self.phoneNumLabel setText:data[@"Mobile"]];
        [self.amountLabel setText:[NSString stringWithFormat:@"%d", [data[@"TotalAmount"] intValue]]];
        [self.paymentLabel setText:data[@"Pay"]];
        [self.notesLabel setText:data[@"Remark"]];
        [self.resphoneNumLabel setText:data[@"MerchantPhone"]];
        
        if (m_iCurOrderState == 1 || m_iCurOrderState == 2) {
            [self.deliverView setHidden:YES];
            [self.changeTitle setText:@"Restaurant finish time"];
            [self.cusSetTimeLabel setText:data[@"RestaurantFinishTime"]];
            [self.onlyBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        } else if (m_iCurOrderState == 3) {
            [self.deliverView setHidden:NO];
            [self.changeTitle setText:@"Customer setting time"];
            [self.cusSetTimeLabel setText:data[@"DeliveryTime"]];
            [self.estimateTimeLabel setText:data[@"DrvEstTime"]];
            [self.onlyBtn setTitle:@"Delivered" forState:UIControlStateNormal];
            
            NSDateFormatter* formater = [[NSDateFormatter alloc] init];
            formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            [self.actualTime setText:[formater stringFromDate:[NSDate date]]];
        } else {
            [self.deliverView setHidden:NO];
            [self.changeTitle setText:@"Customer setting time"];
            [self.cusSetTimeLabel setText:data[@"DeliveryTime"]];
            [self.estimateTimeLabel setText:data[@"DrvEstTime"]];
            [self.actualTime setText:data[@"DrvActTime"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnClickBack:(id)sender
{
    [AppDelegate jumpToMain];
}

- (IBAction)OnClickPrint:(id)sender {   
    
    
    NSDictionary* curOrderInfo = [NetWorkManager GetCurOrderInfo];
    
    SerialGATT* gat = [SerialGATT share];
    if (gat.activePeripheral == nil) {
        [AppDelegate jumpToDeviceList];
    } else {
    
        
        [NetWorkManager GetOrderPrintByID:curOrderInfo[@"ID"] WithSuccess:^(AFHTTPRequestOperation *operation, id data) {
            //        msg =     {
            //            ABN = "I LOVE DUMPLINGS";
            //            Address = "VictoriaVicdocklands,25 rakaia way";
            //            CustomerName = "\U5353";
            //            DeliveryFee = 0;
            //            DeliveryTime = "17:00-19:00";
            //            DetailList =         (
            //                                  {
            //                                      BuyQty = 1;
            //                                      Price = 6;
            //                                      ProductName = "\U6bdb\U8c46";
            //                                  }
            //                                  );
            //            Mobile = 18918858308;
            //            Note = "";
            //            OrderCode = SO20150805135819709;
            //            PH = "(03) 9372 5218/(03) 9372 5218";
            //            Payment = CASH;
            //            SubTotal = 6;
            //            Total = "66.00";
            //        };
            
            if (data) {
                [self PrintOrder:data];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

#define fullLine @"------------------------------------------------"

- (void)PrintOrder:(NSDictionary*)orderData
{
    [self Blank:3];
    
    [self Align:ALIGN_CENTER];
    [self BigFont];
    [self Enter];
    [self WriteStr:orderData[@"MerchantName"]];
    [self Enter];
    [self Blank:3];
    
    [self Align:ALIGN_LEFT];
    [self SmallFont];
    [self WriteStr:[NSString stringWithFormat:@"ABN:%@", orderData[@"ABN"]]];
    
    [self Enter];
    [self Align:ALIGN_LEFT];
    [self SmallFont];
    [self WriteStr:[NSString stringWithFormat:@"PH:%@", orderData[@"PH"]]];
    
    [self Enter];
    [self Align:ALIGN_LEFT];
    [self BigFont];
    [self WriteStr:@"TAX INVOICE"];
    [self Enter];
    [self WriteStr:fullLine];
    [self Enter];
    [self WriteStr:[NSString stringWithFormat:@"Order:%@", orderData[@"OrderCode"]]];
    [self Enter];
    [self WriteStr:fullLine];
    [self Enter];
    [self WriteStr:@"Deliver Address:"];
    [self Enter];
    [self SmallFont];
    [self WriteStr:orderData[@"Address"]];
    [self Enter];
    [self BigFont];
    [self WriteStr:@"CustomerName:"];
    [self SmallFont];
    [self WriteStr:orderData[@"CustomerName"]];
    [self Enter];
    [self BigFont];
    [self WriteStr:@"Mobile:"];
    [self SmallFont];
    [self WriteStr:orderData[@"Mobile"]];
    [self Enter];
    [self BigFont];
    [self WriteStr:@"Delivery Time:"];
    [self SmallFont];
    [self WriteStr:orderData[@"DeliveryTime"]];
    [self Enter];
    [self BigFont];
    [self WriteStr:fullLine];
    [self Enter];
    
    NSArray* dealArr = orderData[@"DetailList"];
    
    for (int i = 0; i < [dealArr count]; i++) {
        NSDictionary* dealData = [dealArr objectAtIndex:i];
        [self BigFont];
        [self Align:ALIGN_LEFT];
        NSString* str = [NSString stringWithFormat:@"x%@   $%@", dealData[@"BuyQty"], dealData[@"Price"]];
        [self WriteStr:[self GetFullStr:dealData[@"ProductName"] :str]];
        [self Enter];
    }
    
    [self Align:ALIGN_LEFT];
    [self BigFont];
    [self WriteStr:fullLine];
    [self Enter];
    [self BigFont];
    [self Align:ALIGN_LEFT];
    [self WriteStr:[self GetFullStr:@"Delivery Fee" :[NSString stringWithFormat:@"$%@", orderData[@"DeliveryFee"]]]];
    [self Enter];
    [self BigFont];
    [self Align:ALIGN_LEFT];
    [self WriteStr:[self GetFullStr:@"Total" :[NSString stringWithFormat:@"$%@", orderData[@"Total"]]]];
    [self Enter];
    [self BigFont];
    [self Align:ALIGN_LEFT];
    [self WriteStr:[self GetFullStr:@"Payment" :[NSString stringWithFormat:@"$%@", orderData[@"Payment"]]]];
    [self Enter];
    
    [self Align:ALIGN_LEFT];
    [self BigFont];
    [self WriteStr:fullLine];
    [self Enter];
    [self Align:ALIGN_LEFT];
    [self BigFont];
    [self WriteStr:@"Note:"];
    [self Enter];
    [self Align:ALIGN_LEFT];
    [self SmallFont];
    [self WriteStr:orderData[@"Note"]];
    [self Enter];
    
    [self Align:ALIGN_LEFT];
    [self SmallFont];
    [self WriteStr:@"CreateTime: "];
    [self WriteStr:orderData[@"CreateTime"]];
    [self Enter];
    [self Align:ALIGN_LEFT];
    [self SmallFont];
    [self WriteStr:@"ConfirmTime: "];
    [self WriteStr:orderData[@"ConfirmTime"]];
    [self Enter];
    
    [self Blank:10];
    [self Enter];
}

- (NSString*)GetFullStr:(NSString*)left :(NSString*)right
{
    NSString* emptyStr = left;
    
    int leftLen = [left length];
    int rightLen = [right length];
    
    for(int i = 0; i < [left length]; i++){
        int a = [left characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            leftLen += 1;
        }
    }
    
    for(int i = 0; i < [right length]; i++){
        int a = [right characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            rightLen += 1;
        }
    }
    
    for (int i = 0; i < [fullLine length] - leftLen - rightLen; i++) {
        emptyStr = [NSString stringWithFormat:@"%@ ", emptyStr];
    }
    emptyStr = [NSString stringWithFormat:@"%@%@", emptyStr, right];
    
    return emptyStr;
}

- (void)Align:(int)mod
{
    
    SerialGATT* gat = [SerialGATT share];
    CBPeripheral* peripheral = gat.activePeripheral;
    Byte a[3] = { 0 };
    a[0] = 0x1B;
    a[1] = 0x61;
    a[2] = mod;
    
    NSData* data = [NSData dataWithBytes:a length:3];
    [gat write:peripheral data:data];
}

- (void)Enter
{
    SerialGATT* gat = [SerialGATT share];
    CBPeripheral* peripheral = gat.activePeripheral;
    Byte a = 0x0A;
    
    NSData* data = [NSData dataWithBytes:&a length:1];
    [gat write:peripheral data:data];
}

- (void)BigFont
{
    
    SerialGATT* gat = [SerialGATT share];
    CBPeripheral* peripheral = gat.activePeripheral;
    Byte a[3] = { 0 };
    a[0] = 0x1B;
    a[1] = 0x4D;
    a[2] = 0;
    
    NSData* data = [NSData dataWithBytes:a length:3];
    [gat write:peripheral data:data];
}

- (void)SmallFont
{
    
    SerialGATT* gat = [SerialGATT share];
    CBPeripheral* peripheral = gat.activePeripheral;
    Byte a[3] = { 0 };
    a[0] = 0x1B;
    a[1] = 0x4D;
    a[2] = 1;
    
    NSData* data = [NSData dataWithBytes:a length:3];
    [gat write:peripheral data:data];
}

- (void)Blank:(int)row
{
    
    SerialGATT* gat = [SerialGATT share];
    CBPeripheral* peripheral = gat.activePeripheral;
    Byte a[3] = { 0 };
    a[0] = 0x1B;
    a[1] = 0x64;
    a[2] = row & 0xff;
    
    NSData* data = [NSData dataWithBytes:a length:3];
    [gat write:peripheral data:data];
}

- (void)WriteStr:(NSString*)str
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [str dataUsingEncoding:gbkEncoding];
    
    SerialGATT* gat = [SerialGATT share];
    CBPeripheral* peripheral = gat.activePeripheral;
    [gat write:peripheral data:data];
}

- (IBAction)OnClickSetting:(id)sender {
    
}

- (IBAction)OnClickAddr:(id)sender {
}

- (IBAction)OnClickCall:(id)sender {
    [NetWorkManager Call:[self.phoneNumLabel text]];
}

- (IBAction)OnClickNotes:(id)sender {
}

- (IBAction)OnClickResCall:(id)sender {
    [NetWorkManager Call:[self.resphoneNumLabel text]];
}

- (IBAction)OnClickBtn:(id)sender
{
    if (m_iCurOrderState == 1) {
        NSString* confirmTime = [self.cusSetTimeLabel text];
        if ([confirmTime isEqualToString:@""]) {
            [AppDelegate ShowTips:@"Please Input Estamited Time!"];
            return;
        }
        
        [NetWorkManager ConfirmOrderByID:m_iCurOrderID AndEsTime:confirmTime WithSuccess:^(AFHTTPRequestOperation *operation, id data) {
            if (data) {
                [AppDelegate jumpToMain];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else if (m_iCurOrderState == 2) {
        [NetWorkManager FinishCookingByID:m_iCurOrderID WithSuccess:^(AFHTTPRequestOperation *operation, id data) {
            if (data) {
                [AppDelegate jumpToMain];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
- (IBAction)OnClickCusSettingTime:(id)sender
{
    if (m_iCurOrderState == 1) {
        m_pInputCache = self.cusSetTimeLabel;
        [self.pickerView setHidden:NO];
    }
}

- (IBAction)OnClickEstamitedTime:(id)sender {
    
}

- (IBAction)OnClickActualTime:(id)sender {
//    if (m_iCurOrderState == 2) {
//        m_pInputCache = self.actualTime;
//        [self.pickerView setHidden:NO];
//    }
}

- (IBAction)OnClickCancelPick:(id)sender {
    [self.pickerView setHidden:YES];
}

- (IBAction)OnClickConfirm:(id)sender {
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [m_pInputCache setText:[formater stringFromDate:[self.timePicker date]]];
    [self.pickerView setHidden:YES];
}

- (void)showAlertViewForInput:(NSString*)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入内容"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* textInput = [alert textFieldAtIndex:0];
    [textInput setText:text];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField* tt = [alertView textFieldAtIndex:0];
        
        if (m_pInputCache != nil) {
            [m_pInputCache setText:[tt text]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [m_pPop dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (m_pCurOrderDetailInfo[@"DetailList"]) {
        return [m_pCurOrderDetailInfo[@"DetailList"] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellIdentifier";
    FoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FoodListCell" owner:self options:nil] objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary* info = [m_pCurOrderDetailInfo[@"DetailList"] objectAtIndex:indexPath.row];
    [cell.nameLabel setText:info[@"ProductName"]];
    [cell.numLabel setText:[NSString stringWithFormat:@"x%@", info[@"BuyQty"]]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"$%@", info[@"Price"]]];
    
    return cell;
}

@end
