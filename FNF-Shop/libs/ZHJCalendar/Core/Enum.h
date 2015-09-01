//
//  Enum.h
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-13.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#ifndef ZHJCalendar_Enum_h
#define ZHJCalendar_Enum_h

typedef enum 
{
    PeriodTypeUnknown = 11,
    PeriodTypeAllDay,
    PeriodTypeMorning,
    PeriodTypeNoon,
    PeriodTypeAfternoon,
    PeriodTypeEvening
}PeriodType;

typedef enum 
{
    WeekDayUnknown = 0,
    WeekDayMonday,
    WeekDayTuesday,
    WeekDayWednesday,
    WeekDayThurday,
    WeekDayFriday,
    WeekDaySaturday,
    WeekDaySunday
}WeekDay;

typedef struct 
{
    NSInteger row;
    NSInteger column;
}GridIndex;

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#endif
