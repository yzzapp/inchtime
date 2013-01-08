//
//  YZZLesson.m
//  Inchtime Curriculum
//
//  Created by 暂时还没对象的高级工程师老王 on 11-11-4.
//  Updated by 石 戬 on 12-4-15
//  Copyright 2011年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZLesson.h"

#define kTitle      @"Title"
#define kDesc       @"Info"
#define kTeacher    @"Teacher"
#define kBook       @"Book"

@implementation YZZLesson
@synthesize m_title;
@synthesize m_description;
@synthesize m_teacher;
@synthesize m_book;

- (id)init
{
    if (self = [super init]) {
        m_title         = [[NSString alloc] initWithFormat:@""];   
        m_description   = [[NSString alloc] initWithFormat:@""];   
        m_teacher       = [[NSString alloc] initWithFormat:@""];   
        m_book          = [[NSString alloc] initWithFormat:@""];
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init])
    {
        m_title         = [aDecoder decodeObjectForKey:kTitle   ];
        m_description   = [aDecoder decodeObjectForKey:kDesc    ];
        m_teacher       = [aDecoder decodeObjectForKey:kTeacher ];
        m_book          = [aDecoder decodeObjectForKey:kBook    ];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:m_title        forKey:kTitle   ];
    [aCoder encodeObject:m_description  forKey:kDesc    ];
    [aCoder encodeObject:m_teacher      forKey:kTeacher ];
    [aCoder encodeObject:m_book         forKey:kBook    ];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    YZZLesson *copy     = [[[self class] allocWithZone:zone] init];
    copy.m_title        = [self.m_title         copyWithZone:zone];
    copy.m_description  = [self.m_description   copyWithZone:zone];
    copy.m_teacher      = [self.m_teacher       copyWithZone:zone];
    copy.m_book         = [self.m_book          copyWithZone:zone];    
    return copy;
}

@end
