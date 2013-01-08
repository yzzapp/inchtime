//
//  YZZFaceVC.m
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-3.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "YZZFaceVC.h"
#import "YZZFace.h"
#import "YZZCurriculum.h"
#import "YZZCurriculumVC.h"

#define kTheme_Backgound_Format         @"theme_bg_0%d.png"
#define kTheme_Backgound_Preview_Format @"theme_bg_0%dp.png"
#define kTheme_LessonBox_Format         @"theme_box_0%d.png"
#define kTheme_Homework_None_Format     @"theme_hw_0%da.png"
#define kTheme_Homework_Have_Format     @"theme_hw_0%db.png"

#define kTheme_Face_Column_Count    4
#define kTheme_Face_StartPointY     110
#define kTheme_Face_IntervalY       80
#define kTheme_Face_Scroll_MaxLen   704

#define kTheme_FaceItem_StartPointX 50
#define kTheme_FaceItem_StartPointY 55
#define kTheme_FaceItem_IntervalX   240
#define kTheme_FaceItem_IntervalY   220
#define kTheme_FaceItem_Width       186
#define kTheme_FaceItem_Height      140
#define kTheme_FaceItem_NameHeight  25
#define kTheme_FaceItem_Box_Offset  30
#define kTheme_FaceItem_Hw_Offset   38

#define kTheme_Matrix_Width         128
#define kTheme_Matrix_Height        58
#define kTheme_MatrixHomework_Size  32

@implementation YZZFaceVC

@synthesize m_face;
@synthesize m_curr;
@synthesize m_scrollView;

- (void)viewDidLoad
{
    [self Load];
    [self Show];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    m_scrollView    = nil;
    m_face          = nil;
    m_curr          = nil;
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
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - main methods

- (void)Load
{
    m_face = [[YZZFace          alloc] init];
    m_curr = [[YZZCurriculum    alloc] init];
    [m_face Load];
    [m_curr Load];
}

- (void)Show
{
    int rowCount    = [m_face.m_faceItemList count] / kTheme_Face_Column_Count;
    int remainCount = [m_face.m_faceItemList count] % kTheme_Face_Column_Count;
    
    float scrollHeight = kTheme_Face_StartPointY + kTheme_FaceItem_Height + (rowCount - 1) * (kTheme_FaceItem_Height + kTheme_Face_IntervalY);    
    
    if (0 != remainCount) scrollHeight += (kTheme_FaceItem_Height + kTheme_Face_IntervalY);
    
    [m_scrollView setContentSize:CGSizeMake(m_scrollView.frame.size.width, scrollHeight)];
    m_scrollView.showsVerticalScrollIndicator = NO;     
    
    for (int col = 1; col <= kTheme_Face_Column_Count; ++col)
    {
        for (int row = 1; row <= rowCount; ++row)
        {
            YZZFaceItemButton *button = [YZZFaceItemButton alloc];
            [self showButton:button column:col row:row];
        }
    }    
    for (int col = 1; col <= remainCount; ++col)
    {
        YZZFaceItemButton *button = [YZZFaceItemButton alloc];        
        [self showButton:button column:col row:(rowCount+1)];        
    }
}

- (void)Open:(id)sender
{     
    YZZCurriculumVC * currVC    = [self.storyboard instantiateViewControllerWithIdentifier:@"Curriculum"];
    currVC.m_faceItem           = [m_face.m_faceItemList objectAtIndex:[(UIButton *)sender tag]];
    currVC.m_mainDelegate       = self;
    [self.navigationController pushViewController:currVC animated:YES];
}

- (void)Create:(YZZCurriculumVC *)currVC
{
    
    NSString * name = [self genCurriculumName];
    
    YZZFaceItem * faceItem = [[YZZFaceItem alloc] init];
    faceItem.m_title        = name;
    faceItem.m_curweek      = [NSNumber numberWithInt:1];
    faceItem.m_bgThemeID    = [NSNumber numberWithInt:1];
    faceItem.m_lnThemeID    = [NSNumber numberWithInt:1];
    faceItem.m_hwThemeID    = [NSNumber numberWithInt:1];
    [m_face Append:faceItem];
    currVC.m_faceItem       = faceItem;
    
    [m_curr Create:name];
    currVC.m_curriculum     = m_curr;
    
    currVC.m_mainDelegate   = self;
}

#pragma mark - more

- (void)showButton:(YZZFaceItemButton *)faceItemButton column:(int)column row:(int)row
{
    int itemIndex = ((row - 1) * kTheme_Face_Column_Count + column -1);
    CGRect buttonRect = CGRectMake(kTheme_FaceItem_StartPointX + (column-1) * kTheme_FaceItem_IntervalX,
                                   kTheme_FaceItem_StartPointY + (row-1)    * kTheme_FaceItem_IntervalY, 
                                   kTheme_FaceItem_Width, 
                                   kTheme_FaceItem_Height);
    faceItemButton = [faceItemButton initWithFrame:buttonRect];
    [faceItemButton setDelegate:self];
    
    UIButton * button = faceItemButton.button;
    [button addTarget:self action:@selector(Open:) forControlEvents:UIControlEventTouchUpInside];
    
    YZZFaceItem *faceItem = [m_face.m_faceItemList objectAtIndex:itemIndex];
    
    NSString *strButtonImage    = (NSString *)[[NSString alloc] initWithFormat:kTheme_Backgound_Preview_Format, [faceItem.m_bgThemeID intValue]];
    NSString *strLessonImage    = (NSString *)[[NSString alloc] initWithFormat:kTheme_LessonBox_Format,         [faceItem.m_lnThemeID intValue]];
    NSString *strHomeworkImage  = (NSString *)[[NSString alloc] initWithFormat:kTheme_Homework_None_Format,     [faceItem.m_hwThemeID intValue]];

    UIImage *buttonImage        = [UIImage imageNamed:strButtonImage];
    UIImage *lessonImage        = [UIImage imageNamed:strLessonImage];
    UIImage *homeworkImage      = [UIImage imageNamed:strHomeworkImage];

    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    UIImageView *lessonIV       = [[UIImageView alloc]  initWithImage:lessonImage];
    UIImageView *homeworkIV     = [[UIImageView alloc]  initWithImage:homeworkImage];
    UILabel     *nameLabel      = [[UILabel alloc]      init];
    
    lessonIV.frame      = CGRectMake(kTheme_FaceItem_StartPointX + (column-1) * kTheme_FaceItem_IntervalX + kTheme_FaceItem_Box_Offset,
                                     kTheme_FaceItem_StartPointY + (row-1)    * kTheme_FaceItem_IntervalY + kTheme_FaceItem_Box_Offset,
                                     kTheme_Matrix_Width,
                                     kTheme_Matrix_Height);
    homeworkIV.frame    = CGRectMake(kTheme_FaceItem_StartPointX + (column-1) * kTheme_FaceItem_IntervalX + kTheme_FaceItem_Hw_Offset,
                                     kTheme_FaceItem_StartPointY + (row-1)    * kTheme_FaceItem_IntervalY + kTheme_FaceItem_Hw_Offset,
                                     kTheme_MatrixHomework_Size, 
                                     kTheme_MatrixHomework_Size);
    nameLabel.frame     = CGRectMake(kTheme_FaceItem_StartPointX + (column-1) * kTheme_FaceItem_IntervalX,
                                     kTheme_FaceItem_StartPointY + (row-1)    * kTheme_FaceItem_IntervalY + kTheme_FaceItem_Height - kTheme_FaceItem_NameHeight,
                                     kTheme_FaceItem_Width,
                                     kTheme_FaceItem_NameHeight);
    
    [faceItemButton.layer setShadowRadius:5];
    [faceItemButton.layer setShadowOffset:CGSizeMake(3, 5)];
    [faceItemButton.layer setShadowOpacity:0.8];            
    [faceItemButton.layer setShadowColor:[UIColor blackColor].CGColor];  
    
    [nameLabel setBackgroundColor:[UIColor blackColor]];
    [nameLabel setAlpha:0.6];
    [nameLabel setText:faceItem.m_title];
    [nameLabel setTextColor:[UIColor whiteColor]];
    
    [faceItemButton setTag:itemIndex];
    [button         setTag:itemIndex];
    
    [m_scrollView addSubview:faceItemButton ];
    [m_scrollView addSubview:lessonIV       ];
    [m_scrollView addSubview:homeworkIV     ];
    [m_scrollView addSubview:nameLabel      ];
}

#pragma mark - segue

- (void)Delete:(YZZFaceItemButton *)button
{
    NSInteger itemID = [button tag];
    YZZFaceItem *item = [m_face.m_faceItemList objectAtIndex: itemID];
    [m_curr Remove:item.m_title];
    [m_face.m_faceItemList removeObject:item];
    [m_face Save];
    
    //效果待调整，暂时设为0秒播放规避。
    [UIScrollView animateWithDuration:0.0f
                                delay:0
                              options:UIViewAnimationCurveLinear
                           animations:^{[self Refresh];}
                           completion:^(BOOL finished ){}];
}

-(void)Refresh
{
    [[m_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self Load];
    [self Show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Curriculum"])
	{
        YZZCurriculumVC * curriculumVC = segue.destinationViewController;
        [self Create:curriculumVC];
        [self Refresh];
	}
    else if ([segue.identifier isEqualToString:@"About"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		YZZAboutVC *about = [[navigationController viewControllers] objectAtIndex:0];
		about.delegate = self;
	}
}

-(NSString *)genCurriculumName
{
    NSDate *date = [[NSDate alloc] init];
    NSString *name = [[NSString alloc] initWithFormat:@"课程表 %d", date];
    return name;
}

#pragma mark - protocol

-(void)SaveCurriculum:(YZZCurriculumVC *) curriculumController
{
    YZZFaceItem *item = [curriculumController GetFaceItem];    
    for (YZZFaceItem * iter in m_face.m_faceItemList)
    {
        if (0 == [iter.m_title compare: item.m_title])
        {
            iter.m_bgThemeID    = item.m_bgThemeID;
            iter.m_lnThemeID    = item.m_lnThemeID;
            iter.m_hwThemeID    = item.m_hwThemeID;
            iter.m_curweek      = item.m_curweek;
            break;
        }
    }
    [m_face Save];
    [UIScrollView animateWithDuration:0.0f
                                delay:0
                              options:UIViewAnimationCurveLinear
                           animations:^{[self Refresh];}
                           completion:^(BOOL finished ){}];
}

-(void)RenameCurriculum:(YZZCurriculumVC *) curriculumController OldName: (NSString *)oldName
{
    YZZFaceItem *item = [curriculumController GetFaceItem];
    for (YZZFaceItem * iter in m_face.m_faceItemList)
    {
        if ([iter.m_title isEqualToString:oldName])
        {
            iter.m_title = item.m_title;
            iter.m_bgThemeID = item.m_bgThemeID;
            iter.m_lnThemeID = item.m_lnThemeID;
            iter.m_hwThemeID = item.m_hwThemeID;
            iter.m_curweek = item.m_curweek;
            break;
        }
    }
    [m_face Save];
    [UIScrollView animateWithDuration:0.0f
                                delay:0
                              options:UIViewAnimationCurveLinear
                           animations:^{[self Refresh];}
                           completion:^(BOOL finished ){}];
}

-(BOOL)CurriculumExist:(NSString *)curriculumName
{
    for (YZZFaceItem * iter in m_face.m_faceItemList)
    {
        if (0 == [iter.m_title compare:curriculumName])
            return YES;
    }
    return NO;
}

#pragma mark - degegate AboutVC

- (void)CloseAboutView:(YZZAboutVC *)aboutVC
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
