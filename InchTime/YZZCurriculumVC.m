//
//  YZZCurriculumVC.m
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-3.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "YZZCurriculumVC.h"
#import "YZZFaceItemButton.h"
#import "YZZCurriculum.h"
#import "YZZLessonEditingVC.h"
#import "YZZThemeVC.h"
#import "YZZUtilities.h"

#import "YZZThemeHeader.h"

@implementation YZZCurriculumVC

@synthesize m_faceItem;
@synthesize m_curriculum;
@synthesize m_mainDelegate;

@synthesize m_dicWeekdays;
@synthesize m_dicItemButton;
@synthesize m_dicItemTitleLabel;
@synthesize m_dicItemClassroomLabel;
@synthesize m_dicItemHomeworkIV;
@synthesize m_lastTappedButton;
@synthesize m_lastTappedLessonLabel;
@synthesize m_lastTappedCuRoomLabel;
@synthesize m_lastTappedBoxIV;

@synthesize m_backgroundImageView;
@synthesize m_titleTextField;
@synthesize m_scrollView;
@synthesize m_weekdayThemeLabel;
@synthesize m_classEditPopoverController;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self InitDataModel];
    [self ShowCurriculum];
}

- (void)viewDidUnload
{
    m_faceItem = nil;
    m_curriculum = nil;
    
    m_mainDelegate = nil;   

    m_dicWeekdays = nil;
    m_dicItemButton         = nil;
    m_dicItemTitleLabel     = nil;
    m_dicItemClassroomLabel = nil;
    m_dicItemHomeworkIV     = nil;
    m_lastTappedButton      = nil;
    m_lastTappedLessonLabel = nil;
    m_lastTappedCuRoomLabel = nil;
    m_lastTappedBoxIV       = nil;
    
    m_weekdayThemeLabel = nil;
    m_backgroundImageView = nil;    
    m_scrollView = nil;
    m_classEditPopoverController = nil;
    m_titleTextField = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - InitDataModel


-(void)InitDataModel
{
    m_curriculum = [[YZZCurriculum alloc] init];
    m_curriculum.m_name = m_faceItem.m_title;
    [m_curriculum Load];
}

-(NSString *)LessonFile
{
    return [[NSString alloc] initWithFormat:@"%@Lesson.plist", m_faceItem.m_title];
}

-(NSString *)CurriculumFile
{
    return [[NSString alloc] initWithFormat:@"%@Matrix.plist", m_faceItem.m_title];
}

#pragma mark - 初始化界面

-(void)ShowCurriculum
{    
    [self ShowBackground];
    [self ShowWeekdays];
    [self ShowCuMatrix];
    
    [self PrepareEditingVC];
    [self InitNavigationBar];
}

-(void)ShowBackground
{
    UIImage *image = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_Backgound_Format,[m_faceItem.m_bgThemeID intValue]]];
    [m_backgroundImageView setImage:image];
}

-(void)ShowWeekdays
{
    m_dicWeekdays = [[NSMutableDictionary alloc] init];
    NSDictionary * weekDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"星期一", @"1",     @"星期二", @"2",       @"星期三", @"3",
                              @"星期四", @"4",     @"星期五", @"5",       @"星期六", @"6",
                              @"星期日", @"7",     nil];
    for (NSUInteger weekday = 1; weekday <= kTheme_CONST_ONE_WEEK_WIDTH; ++weekday)
    {
        NSString * title    = [weekDic objectForKey:[NSString stringWithFormat:@"%d", weekday]];
        UILabel  * dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTheme_Weekday_StartPositionX + (weekday-1) * (kTheme_Weekday_Width + kTheme_Weekday_Interval),
                                                                        kTheme_Weekday_StartPositionY,
                                                                        kTheme_Weekday_Width,
                                                                        kTheme_Weekday_Height)];
        
        [dayLabel setFont:m_weekdayThemeLabel.font];
        [dayLabel setTextColor:m_weekdayThemeLabel.textColor];
        [dayLabel setTextAlignment:UITextAlignmentCenter];
        [dayLabel setAlpha:m_weekdayThemeLabel.alpha];
        [dayLabel setBackgroundColor:m_weekdayThemeLabel.backgroundColor];
        [dayLabel setText:title];
        
        [m_scrollView   addSubview:dayLabel];
        [m_dicWeekdays  setObject:dayLabel forKey: [NSString stringWithFormat: @"%d", weekday]];
    }       
    int weekday = [YZZUtilities queryWeekday];
    weekday = ((weekday - 1) == 0? 7 : (weekday - 1));
    UILabel * weekLabel = [m_dicWeekdays objectForKey:[NSString stringWithFormat:@"%d", weekday]];
    [weekLabel setBackgroundColor:[UIColor greenColor]];
}

-(void)ShowCuMatrix
{
    m_dicItemButton         = [[NSMutableDictionary alloc] init];
    m_dicItemTitleLabel     = [[NSMutableDictionary alloc] init];
    m_dicItemClassroomLabel = [[NSMutableDictionary alloc] init];
    m_dicItemHomeworkIV     = [[NSMutableDictionary alloc] init];
    
    int offsetX = 0;
    int offsetY = 0;
    
    for (NSUInteger weekday = 1; weekday <= kTheme_CONST_ONE_WEEK_WIDTH; ++weekday) {
        for (NSUInteger sectionRow = 1; sectionRow <= kTheme_CONST_ONE_DAY_LENGTH; ++sectionRow) {
            if ( sectionRow == kTheme_RestTime_LunchRow || sectionRow == kTheme_RestTime_SupperRow ) 
                offsetY += kTheme_RestTime_Height;
                        
            NSUInteger iKey = [YZZCurriculum getIKey:weekday section:sectionRow];
            
            UIButton    * button    = [self genLessonButton:iKey        x:offsetX   y:offsetY];
            UILabel     * lesson    = [self genLessonTitleLabel:iKey    x:offsetX   y:offsetY];
            UILabel     * classroom = [self genClassroomLabel:iKey      x:offsetX   y:offsetY];
            UIImageView * homework  = [self genHomeworkImageView:iKey   x:offsetX   y:offsetY];
            
            [m_scrollView addSubview:button];
            [m_scrollView addSubview:lesson];
            [m_scrollView addSubview:classroom];
            [m_scrollView addSubview:homework];
            
            [m_dicItemButton            setValue:button     forKey:[NSString stringWithFormat:@"%d",iKey]];
            [m_dicItemTitleLabel        setValue:lesson     forKey:[NSString stringWithFormat:@"%d",iKey]];
            [m_dicItemClassroomLabel    setValue:classroom  forKey:[NSString stringWithFormat:@"%d",iKey]];
            [m_dicItemHomeworkIV        setValue:homework   forKey:[NSString stringWithFormat:@"%d",iKey]];
            
            offsetY += kTheme_Matrix_Height + kTheme_Matrix_IntervalY;
        }
        offsetY = 0;
        offsetX += kTheme_Matrix_Width + kTheme_Matrix_IntervalX;
    }
}

- (void)PrepareEditingVC
{
    YZZLessonEditingVC *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CCurriculumEditController"];      
	editVC.m_Delegate = self;
    
	m_classEditPopoverController = [[UIPopoverController alloc] initWithContentViewController:editVC];
    [editVC.m_itemWeekTypeSegmentedControl setEnabled:NO forSegmentAtIndex:2]; // 必须在创建popoverview后设置！！！否则不起作用  
    [editVC PrepareDropdown:m_curriculum.m_LessonList];
    
	m_classEditPopoverController.popoverContentSize = CGSizeMake(320., 664.);
	m_classEditPopoverController.delegate = self;
    // [m_classEditPopoverController setPopoverLayoutMargins:UIEdgeInsetsZero];
}

- (void)InitNavigationBar
{   
    //  < toFace ......... (单|双) rename theme save
    NSMutableArray *itemButtons = [[NSMutableArray alloc] initWithCapacity:4];
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"单周", @"双周",nil]];
    [segmentedControl setFrame:CGRectMake(0, 0, 207, 30)];
    [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [segmentedControl setSelectedSegmentIndex: [m_faceItem.m_curweek intValue] - 1];
    [segmentedControl addTarget:self action:@selector(WeekChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *segmentBarButton   = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    UIBarButtonItem *renameButton       = [[UIBarButtonItem alloc] initWithTitle:@"名称"
                                                                           style:UIBarButtonItemStyleBordered 
                                                                          target:self 
                                                                          action:@selector(EditCurriculumTitle:)];
    UIBarButtonItem *themeButton        = [[UIBarButtonItem alloc] initWithTitle:@"主题" 
                                                                           style:UIBarButtonItemStyleBordered 
                                                                          target:self 
                                                                          action:@selector(SelectTheme:)]; 
    [itemButtons addObject:themeButton];
    [itemButtons addObject:renameButton];    
    [itemButtons addObject:segmentBarButton];
    
    self.navigationItem.rightBarButtonItems = itemButtons;
    
    m_titleTextField = [[YZZTitleTextField alloc]initWithFrame:CGRectMake(390, 0, 244, 45)];
    [self.navigationItem setTitleView: m_titleTextField];
    [m_titleTextField setText:m_faceItem.m_title];
    m_titleTextField.m_editDelegate = self;
}

- (UIButton *)genLessonButton:(NSInteger)iKey x:(int)offsetX y:(int)offsetY
{
    UIButton * lnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lnButton setFrame:CGRectMake(kTheme_Matrix_StartPositionX + offsetX,
                                  kTheme_Matrix_StartPositionY + offsetY,
                                  kTheme_Matrix_Width,
                                  kTheme_Matrix_Height)];
    lnButton.layer.cornerRadius = 5;
    //[[button layer] setShadowRadius:2];//5
    //[[button layer] setShadowOffset:CGSizeMake(3, 5)];
    //[[button layer] setShadowOpacity:0.9];            
    //[[button layer] setShadowColor:[UIColor blackColor].CGColor];                  
    [lnButton setTag: iKey];
    UIImage *image = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_LessonBox_Format,[m_faceItem.m_lnThemeID intValue]]];
    [lnButton setBackgroundImage:image forState:UIControlStateNormal];
    [lnButton addTarget:self action:@selector(ShowEditPopover:) forControlEvents:UIControlEventTouchUpInside];
    return lnButton;
}

- (UILabel *)genLessonTitleLabel:(NSInteger)iKey x:(int)offsetX y:(int)offsetY
{
    YZZMatrixItem * matrixItem = [m_curriculum getMatrixItem:iKey];
    UILabel *lnLabel = [[UILabel alloc] init];
    [lnLabel setFrame:CGRectMake(kTheme_Matrix_StartPositionX + offsetX + (kTheme_MatrixTitle_OffsetX),
                                 kTheme_Matrix_StartPositionY + offsetY + (kTheme_MatrixTitle_OffsetY),
                                 kTheme_MatrixTitle_Width,
                                 kTheme_MatrixTitle_Height)];
    lnLabel.font                = [UIFont fontWithName:kTheme_LESSON_FONT size:kTheme_LESSON_FONTSIZE];
    lnLabel.textAlignment       = UITextAlignmentCenter;
    lnLabel.textColor           = [UIColor blackColor];
    lnLabel.backgroundColor     = [UIColor clearColor];
    lnLabel.tag                 = iKey;
    
    if (2 == [m_faceItem.m_curweek intValue])
    {
        [lnLabel setText:matrixItem.m_doubleWeekClass];
    }
    else
    {
        [lnLabel setText:matrixItem.m_singleWeekClass];
    }
    return lnLabel;
}

- (UILabel *)genClassroomLabel:(NSInteger)iKey x:(int)offsetX y:(int)offsetY
{
    YZZMatrixItem * matrixItem = [m_curriculum getMatrixItem:iKey];
    UILabel *roomLabel = [[UILabel alloc] init];
    [roomLabel setFrame:CGRectMake(kTheme_Matrix_StartPositionX + offsetX + kTheme_MatrixClassroom_OffsetX,
                                   kTheme_Matrix_StartPositionY + offsetY + kTheme_MatrixClassroom_OffsetY,
                                   kTheme_MatrixClassroom_Width,
                                   kTheme_MatrixClassroom_Height)];
    roomLabel.font              = [UIFont fontWithName:kTheme_CLASSROOM_FONT size:kTheme_CLASSROOM_FONTSIZE];
    roomLabel.textAlignment     = UITextAlignmentCenter;
    roomLabel.textColor         = [UIColor darkGrayColor];
    roomLabel.backgroundColor   = [UIColor clearColor];
    roomLabel.tag               = iKey;
    if (2 == [m_faceItem.m_curweek intValue])
        [roomLabel setText:matrixItem.m_doubleWeekClassroom];
    else
        [roomLabel setText:matrixItem.m_singleWeekClassroom];
    return roomLabel;
}

- (UIImageView *)genHomeworkImageView:(NSInteger)iKey x:(int)offsetX y:(int)offsetY
{
    YZZMatrixItem * matrixItem = [m_curriculum getMatrixItem:iKey];
    UIImage *imgHomeworkNone = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_Homework_None_Format,[m_faceItem.m_hwThemeID intValue]]];
    UIImage *imgHomeworkHave = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_Homework_Have_Format,[m_faceItem.m_hwThemeID intValue]]];
    UIImage *image = [self getHomeWorkImage:imgHomeworkNone imagehw:imgHomeworkHave matrixItem:matrixItem];
    
    UIImageView *homeworkIV = [[UIImageView alloc] initWithImage:image];
    [homeworkIV setFrame:CGRectMake(kTheme_Matrix_StartPositionX + offsetX + 4,
                                    kTheme_Matrix_StartPositionY + offsetY + 8,
                                    kTheme_MatrixHomework_Size,
                                    kTheme_MatrixHomework_Size)];
    return homeworkIV;
}

- (UIImage *)getHomeWorkImage:(UIImage *)hwNone imagehw:(UIImage *)hwHave matrixItem:(YZZMatrixItem *)matrixItem
{
    UIImage *image = [[UIImage alloc] init];
    image = hwNone;
    if (2==[m_faceItem.m_curweek intValue] && matrixItem.m_doubleWeekHomework.length >0) image = hwHave;
    if (1==[m_faceItem.m_curweek intValue] && matrixItem.m_singleWeekHomework.length >0) image = hwHave;
    return image;
}

#pragma mark - delegate

- (YZZFaceItem *)GetFaceItem
{
    YZZFaceItem * item  = [[YZZFaceItem alloc] init];
    item.m_title        = m_faceItem.m_title;
    item.m_bgThemeID    = m_faceItem.m_bgThemeID;
    item.m_lnThemeID    = m_faceItem.m_lnThemeID;
    item.m_hwThemeID    = m_faceItem.m_hwThemeID;
    item.m_curweek      = m_faceItem.m_curweek;
    return item;
}

#pragma mark - popover view相关接口

- (void)ShowEditPopover:(id)sender
{     
    m_lastTappedButton      = (UIButton *)sender;
    NSUInteger iKey         = m_lastTappedButton.tag;
    m_lastTappedLessonLabel = [m_dicItemTitleLabel      objectForKey:[NSString stringWithFormat:@"%d",iKey]];
    m_lastTappedCuRoomLabel = [m_dicItemClassroomLabel  objectForKey:[NSString stringWithFormat:@"%d",iKey]];
    m_lastTappedBoxIV       = [m_dicItemHomeworkIV      objectForKey:[NSString stringWithFormat:@"%d",iKey]];
    
    YZZMatrixItem * matrixItem = [m_curriculum getMatrixItem:iKey];
    NSString * title = nil;
    if (2 == [m_faceItem.m_curweek intValue])
        title = matrixItem.m_doubleWeekClass;        
    else
        title = matrixItem.m_singleWeekClass;        
        
    YZZLesson * lesson = [self GetLesson:title];
    
    YZZLessonEditingVC *editController = (YZZLessonEditingVC *)[m_classEditPopoverController contentViewController];
	[self ConfigEditController:editController 
                    MatrixItem:matrixItem 
                        lesson:lesson];
    [editController.tableView setContentOffset:CGPointMake(0, 0)];
    [m_classEditPopoverController presentPopoverFromRect:m_lastTappedButton.frame 
                                                  inView:self.m_scrollView 
                                permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)ConfigEditController:(YZZLessonEditingVC *)editingVC
                  MatrixItem:(YZZMatrixItem *)matrixItem
                      lesson:(YZZLesson *)lesson
{
    [editingVC.m_cuTitleTextField       setText:lesson.m_title      ];
    [editingVC.m_cuDescriptionTextView  setText:lesson.m_description];
    [editingVC.m_cuTeacherTextField     setText:lesson.m_teacher    ];
    [editingVC.m_cuBookTextField        setText:lesson.m_book       ];
    
    if (2 == [m_faceItem.m_curweek intValue])
    {
        [editingVC.m_itemClassroomTextField setText:matrixItem.m_doubleWeekClassroom];
        [editingVC.m_itemHomeworkTextView   setText:matrixItem.m_doubleWeekHomework ];
        [editingVC.m_itemRemarksTextView    setText:matrixItem.m_doubleWeekRemark   ];
    } else {
        [editingVC.m_itemClassroomTextField setText:matrixItem.m_singleWeekClassroom];
        [editingVC.m_itemHomeworkTextView   setText:matrixItem.m_singleWeekHomework ];
        [editingVC.m_itemRemarksTextView    setText:matrixItem.m_singleWeekRemark   ];
    }
    
    if (0 == [matrixItem.m_weekType intValue])
        [editingVC.m_itemWeekTypeSegmentedControl setSelectedSegmentIndex:0];
    else
        [editingVC.m_itemWeekTypeSegmentedControl setSelectedSegmentIndex:[m_faceItem.m_curweek intValue]];
}

- (YZZLesson *)GetLesson:(NSString *)title
{
    return [m_curriculum.m_LessonList objectForKey:title];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSUInteger          iKey                = m_lastTappedButton.tag;
    YZZLessonEditingVC  * editController    = (YZZLessonEditingVC *)[m_classEditPopoverController contentViewController];
    
    YZZMatrixItem       * matrixItem        = [m_curriculum getMatrixItem:iKey];
    YZZLesson           * lesson            = [self GetLesson:editController.m_cuTitleTextField.text];

    if (0 == [[YZZUtilities trim:editController.m_cuTitleTextField.text] compare:@""])
    {
        [m_curriculum clearMatrixItem:matrixItem WeekType:[editController.m_itemWeekTypeSegmentedControl selectedSegmentIndex]];
        [m_curriculum Save];
    }
    else if (nil == lesson)
    {
        lesson = [[YZZLesson alloc] init];
        [self updateModel:matrixItem And:lesson By:editController];
    }
    else 
    {
        [self updateModel:matrixItem And:lesson By:editController];
    }
    
    [editController PrepareDropdown:m_curriculum.m_LessonList];
    [m_lastTappedLessonLabel setText:editController.m_cuTitleTextField.text];
    [m_lastTappedCuRoomLabel setText:editController.m_itemClassroomTextField.text];
    
    UIImage *image              = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_LessonBox_Format,     [m_faceItem.m_lnThemeID intValue]]];
    UIImage *imgHomeworkNone    = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_Homework_None_Format, [m_faceItem.m_hwThemeID intValue]]];
    UIImage *imgHomeworkHave    = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_Homework_Have_Format, [m_faceItem.m_hwThemeID intValue]]];
    [m_lastTappedButton setBackgroundImage:image forState:UIControlStateNormal];
    [m_lastTappedBoxIV setImage:[self getHomeWorkImage:imgHomeworkNone imagehw:imgHomeworkHave matrixItem:matrixItem]];
}

-(void)updateModel:(YZZMatrixItem *)matrixItem And: (YZZLesson *)lesson By: (YZZLessonEditingVC *)editVC
{
    lesson.m_title          = [editVC.m_cuTitleTextField                text];
    lesson.m_description    = [editVC.m_cuDescriptionTextView           text];
    lesson.m_teacher        = [editVC.m_cuTeacherTextField              text];
    lesson.m_book           = [editVC.m_cuBookTextField                 text];
    [m_curriculum.m_LessonList setObject:lesson forKey:editVC.m_cuTitleTextField.text];

    NSInteger weekType      = [editVC.m_itemWeekTypeSegmentedControl selectedSegmentIndex];
    matrixItem.m_weekType   = [NSNumber numberWithInteger:weekType];
    switch (weekType) {
        case 0:
        {
            matrixItem.m_singleWeekClass        = lesson.m_title;
            matrixItem.m_singleWeekClassroom    = [editVC.m_itemClassroomTextField  text];
            matrixItem.m_singleWeekHomework     = [editVC.m_itemHomeworkTextView    text];
            matrixItem.m_singleWeekRemark       = [editVC.m_itemRemarksTextView     text];
            
            matrixItem.m_doubleWeekClass        = lesson.m_title;
            matrixItem.m_doubleWeekClassroom    = [editVC.m_itemClassroomTextField  text];
            matrixItem.m_doubleWeekHomework     = [editVC.m_itemHomeworkTextView    text];
            matrixItem.m_doubleWeekRemark       = [editVC.m_itemRemarksTextView     text];                  
            break;
        }
        case 1:
        {
            matrixItem.m_singleWeekClass        = lesson.m_title;
            matrixItem.m_singleWeekClassroom    = [editVC.m_itemClassroomTextField  text];
            matrixItem.m_singleWeekHomework     = [editVC.m_itemHomeworkTextView    text];
            matrixItem.m_singleWeekRemark       = [editVC.m_itemRemarksTextView     text];
            break;
        }
        case 2:
        {
            matrixItem.m_doubleWeekClass        = lesson.m_title;
            matrixItem.m_doubleWeekClassroom    = [editVC.m_itemClassroomTextField  text];
            matrixItem.m_doubleWeekHomework     = [editVC.m_itemHomeworkTextView    text];
            matrixItem.m_doubleWeekRemark       = [editVC.m_itemRemarksTextView     text];
            break;
        }
        default:
        {
            //
        }
    }
    [self updateLessonList];
    [m_curriculum Save];
}

- (void)updateLessonList
{
    NSMutableDictionary * unusedLessons = [[NSMutableDictionary alloc] init];
    
    for (id lessonKey in m_curriculum.m_LessonList) {
        YZZLesson *lesson = [m_curriculum.m_LessonList objectForKey:lessonKey];
        BOOL notFound = TRUE;
        for (id matrixItemKey in m_curriculum.m_MatrixList)
        {
            YZZMatrixItem *item = [m_curriculum.m_MatrixList objectForKey:matrixItemKey];
            if (item == nil) continue;
            if ((0 == [item.m_singleWeekClass compare:lesson.m_title]) || (0 == [item.m_doubleWeekClass compare:lesson.m_title]))
                notFound = FALSE;
        }
        if (notFound) [unusedLessons setObject:lesson forKey:lessonKey]; 
    }
    
    for (id lessonKey in unusedLessons) {
        [m_curriculum.m_LessonList removeObjectForKey:lessonKey];
    }
    
}

#pragma mark - text field协议实现函数，课程名编辑完后会调用

- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    if (textField.tag == 1) { // title
        [m_lastTappedLessonLabel setText:[textField text]];
    } else if (textField.tag == 2) { // classroom
        [m_lastTappedCuRoomLabel setText:[textField text]];
    }
    NSUInteger iKey = m_lastTappedButton.tag;
    YZZMatrixItem * matrixItem = [m_curriculum getMatrixItem:iKey]; 
    UIImage *imgHomeworkNone = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_Homework_None_Format,[m_faceItem.m_hwThemeID intValue]]];
    UIImage *imgHomeworkHave = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_Homework_Have_Format,[m_faceItem.m_hwThemeID intValue]]];    
    [m_lastTappedBoxIV setImage:[self getHomeWorkImage:imgHomeworkNone imagehw:imgHomeworkHave matrixItem:matrixItem]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - navigation bar 上按钮的IBAction

- (IBAction)WeekChanged:(id)sender
{
    UISegmentedControl * segControl = (UISegmentedControl *)sender;
    NSInteger weekType = [segControl selectedSegmentIndex] + 1; 
    if ([m_faceItem.m_curweek intValue] == weekType) return;
    
    m_faceItem.m_curweek = [NSNumber numberWithInt:weekType];
    
    UIImage *image = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_LessonBox_Format,[m_faceItem.m_lnThemeID intValue]]];

    UIImage *imgHomeworkNone = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_Homework_None_Format,[m_faceItem.m_hwThemeID intValue]]];
    UIImage *imgHomeworkHave = [UIImage imageNamed:[[NSString alloc] initWithFormat:kTheme_Homework_Have_Format,[m_faceItem.m_hwThemeID intValue]]];
    
    for (id key in m_dicItemButton) {
        UIButton    * button        = [m_dicItemButton          objectForKey:key];
        UILabel     * label         = [m_dicItemTitleLabel      objectForKey:key];
        UILabel     * roomlabel     = [m_dicItemClassroomLabel  objectForKey:key];
        UIImageView * homeworkIV    = [m_dicItemHomeworkIV      objectForKey:key];
        NSUInteger iKey = button.tag;
        YZZMatrixItem * matrixItem = [m_curriculum getMatrixItem:iKey];
        if (2 == [m_faceItem.m_curweek intValue])
        {
            [label setText:matrixItem.m_doubleWeekClass];
            [roomlabel setText:matrixItem.m_doubleWeekClassroom];
        }
        else
        {
            [label setText:matrixItem.m_singleWeekClass];
            [roomlabel setText:matrixItem.m_singleWeekClassroom];
        }
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [homeworkIV setImage:[self getHomeWorkImage:imgHomeworkNone imagehw:imgHomeworkHave matrixItem:matrixItem]];
    }
    
    YZZLessonEditingVC *editController = (YZZLessonEditingVC *)[m_classEditPopoverController contentViewController];
           
    if (2 == weekType)
    {
        [editController.m_itemWeekTypeSegmentedControl setEnabled:NO forSegmentAtIndex:1];    
        [editController.m_itemWeekTypeSegmentedControl setEnabled:YES forSegmentAtIndex:2];
    }
    else
    {
        [editController.m_itemWeekTypeSegmentedControl setEnabled:YES forSegmentAtIndex:1];    
        [editController.m_itemWeekTypeSegmentedControl setEnabled:NO forSegmentAtIndex:2];        
    }
    
    [m_mainDelegate SaveCurriculum: self];
}

- (IBAction)EditCurriculumTitle:(id)sender
{
    [m_titleTextField singleButtonDoubleTaps:nil];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
{
    [m_titleTextField singleButtonDoubleTaps:nil];
}

- (void)Rename:(NSString *)newName
{
    if ([m_mainDelegate CurriculumExist:newName])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重命名失败" 
                                                        message:[[NSString alloc] initWithFormat:@"课程表名 %@ 已存在",newName] 
                                                       delegate:self 
                                              cancelButtonTitle:@"取消" 
                                              otherButtonTitles:nil];    
        [alert show];
        [m_titleTextField setText:m_faceItem.m_title];
        return;
    }
    
    if (0 == [[YZZUtilities trim:newName] compare:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重命名失败" 
                                                        message:@"课程表名不能空白"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles: nil];    
        [alert show];
        [m_titleTextField setText:m_faceItem.m_title];
        return;
    }

    NSString * oldName = m_faceItem.m_title;
    m_faceItem.m_title = newName;

    [m_curriculum Rename:oldName name:newName];
    
    [m_mainDelegate RenameCurriculum:self OldName:oldName];
    
    [m_mainDelegate Refresh];
}

// 标题修改后会调用此函数
-(void)EditFinished:(YZZTitleTextField *)doubleTaps
{
    if (0 == [m_faceItem.m_title compare:doubleTaps.m_title]) // 如果文件名没变，则啥都不做
    {
        return;
    }
        
    NSString * oldLessonFile = [self LessonFile];
    NSString * oldMatrixFile = [self CurriculumFile];    
    
    [self Rename:doubleTaps.m_title];
        
    NSString * newLessonFile = [self LessonFile];
    NSString * newMatrixFile = [self CurriculumFile];
    
    [m_curriculum Rename:oldLessonFile name:newLessonFile];
    [m_curriculum Rename:oldMatrixFile name:newMatrixFile];
    [m_mainDelegate Refresh];
}

- (IBAction)SelectTheme:(id)sender
{
    YZZThemeVC * themeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YZZThemeVC"]; 
    themeVC.m_curriculumVC      = self;
    themeVC.m_mainDelegate      = self;
    themeVC.m_backgroundThemeID = [m_faceItem.m_bgThemeID intValue];
    themeVC.m_lessonThemeID     = [m_faceItem.m_lnThemeID intValue];
    themeVC.m_homeworkThemeID   = [m_faceItem.m_hwThemeID intValue];
        
    [self.navigationController pushViewController:themeVC animated:YES];
}

#pragma mark - degelate 

-(void)Refresh
{
    [[m_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self InitDataModel];
    [self ShowCurriculum];
    [m_mainDelegate SaveCurriculum:self];
    [m_mainDelegate Refresh];
}

@end
