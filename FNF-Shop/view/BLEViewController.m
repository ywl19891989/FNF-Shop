//
//  BLEDeviceViewController.h
//  HMSoft
//
//  Created by HMSofts on 7/13/12.
//  Copyright (c) 2012 jnhuamao.cn. All rights reserved.
//

#import "BLEViewController.h"
#import "AppDelegate.h"

@interface BLEViewController ()

@end

@implementation BLEViewController
@synthesize btHMSoftTableView;

@synthesize Scan;

@synthesize sensor;
@synthesize peripheralViewControllerArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect rect = self.view.bounds;
        rect.origin.y = [self getTopOffsetY];
        rect.size.height = rect.size.height + [self getTopOffsetY];
        [self.view setFrame:rect];
        [self.view setBounds:rect];
    }
    return self;
}

- (CGFloat)getTopOffsetY
{
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (ver > 6.0)
    {
        return -20;
    }
    
    return 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"HMSoft";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    sensor = [SerialGATT share];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
}

- (void)setConnect
{
    
}

- (void)setDisconnect
{
    
}

- (IBAction)OnClickBack:(id)sender
{
    [AppDelegate jumpToOrderDetail];
}

- (void)viewDidUnload
{
    sensor.delegate = nil;
    [self setBtHMSoftTableView:nil];
    [super viewDidUnload];
}

- (IBAction)scanHMSoftDevices:(id)sender {
    if ([sensor activePeripheral]) {
        if (sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
            sensor.activePeripheral = nil;
        }
    }
    
    if ([sensor peripherals]) {
        sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
        [btHMSoftTableView reloadData];
    }
    
    sensor.delegate = self;
    printf("now we are searching device...\n");
    [Scan setTitle:@"Scaning" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    [sensor findHMSoftPeripherals:5];
}

/*
 * scanTimer
 * when scanHMSoftDevices is timeout, this function will be called
 *
 */
-(void) scanTimer:(NSTimer *)timer
{
    [Scan setTitle:@"Scan" forState:UIControlStateNormal];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peripheralViewControllerArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    CBPeripheral *peripheral = [peripheralViewControllerArray objectAtIndex:row];
    
    if (sensor.activePeripheral && sensor.activePeripheral != peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    
    sensor.activePeripheral = peripheral;
    [sensor connect:sensor.activePeripheral];
    [sensor stopScan];
    
    [Scan setTitle:@"Scan" forState:UIControlStateNormal];
    
    [self OnClickBack:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"peripheral";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    // Configure the cell
    NSUInteger row = [indexPath row];
    CBPeripheral *peripheral = [peripheralViewControllerArray objectAtIndex:row];
    cell.textLabel.text = peripheral.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


#pragma mark - HMSoftSensorDelegate
-(void)sensorReady
{
    
}

-(void) peripheralFound:(CBPeripheral *)peripheral
{
    [peripheralViewControllerArray addObject:peripheral];
    [btHMSoftTableView reloadData];
}

@end
