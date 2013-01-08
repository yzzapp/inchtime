//
//  YZZCurriculum.m
//  Inchtime Curriculum
//
//  Created by 暂时还没对象的高级工程师老王 on 11-11-4.
//  Updated by 石 戬 on 12-4-15
//  Copyright 2011年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZCurriculum.h"
#import "YZZUtilities.h"

#define kDEFAULT_LESSON @"%@Lesson.plist"
#define kDEFAULT_MATRIX @"%@Matrix.plist"

#define kTheme_CONST_ONE_WEEK_WIDTH 7
#define kTheme_CONST_ONE_DAY_LENGTH 9

#define kLesson         @"Lesson"
#define kMatrix         @"Matrix"

@implementation YZZCurriculum
@synthesize m_name;
@synthesize m_LessonList;
@synthesize m_MatrixList;

- (id)init
{
    if (self = [super init]) {
        self.m_name         = [[NSString alloc] initWithString:@""];
        self.m_LessonList   = [[NSMutableDictionary alloc] init];
        self.m_MatrixList   = [[NSMutableDictionary alloc] init];
        [self initMatrix];
    }
    return self;
}

- (id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        m_name = name;
        m_LessonList    = [[NSMutableDictionary alloc] init];
        m_MatrixList    = [[NSMutableDictionary alloc] init];
        [self initMatrix];
    }
    return self;
}

- (void)Save
{
    NSString        * lessonFilePath = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:kDEFAULT_LESSON,m_name]];
    NSString        * matrixFilePath = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:kDEFAULT_MATRIX,m_name]];
    NSMutableData   * dataLessonList = [[NSMutableData alloc] init];
    NSMutableData   * dataMatrixList = [[NSMutableData alloc] init];
    NSKeyedArchiver * archiverLesson = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataLessonList];
    NSKeyedArchiver * archiverMatrix = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataMatrixList];
    
    [archiverLesson encodeObject:m_LessonList forKey:kLesson];
    [archiverMatrix encodeObject:m_MatrixList forKey:kMatrix];
    [archiverLesson finishEncoding];
    [archiverMatrix finishEncoding];
    [dataLessonList writeToFile:lessonFilePath atomically:YES];
    [dataMatrixList writeToFile:matrixFilePath atomically:YES];
}

- (void)Load
{
    NSString *lessonFilePath = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:kDEFAULT_LESSON,m_name]];
    NSString *matrixFilePath = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:kDEFAULT_MATRIX,m_name]];
        
    if ([[NSFileManager defaultManager] fileExistsAtPath:lessonFilePath])
    {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:lessonFilePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        m_LessonList = [unarchiver decodeObjectForKey:kLesson]; 
        [unarchiver finishDecoding];
    }
    else
    {
        m_LessonList = nil;
        if (nil == m_LessonList) m_LessonList = [[NSMutableDictionary alloc] init];
        [m_LessonList removeAllObjects];
        YZZLesson *lesson = [[YZZLesson alloc] init];
        [m_LessonList setObject:lesson forKey:@""];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:matrixFilePath])
    {            
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:matrixFilePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        m_MatrixList = [unarchiver decodeObjectForKey:kMatrix];
        [unarchiver finishDecoding];         
    }
    else
    {
        m_MatrixList = nil;
        [self initMatrix];
    }  
}

- (void)Rename:(NSString *)originFullFilePath name:(NSString *)destinationFullFilePath
{    
    NSString *originLn = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:kDEFAULT_LESSON,originFullFilePath]];
    NSString *destinLn = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:kDEFAULT_LESSON,destinationFullFilePath]];
    NSString *originMx = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:kDEFAULT_MATRIX,originFullFilePath]];
    NSString *destinMx = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:kDEFAULT_MATRIX,destinationFullFilePath]];

    NSError *error;
    if ([[NSFileManager defaultManager] moveItemAtPath:originLn toPath:destinLn error:&error] != YES)
        NSLog(@"Unable to move file: %@", [error localizedDescription]);  
    if ([[NSFileManager defaultManager] moveItemAtPath:originMx toPath:destinMx error:&error] != YES)
        NSLog(@"Unable to move file: %@", [error localizedDescription]);  
}

- (void)Create:(NSString *)name
{
    m_name = name;
    m_LessonList    = [[NSMutableDictionary alloc] init];
    m_MatrixList    = [[NSMutableDictionary alloc] init];
    [self initMatrix];
    [self Save];
}

- (void)Remove:(NSString *)name
{
    NSString *delFile1 = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc]initWithFormat:kDEFAULT_LESSON, name]];
    NSString *delFile2 = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:[[NSString alloc]initWithFormat:kDEFAULT_MATRIX, name]]; 
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:delFile1 error:&error]) NSLog(@"YZZ Curriculum Delete:Unable to remove file1: %@", [error localizedDescription]);
    if (![[NSFileManager defaultManager] removeItemAtPath:delFile2 error:&error]) NSLog(@"YZZ curriculum Delete:Unable to remove file2: %@", [error localizedDescription]);
}

#pragma mark - matrix

- (void)initMatrix
{
    if (nil == m_MatrixList)
    {
        m_MatrixList = [[NSMutableDictionary alloc] init];
    } else {
        [m_MatrixList removeAllObjects];
    }
    for (NSUInteger weekday = 1; weekday <= kTheme_CONST_ONE_WEEK_WIDTH; ++weekday) {
        for (NSUInteger section = 1; section <= kTheme_CONST_ONE_DAY_LENGTH; ++section) {
            NSUInteger iKey = [YZZCurriculum getIKey:weekday section:section];
            NSString *strKey = [[NSString alloc] initWithFormat:@"%u", iKey];
            YZZMatrixItem *item = [[YZZMatrixItem alloc] initWithMatrixIKey:strKey lessonTitle:@""];
            [m_MatrixList setObject:item forKey:strKey];
        }
    }
}

- (YZZMatrixItem *)getMatrixItem:(NSInteger)ikey
{
    NSString *strKey = [[NSString alloc] initWithFormat:@"%u",ikey];
    YZZMatrixItem *item = [m_MatrixList objectForKey:strKey];
    return item;
}

- (void)clearMatrixItem:(YZZMatrixItem *)matrixItem WeekType:(NSInteger)weektype
{
    switch (weektype) {
        case 0:
        {
            matrixItem.m_singleWeekClass        = @"";
            matrixItem.m_singleWeekClassroom    = @"";
            matrixItem.m_singleWeekHomework     = @"";
            matrixItem.m_singleWeekRemark       = @"";
            
            matrixItem.m_doubleWeekClass        = @"";
            matrixItem.m_doubleWeekClassroom    = @"";
            matrixItem.m_doubleWeekHomework     = @"";
            matrixItem.m_doubleWeekRemark       = @"";
            break;
        }
        case 1:
        {
            matrixItem.m_singleWeekClass        = @"";
            matrixItem.m_singleWeekClassroom    = @"";
            matrixItem.m_singleWeekHomework     = @"";
            matrixItem.m_singleWeekRemark       = @"";
            break;
        }
        case 2:
        {
            matrixItem.m_doubleWeekClass        = @"";
            matrixItem.m_doubleWeekClassroom    = @"";
            matrixItem.m_doubleWeekHomework     = @"";
            matrixItem.m_doubleWeekRemark       = @"";
            break;
        }
        default:
        {
            //clear finished.
        }
    }
}

+ (NSUInteger)getIKey:(NSUInteger)weekday section:(NSUInteger)section
{
    NSUInteger iKey = (weekday << 16) + section;
    return iKey;
}

@end
