//
//  YZZUtilities.m
//  InchTime
//
//  Created by 石 戬 on 12-4-28.
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZUtilities.h"

@implementation YZZUtilities

+ (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (int)queryWeekday
{
    NSDate * today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:today];
    int weekday = [comps weekday];
    return weekday;
}

+ (NSString *)trim:(NSString *)str
{    
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
