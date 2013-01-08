//
//  YZZLessonEditingVC.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-7.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZZLessonDropdownVC.h"
#import "YZZCurriculum.h"

@interface YZZLessonEditingVC : UITableViewController <UITextFieldDelegate, UIPopoverControllerDelegate, YZZLessonDropdownDelegate>

@property (weak, nonatomic) IBOutlet UITextField        * m_cuTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView         * m_cuDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField        * m_cuTeacherTextField;
@property (weak, nonatomic) IBOutlet UITextField        * m_cuBookTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl * m_itemWeekTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField        * m_itemClassroomTextField;
@property (weak, nonatomic) IBOutlet UITextView         * m_itemHomeworkTextView;
@property (weak, nonatomic) IBOutlet UITextView         * m_itemRemarksTextView;

@property (nonatomic, strong) UIPopoverController       * m_lessonDropdownPopoverController;
@property (nonatomic, strong) NSMutableDictionary       * m_ClassInfoDic;

@property (nonatomic, weak) id <UITextFieldDelegate>    m_Delegate;

- (void)PrepareDropdown:            (NSMutableDictionary *)lessonDic;
- (void)ConfigEditController:       (YZZLesson *)lesson;
- (IBAction)ShowClassChoosePopover: (id)sender;

@end
