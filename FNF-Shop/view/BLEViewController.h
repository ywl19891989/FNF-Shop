//
//  BLEDeviceViewController.h
//  HMSoft
//
//  Created by HMSofts on 7/13/12.
//  Copyright (c) 2012 jnhuamao.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SerialGATT.h"

@interface BLEViewController : UIViewController<BTSmartSensorDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;

- (IBAction)scanHMSoftDevices:(id)sender;

-(void) scanTimer:(NSTimer *)timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (weak, nonatomic) IBOutlet UITableView *btHMSoftTableView;

@property (weak, nonatomic) IBOutlet UIButton *Scan;

@end
