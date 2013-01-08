//
//  YZZLessonEditingVC.m
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-7.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZLessonEditingVC.h"

@implementation YZZLessonEditingVC
@synthesize m_cuTitleTextField;
@synthesize m_cuDescriptionTextView;
@synthesize m_cuTeacherTextField;
@synthesize m_cuBookTextField;
@synthesize m_itemWeekTypeSegmentedControl;
@synthesize m_itemClassroomTextField;
@synthesize m_itemHomeworkTextView;
@synthesize m_itemRemarksTextView;

@synthesize m_Delegate;
@synthesize m_ClassInfoDic;
@synthesize m_lessonDropdownPopoverController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    YZZLessonDropdownVC * classChooseController = [self.storyboard instantiateViewControllerWithIdentifier:@"CInchTimeClassChooseController"]; 
    m_lessonDropdownPopoverController = [[UIPopoverController alloc]initWithContentViewController:classChooseController];
	m_lessonDropdownPopoverController.popoverContentSize = CGSizeMake(248., 300.);
	m_lessonDropdownPopoverController.delegate = self;
    classChooseController.m_popoverDelegate = self;
    classChooseController.m_LessonList = [m_ClassInfoDic allKeys];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    m_cuTitleTextField              = nil;
    m_cuDescriptionTextView         = nil;
    m_cuTeacherTextField            = nil;
    m_cuBookTextField               = nil;
    m_itemWeekTypeSegmentedControl  = nil;
    m_itemClassroomTextField        = nil;
    m_itemHomeworkTextView          = nil;
    m_itemRemarksTextView           = nil;
    
    m_Delegate = nil;
    m_lessonDropdownPopoverController = nil;
    m_ClassInfoDic = nil;

    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source & delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    [m_Delegate textFieldDidEndEditing: textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [m_Delegate textFieldShouldReturn: textField];
    // [m_lastTappedButton setTitle:[textField text] forState:UIControlStateNormal];     
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // CInchTimeClassChooseController * classChooseController = (CInchTimeClassChooseController *)[m_classChoosePopoverController contentViewController];                
}

- (IBAction)ShowClassChoosePopover:(id)sender
{     
    UIButton * button = (UIButton *)sender;
    [m_lessonDropdownPopoverController presentPopoverFromRect:CGRectMake(button.frame.origin.x, 
                                                                         button.frame.origin.y + (button.frame.size.height), 
                                                                         button.frame.size.width, 
                                                                         button.frame.size.height)
                                                       inView:self.tableView
                                     permittedArrowDirections:UIPopoverArrowDirectionUp
                                                     animated:YES];
}

-(void)Selected:(YZZLessonDropdownVC *)controller
{
    [m_cuTitleTextField setText:controller.m_selectedLesson];
    [m_Delegate textFieldDidEndEditing:m_cuTitleTextField];    
    YZZLesson * curriculum = [m_ClassInfoDic objectForKey:controller.m_selectedLesson];
    [self ConfigEditController: curriculum];
    [m_lessonDropdownPopoverController dismissPopoverAnimated:YES];
    // 配置剩余信息
}

- (void)PrepareDropdown:(NSMutableDictionary *)lessonDic
{
    m_ClassInfoDic = lessonDic;
    
    if (nil != m_lessonDropdownPopoverController)
    {
        YZZLessonDropdownVC * classChooseController = (YZZLessonDropdownVC *)[m_lessonDropdownPopoverController contentViewController];        
        classChooseController.m_LessonList = [m_ClassInfoDic allKeys];
        [classChooseController.tableView reloadData];
    }
}

- (void)ConfigEditController:(YZZLesson *)lesson
{
    self.m_cuTitleTextField.text        = @"";
    self.m_cuDescriptionTextView.text   = @"";
    self.m_cuTeacherTextField.text      = @"";
    self.m_cuBookTextField.text         = @"";
    
    self.m_cuTitleTextField.text        = lesson.m_title;
    self.m_cuDescriptionTextView.text   = lesson.m_description;
    self.m_cuTeacherTextField.text      = lesson.m_teacher;
    self.m_cuBookTextField.text         = lesson.m_book;
}

@end
