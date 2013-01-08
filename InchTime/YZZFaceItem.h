//
//  YZZFaceItem.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-5.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZZFaceItem : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString * m_fileName;
@property (nonatomic, strong) NSString * m_title;
@property (nonatomic, strong) NSNumber * m_bgThemeID;   ////由于NSInteger不能保存
@property (nonatomic, strong) NSNumber * m_lnThemeID;
@property (nonatomic, strong) NSNumber * m_hwThemeID;
@property (nonatomic, strong) NSNumber * m_curweek;     ////课表浏览的周类型两种: 1-单(含通用显示) 2-双(含通用显示) ,缺省是1

@end
