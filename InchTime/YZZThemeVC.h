//
//  YZZThemeVC.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-3.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CInchTimeMainControllerDelegate.h"
#import "YZZCurriculumVC.h"
#import <StoreKit/StoreKit.h>

@interface YZZThemeVC : UIViewController <SKProductsRequestDelegate, SKRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray        * m_scrollViewArray;
@property (nonatomic, strong) IBOutlet UIScrollView * m_bgScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView * m_boxScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView * m_hwScrollView;

@property (nonatomic) NSInteger m_backgroundThemeID;
@property (nonatomic) NSInteger m_lessonThemeID;
@property (nonatomic) NSInteger m_homeworkThemeID;

@property (nonatomic, weak) id <CInchTimeMainControllerDelegate> m_mainDelegate;
@property (nonatomic, weak) YZZCurriculumVC *m_curriculumVC;

@property (nonatomic)         BOOL                  m_storekit_ThemePaid;
@property (nonatomic, strong) SKProductsResponse *  m_response;

- (IBAction)SaveTheme;
- (IBAction)RefreshOffset;
- (IBAction)Cancel;

- (IBAction)PayTheme:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) IBOutlet UILabel *themeDescLabel;

@end
