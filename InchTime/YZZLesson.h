//
//  YZZLesson.h
//  Inchtime Curriculum
//
//  Created by 暂时还没对象的高级工程师老王 on 11-11-4.
//  Updated by 石 戬 on 12-4-15
//  Copyright 2011年 北京云指针科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZZLesson : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString * m_title;
@property (nonatomic, strong) NSString * m_description;
@property (nonatomic, strong) NSString * m_teacher;
@property (nonatomic, strong) NSString * m_book;

@end
