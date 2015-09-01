//
//  CalendarViewFooterView.h
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-12.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enum.h"

@protocol ITTCalendarViewFooterViewDelegate;

@interface ITTCalendarViewFooterView : UIView
{
    UIButton *_selectedButton;
}

@property (nonatomic, assign) id<ITTCalendarViewFooterViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *selectedButton;

+ (ITTCalendarViewFooterView*) viewFromNib;

- (IBAction) onPeriodButtonTouched:(id)sender;

@end

@protocol ITTCalendarViewFooterViewDelegate <NSObject>
@optional
- (void)calendarViewFooterViewDidSelectPeriod:(ITTCalendarViewFooterView*)footerView periodType:(PeriodType)type;
@end

