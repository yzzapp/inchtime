//
//  YZZFace.m
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-5.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZFace.h"
#import "YZZFaceItem.h"
#import "YZZUtilities.h"

#define kDEFAULT_MAIN   @"face.plist"
#define kDEFAULT_BACK   @"faceBackUp.plist"
#define kCURRICULUM_KEY @"curriculums"

@implementation YZZFace
@synthesize m_faceItemList;

- (id)init
{
    if (self = [super init]) {
        self.m_faceItemList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)Save
{ 
    if (nil == m_faceItemList)
    {
        NSLog(@"YZZFace Save: curriculumList is nil, init empty data for face.plist.");
        m_faceItemList = [[NSMutableArray alloc] init];
    }
    NSString *mainFilePath = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:kDEFAULT_MAIN];
    NSString *backFilePath = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:kDEFAULT_BACK];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:m_faceItemList forKey:kCURRICULUM_KEY];
    [archiver finishEncoding];
    [data writeToFile:mainFilePath atomically:YES];
    [data writeToFile:backFilePath atomically:YES];
}

- (void)Load
{
    m_faceItemList = [[NSMutableArray alloc] init];
    NSString *mainFilePath = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:kDEFAULT_MAIN];
    NSString *backFilePath = [[YZZUtilities dataFilePath] stringByAppendingPathComponent:kDEFAULT_BACK];
    NSData *data;    
    if ([[NSFileManager defaultManager] fileExistsAtPath:mainFilePath]) data = [[NSMutableData alloc] initWithContentsOfFile:mainFilePath];
    else
    if ([[NSFileManager defaultManager] fileExistsAtPath:backFilePath]) data = [[NSMutableData alloc] initWithContentsOfFile:backFilePath];
    else
    {
        [self Save];
        data = [[NSMutableData alloc] initWithContentsOfFile:mainFilePath];
    }
        
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    m_faceItemList = [unarchiver decodeObjectForKey:kCURRICULUM_KEY];
}

- (void)Rename:(NSString *)originName name:(NSString *)destinationName
{
    for (YZZFaceItem * iter in m_faceItemList)
    {
        if (iter.m_title == originName)
        {
            iter.m_title = destinationName;
            break;
        }
    }
    [self Save];
}

- (void)Append:(YZZFaceItem *)faceItem
{
    [m_faceItemList addObject:faceItem];
    [self Save];
}

- (void)Remove:(YZZFaceItem *)faceItem
{
    [m_faceItemList removeObject:faceItem];
    [self Save];
}

@end