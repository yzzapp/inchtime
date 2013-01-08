//
//  YZZFaceItem.m
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-5.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZFaceItem.h"

#define kFileName           @"CurriculumListFile"
#define kTitleName          @"CurriculumTitleName"
#define kBackgroundThemeID  @"BackgroundThemeID"
#define kLessonThemeID      @"LessonThemeID"
#define kHomeworkThemeID    @"HomeworkThemeID"
#define kCurWeek            @"CurWeek"

@implementation YZZFaceItem

@synthesize m_fileName;
@synthesize m_title;
@synthesize m_bgThemeID;
@synthesize m_lnThemeID;
@synthesize m_hwThemeID;
@synthesize m_curweek;

- (id)init
{
    self = [super init];
    if (self) {
        m_fileName  = [[NSString alloc] initWithFormat:@""];
        m_title     = [[NSString alloc] initWithFormat:@""];  
        m_bgThemeID = [NSNumber numberWithInt:1];
        m_lnThemeID = [NSNumber numberWithInt:1];
        m_hwThemeID = [NSNumber numberWithInt:1];
        m_curweek   = [NSNumber numberWithInt:1];
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:m_fileName     forKey:kFileName];
    [aCoder encodeObject:m_title        forKey:kTitleName];
    [aCoder encodeObject:m_bgThemeID    forKey:kBackgroundThemeID];
    [aCoder encodeObject:m_lnThemeID    forKey:kLessonThemeID];
    [aCoder encodeObject:m_hwThemeID    forKey:kHomeworkThemeID];
    [aCoder encodeObject:m_curweek      forKey:kCurWeek];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init])
    {
        m_fileName  = [aDecoder decodeObjectForKey:kFileName];
        m_title     = [aDecoder decodeObjectForKey:kTitleName];
        m_bgThemeID = [aDecoder decodeObjectForKey:kBackgroundThemeID];
        m_lnThemeID = [aDecoder decodeObjectForKey:kLessonThemeID];
        m_hwThemeID = [aDecoder decodeObjectForKey:kHomeworkThemeID];
        m_curweek   = [aDecoder decodeObjectForKey:kCurWeek];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    YZZFaceItem *copy   = [[[self class] allocWithZone:zone] init];
    copy.m_fileName     = [self.m_fileName  copyWithZone:zone];
    copy.m_title        = [self.m_title     copyWithZone:zone];
    copy.m_bgThemeID    = [self.m_bgThemeID copyWithZone:zone];
    copy.m_lnThemeID    = [self.m_lnThemeID copyWithZone:zone];
    copy.m_hwThemeID    = [self.m_hwThemeID copyWithZone:zone];
    copy.m_curweek      = [self.m_curweek   copyWithZone:zone];
    return copy;
}

@end
