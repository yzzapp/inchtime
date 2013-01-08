//
//  YZZCurriculumVC.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-3.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CInchTimeMainControllerDelegate.h"
#import "YZZFaceItem.h"
#import "YZZCurriculum.h"
#import "YZZTitleTextField.h"

@interface YZZCurriculumVC : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate, CDoubleTapTextFieldDelegate, UIAlertViewDelegate, CInchTimeMainControllerDelegate>

@property (nonatomic, strong) YZZFaceItem   * m_faceItem;
@property (nonatomic, strong) YZZCurriculum * m_curriculum;
@property (nonatomic, weak) id <CInchTimeMainControllerDelegate> m_mainDelegate;

@property (nonatomic, strong)   NSMutableDictionary * m_dicWeekdays;
@property (nonatomic, strong)   NSMutableDictionary * m_dicItemButton;
@property (nonatomic, strong)   NSMutableDictionary * m_dicItemTitleLabel;
@property (nonatomic, strong)   NSMutableDictionary * m_dicItemClassroomLabel;
@property (nonatomic, strong)   NSMutableDictionary * m_dicItemHomeworkIV;
@property (nonatomic, weak)     UIButton            * m_lastTappedButton;
@property (nonatomic, weak)     UILabel             * m_lastTappedLessonLabel;
@property (nonatomic, weak)     UILabel             * m_lastTappedCuRoomLabel;
@property (nonatomic, weak)     UIImageView         * m_lastTappedBoxIV;

@property (nonatomic, strong) IBOutlet UIImageView  * m_backgroundImageView;
@property (strong, nonatomic) IBOutlet UIScrollView * m_scrollView;
@property (strong, nonatomic) IBOutlet UILabel      * m_weekdayThemeLabel;
@property (strong, nonatomic) YZZTitleTextField     * m_titleTextField;
@property (nonatomic, strong) UIPopoverController   * m_classEditPopoverController;

- (IBAction)SelectTheme:(id)sender;
- (IBAction)WeekChanged:(id)sender;
- (void)ShowEditPopover:(id)sender;

//degegate
- (YZZFaceItem *)GetFaceItem;

@end
