//
//  YZZLessonDropdownVC.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-11.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZZLessonDropdownVC;

@protocol YZZLessonDropdownDelegate <NSObject>

-(void)Selected:(YZZLessonDropdownVC *)controller;

@end

@interface YZZLessonDropdownVC : UITableViewController

@property (nonatomic, strong) NSArray  * m_LessonList;
@property (nonatomic, strong) NSString * m_selectedLesson;

@property (nonatomic, weak) id <YZZLessonDropdownDelegate> m_popoverDelegate;

@end
