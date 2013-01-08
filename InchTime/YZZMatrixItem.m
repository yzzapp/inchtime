//
//  YZZMatrixItem.m
//  Inchtime Curriculum
//
//  Created by 暂时还没对象的高级工程师老王 on 11-11-15.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2011年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZMatrixItem.h"

#define kMatrixIKey             @"MatrixIKey"
#define kWeekType               @"WeekType"

#define kSingleWeekClass        @"SingleClass"
#define kSingleWeekClassRoom    @"SingleRoom"
#define kSingleWeekHomework     @"SingleHomework"
#define kSingleWeekRemark       @"SingleRemark"
#define kDoubleWeekClass        @"DoubleClass"
#define kDoubleWeekClassRoom    @"DoubleRoom"
#define kDoubleWeekHomework     @"DoubleWeekHomework"
#define kDoubleWeekRemark       @"DoubleWeekRemark"

@implementation YZZMatrixItem
@synthesize m_matrixIKey;
@synthesize m_weekType;
@synthesize m_singleWeekClass;
@synthesize m_singleWeekClassroom;
@synthesize m_singleWeekHomework;
@synthesize m_singleWeekRemark;
@synthesize m_doubleWeekClass;
@synthesize m_doubleWeekClassroom;
@synthesize m_doubleWeekHomework;
@synthesize m_doubleWeekRemark;

- (id)init
{
    if (self = [super init]) {
        m_matrixIKey            = [[NSString alloc] initWithFormat:@""];
        m_weekType              = [NSNumber numberWithInt:0];
        m_singleWeekClass       = [[NSString alloc] initWithFormat:@""];
        m_singleWeekClassroom   = [[NSString alloc] initWithFormat:@""];
        m_singleWeekHomework    = [[NSString alloc] initWithFormat:@""];
        m_singleWeekRemark      = [[NSString alloc] initWithFormat:@""];
        m_doubleWeekClass       = [[NSString alloc] initWithFormat:@""];
        m_doubleWeekClassroom   = [[NSString alloc] initWithFormat:@""];
        m_doubleWeekHomework    = [[NSString alloc] initWithFormat:@""];
        m_doubleWeekRemark      = [[NSString alloc] initWithFormat:@""];
    }
    return self;
}

- (id)initWithMatrixIKey:(NSString *)matrixIKey lessonTitle:(NSString *)classTitle
{
    if (self == [super init]) {
        m_matrixIKey            = [[NSString alloc] initWithString:matrixIKey];
        m_weekType              = [NSNumber numberWithInt:0];
        m_singleWeekClass       = [[NSString alloc] initWithString:classTitle];
        m_singleWeekClassroom   = [[NSString alloc] initWithFormat:@""];
        m_singleWeekHomework    = [[NSString alloc] initWithFormat:@""];
        m_singleWeekRemark      = [[NSString alloc] initWithFormat:@""];
        m_doubleWeekClass       = [[NSString alloc] initWithString:classTitle];
        m_doubleWeekClassroom   = [[NSString alloc] initWithFormat:@""];
        m_doubleWeekHomework    = [[NSString alloc] initWithFormat:@""];
        m_doubleWeekRemark      = [[NSString alloc] initWithFormat:@""];
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:m_matrixIKey           forKey:kMatrixIKey];
    [aCoder encodeObject:m_weekType             forKey:kWeekType];
    [aCoder encodeObject:m_singleWeekClass      forKey:kSingleWeekClass];
    [aCoder encodeObject:m_singleWeekClassroom  forKey:kSingleWeekClassRoom];
    [aCoder encodeObject:m_singleWeekHomework   forKey:kSingleWeekHomework];
    [aCoder encodeObject:m_singleWeekRemark     forKey:kSingleWeekRemark];
    [aCoder encodeObject:m_doubleWeekClass      forKey:kDoubleWeekClass];
    [aCoder encodeObject:m_doubleWeekClassroom  forKey:kDoubleWeekClassRoom];
    [aCoder encodeObject:m_doubleWeekHomework   forKey:kDoubleWeekHomework]; 
    [aCoder encodeObject:m_doubleWeekRemark     forKey:kDoubleWeekRemark];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init])
    {
        m_matrixIKey            = [aDecoder decodeObjectForKey:kMatrixIKey];
        m_weekType              = [aDecoder decodeObjectForKey:kWeekType];          
        m_singleWeekClass       = [aDecoder decodeObjectForKey:kSingleWeekClass];
        m_singleWeekClassroom   = [aDecoder decodeObjectForKey:kSingleWeekClassRoom];
        m_singleWeekHomework    = [aDecoder decodeObjectForKey:kSingleWeekHomework];        
        m_singleWeekRemark      = [aDecoder decodeObjectForKey:kSingleWeekRemark];  
        m_doubleWeekClass       = [aDecoder decodeObjectForKey:kDoubleWeekClass];
        m_doubleWeekClassroom   = [aDecoder decodeObjectForKey:kDoubleWeekClassRoom];
        m_doubleWeekHomework    = [aDecoder decodeObjectForKey:kDoubleWeekHomework];        
        m_doubleWeekRemark      = [aDecoder decodeObjectForKey:kDoubleWeekRemark];  
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    YZZMatrixItem *copy = [[[self class] allocWithZone:zone] init];
    copy.m_weekType             = [self.m_weekType              copyWithZone:zone];     
    copy.m_matrixIKey           = [self.m_matrixIKey            copyWithZone:zone];
    copy.m_singleWeekClass      = [self.m_singleWeekClass       copyWithZone:zone];
    copy.m_singleWeekClassroom  = [self.m_singleWeekClassroom   copyWithZone:zone];
    copy.m_doubleWeekClass      = [self.m_doubleWeekClass       copyWithZone:zone];
    copy.m_doubleWeekClassroom  = [self.m_doubleWeekClassroom   copyWithZone:zone];
    copy.m_singleWeekHomework   = [self.m_singleWeekHomework    copyWithZone:zone];
    copy.m_singleWeekRemark     = [self.m_singleWeekRemark      copyWithZone:zone];
    copy.m_doubleWeekHomework   = [self.m_doubleWeekHomework    copyWithZone:zone];
    copy.m_doubleWeekRemark     = [self.m_doubleWeekRemark      copyWithZone:zone]; 
    return copy;
}

@end
