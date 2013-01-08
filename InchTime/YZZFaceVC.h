//
//  YZZFaceVC.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-3.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZZThemeVC.h"
#import "YZZFaceItemButton.h"
#import "YZZAboutVC.h"

#import "YZZFace.h"

@interface YZZFaceVC : UIViewController <CInchTimeMainControllerDelegate, YZZFaceItemButtonDelegate, AboutViewDelegate>

@property (nonatomic, strong) YZZFace       * m_face;
@property (nonatomic, strong) YZZCurriculum * m_curr;
@property (nonatomic, strong) IBOutlet UIScrollView * m_scrollView;

- (void)Load;
- (void)Show;
- (void)Refresh;

- (void)Open:(id)sender;
- (void)Create:(YZZCurriculumVC *)currVC;
- (void)Delete:(YZZFaceItemButton *)button; //// delegate

@end
