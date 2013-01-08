//
//  YZZMatrixItem.h
//  Inchtime Curriculum
//
//  Created by 暂时还没对象的高级工程师老王 on 11-11-15.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2011年 北京云指针科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZZMatrixItem : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString * m_matrixIKey;
@property (nonatomic, strong) NSNumber * m_weekType;//// 课时选择的周类型有三种 0-通用 1-单 2-双 ,缺省是0
@property (nonatomic, strong) NSString * m_singleWeekClass;
@property (nonatomic, strong) NSString * m_singleWeekClassroom;
@property (nonatomic, strong) NSString * m_singleWeekHomework;
@property (nonatomic, strong) NSString * m_singleWeekRemark;
@property (nonatomic, strong) NSString * m_doubleWeekClass;
@property (nonatomic, strong) NSString * m_doubleWeekClassroom;
@property (nonatomic, strong) NSString * m_doubleWeekHomework;
@property (nonatomic, strong) NSString * m_doubleWeekRemark;

- (id)initWithMatrixIKey:(NSString *)matrixIKey lessonTitle:(NSString *)classTitle;

@end
