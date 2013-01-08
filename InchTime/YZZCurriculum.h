//
//  YZZCurriculum.h
//  Inchtime Curriculum
//
//  Created by 暂时还没对象的高级工程师老王 on 11-11-4.
//  Updated by 石 戬 on 12-4-15
//  Copyright 2011年 北京云指针科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZZLesson.h"
#import "YZZMatrixItem.h"

@interface YZZCurriculum : NSObject

@property (nonatomic, strong) NSString              * m_name;
@property (nonatomic, strong) NSMutableDictionary   * m_LessonList;
@property (nonatomic, strong) NSMutableDictionary   * m_MatrixList;//// 课程表是一个串表示的矩阵

- (void)Load;
- (void)Save;
- (void)Rename: (NSString *)originFullFilePath name:(NSString *)destinationFullFilePath;
- (void)Create: (NSString *)name;
- (void)Remove: (NSString *)name;

- (void)            initMatrix;
- (void)            clearMatrixItem:(YZZMatrixItem *)matrixItem WeekType:(NSInteger)weektype;
- (YZZMatrixItem *) getMatrixItem:  (NSInteger)ikey;
+ (NSUInteger)      getIKey:        (NSUInteger)weekday section:(NSUInteger)section;

@end
