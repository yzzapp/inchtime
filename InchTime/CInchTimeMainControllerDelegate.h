//
//  CInchTimeMainControllerDelegate.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-3.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YZZThemeVC;
@class YZZCurriculumVC;

@protocol CInchTimeMainControllerDelegate <NSObject>

@optional

-(BOOL)CurriculumExist:(NSString *)curriculumName;
-(void)SaveCurriculum:(YZZCurriculumVC *) curriculumController;
-(void)RenameCurriculum:(YZZCurriculumVC *) curriculumController OldName: (NSString *)oldName;
-(void)Refresh;

@end
