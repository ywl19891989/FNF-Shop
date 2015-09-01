//
//  CalendarViewFooterView.m
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-12.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#import "ITTCalendarViewFooterView.h"

@implementation ITTCalendarViewFooterView

@synthesize selectedButton = _selectedButton;
@synthesize delegate = _delegate;

+ (ITTCalendarViewFooterView*) viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
}

- (IBAction) onPeriodButtonTouched:(id)sender
{
    if (_selectedButton) {
        _selectedButton.userInteractionEnabled = TRUE;
        _selectedButton.selected = FALSE;
    }
    _selectedButton = sender;
    _selectedButton.selected = TRUE;
    _selectedButton.userInteractionEnabled = FALSE;
    if (_delegate && [_delegate respondsToSelector:@selector(calendarViewFooterViewDidSelectPeriod:periodType:)]) {
        [_delegate calendarViewFooterViewDidSelectPeriod:self periodType:_selectedButton.tag];
    }
}

@end
