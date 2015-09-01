//
//  TransacationCell.h
//  FNF-Shop
//
//  Created by Wenlong on 15-9-1.
//  Copyright (c) 2015年 hali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransacationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *carriageLabel;
@end
