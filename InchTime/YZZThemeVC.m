//
//  YZZThemeVC.m
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-3.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YZZThemeVC.h"
#import "YZZThemeHeader.h"

#define kTheme_STOREKIT_KEYNAME     @"InchtimeThemes"
#define kTheme_STOREKIT_KEYVALUE    @"THEME_ACTIVE_PAY0513A"

@implementation YZZThemeVC
@synthesize m_scrollViewArray;
@synthesize m_bgScrollView;
@synthesize m_boxScrollView;
@synthesize m_hwScrollView;

@synthesize m_backgroundThemeID;
@synthesize m_lessonThemeID;
@synthesize m_homeworkThemeID;

@synthesize m_mainDelegate;
@synthesize m_curriculumVC;

@synthesize m_storekit_ThemePaid;
@synthesize m_response;
@synthesize payButton;
@synthesize themeDescLabel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_storekit_ThemePaid = NO;
    NSString * paid = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kTheme_STOREKIT_KEYNAME];
    if ([paid isEqualToString:kTheme_STOREKIT_KEYVALUE]) {
        m_storekit_ThemePaid = YES;
    }
    
    [self readThemePaid];
    
    [self showTheme];
    [self InitNavigationBar];
}

- (void)viewDidUnload
{
    m_scrollViewArray   = nil;
    m_bgScrollView      = nil;
    m_boxScrollView     = nil;
    m_hwScrollView      = nil;
        
    m_backgroundThemeID = 0;
    m_lessonThemeID     = 0;
    m_homeworkThemeID   = 0;
    
    m_mainDelegate      = nil;
    m_curriculumVC      = nil;
    
    m_response          = nil;
    
    [self setThemeDescLabel:nil];
    [self setPayButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - loading paements

- (void)readThemePaid
{
    if (m_storekit_ThemePaid == YES) {
        themeDescLabel.hidden   = YES;
        payButton.hidden        = YES;
        return;
    }
    
    themeDescLabel.hidden   = NO;
    payButton.hidden        = NO;

    
    [payButton setEnabled:NO];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    if (![SKPaymentQueue canMakePayments]) {
        payButton.hidden        = YES;
        themeDescLabel.hidden   = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                        message:@"当前内付功能关闭\n[设置]-[访问限制]-[应用程序内购买]\n请您开启开关后，重启本软件"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        payButton.hidden        = NO;
        themeDescLabel.hidden   = NO;
    }
    [self loadThemeProducts];
}

- (void)loadThemeProducts
{
    NSSet *potentialProducts = [NSSet setWithObject:@"com.fourcherry.inchtime.themes"];
    SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:potentialProducts];
    productRequest.delegate = self;
    [productRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    m_response = response;
    for (SKProduct * aProduct in m_response.products) {
        themeDescLabel.text = [[NSString alloc] initWithFormat:@"[%@(%@%@)]%@",
                               aProduct.localizedTitle,
                               [aProduct.priceLocale objectForKey:NSLocaleCurrencySymbol],
                               aProduct.price.stringValue,
                               aProduct.localizedDescription];
        [payButton setEnabled:YES];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    //log error;
}

- (IBAction)PayTheme:(id)sender
{
    for (SKProduct * aProduct in m_response.products) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[[NSString alloc] initWithFormat:@"购买%@",aProduct.localizedTitle]
                                                         message:[[NSString alloc] initWithFormat:@"%@(%@%@)",
                                                                  aProduct.localizedDescription,
                                                                  [aProduct.priceLocale objectForKey:NSLocaleCurrencySymbol],
                                                                  aProduct.price.stringValue]
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"购买",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self sendPayment];
    }
}

- (void)sendPayment
{
    SKProduct * selectedProduct = [[m_response products] objectAtIndex:0];
    SKPayment * payRequest      = [SKPayment paymentWithProduct:selectedProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payRequest];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    for (SKPaymentTransaction * aTransaction in transactions)
    {
        switch (aTransaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:aTransaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:aTransaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:aTransaction];
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)aTransac
{
    [self storePruchasedItems];
    [self ProvideThemes];
    [[SKPaymentQueue defaultQueue] finishTransaction:aTransac];
}

- (void)restoreTransaction:(SKPaymentTransaction *)aTransac
{
    [self storePruchasedItems];
    [self ProvideThemes];
    [[SKPaymentQueue defaultQueue] finishTransaction:aTransac];
}

- (void)failedTransaction:(SKPaymentTransaction *)aTransac
{
    [[SKPaymentQueue defaultQueue] finishTransaction:aTransac];
}

- (void)ProvideThemes
{
    payButton.hidden        = YES;
    themeDescLabel.hidden   = YES;
    [self showScrollView:0 count:kTheme_Background_Count btnSize:CGSizeMake(186, kTheme_Backgound_ButtonHeight)];
    [self showScrollView:1 count:kTheme_LessonBox_Count  btnSize:CGSizeMake(186, kTheme_LessonBox_ButtonHeight)];
    [self showScrollView:2 count:kTheme_Homework_Count   btnSize:CGSizeMake(128, kTheme_Homeworks_ButtonHeight)];
}

- (void)showScrollView:(int)index count:(NSInteger)count btnSize:(CGSize)btnSize

{
    UIScrollView *scrollView = [m_scrollViewArray objectAtIndex:index];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, count * btnSize.height * 1.5)];
    for (int i = 3 ; i <= count ; i++) {
        UIButton *button = [[scrollView subviews] objectAtIndex:i];
        button.hidden = NO;
    }
}
     
- (void)storePruchasedItems
{
    m_storekit_ThemePaid = YES;
    [[NSUserDefaults standardUserDefaults] setObject:kTheme_STOREKIT_KEYVALUE forKey:kTheme_STOREKIT_KEYNAME];
}

#pragma mark - theme

- (void)showTheme
{
    m_scrollViewArray = [[NSMutableArray alloc] initWithCapacity:3];
    [m_scrollViewArray addObject:m_bgScrollView];
    [m_scrollViewArray addObject:m_boxScrollView];
    [m_scrollViewArray addObject:m_hwScrollView];
    
    [self initScrollView:0 count:kTheme_Background_Count    btnSize:CGSizeMake(186, kTheme_Backgound_ButtonHeight)];
    [self initScrollView:1 count:kTheme_LessonBox_Count     btnSize:CGSizeMake(186, kTheme_LessonBox_ButtonHeight)];
    [self initScrollView:2 count:kTheme_Homework_Count      btnSize:CGSizeMake(128, kTheme_Homeworks_ButtonHeight)];
}

- (void)initScrollView:(int)index count:(NSInteger)count btnSize:(CGSize)btnSize
{
    int limite_LITE = 2;

    UIScrollView *scrollView = [m_scrollViewArray objectAtIndex:index];
    if (m_storekit_ThemePaid == YES) 
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, count * btnSize.height * 1.5)];
    else
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, limite_LITE * btnSize.height * 1.5)];

    scrollView.showsVerticalScrollIndicator = NO;
    
    for (int i = 1 ; i <= count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0,
                                    kTheme_StartPointY + (i-1) * btnSize.height * 1.4,
                                    btnSize.width,
                                    btnSize.height)];
        NSString *imageFormat = [[NSString alloc] init];
        switch (index) {
            case 0:
                [button addTarget:self action:@selector(selectBackground:)  forControlEvents:UIControlEventTouchUpInside];
                imageFormat = kTheme_Backgound_Format;
                if (m_storekit_ThemePaid == YES)
                    limite_LITE = kTheme_Background_Count;
                else
                    limite_LITE = kTheme_StoreKit_BG_LITE;
                break;
            case 1:
                [button addTarget:self action:@selector(selectLessonBox:)   forControlEvents:UIControlEventTouchUpInside];
                imageFormat = kTheme_LessonBox_Format;
                if (m_storekit_ThemePaid == YES)
                    limite_LITE = kTheme_LessonBox_Count;
                else
                    limite_LITE = kTheme_StoreKit_LN_LITE;
                break;
            case 2:
                [button addTarget:self action:@selector(selectHomework:)    forControlEvents:UIControlEventTouchUpInside];
                imageFormat = kTheme_Homework_None_Format;
                if (m_storekit_ThemePaid == YES)
                    limite_LITE = kTheme_Homework_Count;
                else
                    limite_LITE = kTheme_StoreKit_HW_LITE;
                break;
            default: break;
        }
        
        UIImage *buttonImage = [UIImage imageNamed:[[NSString alloc] initWithFormat:imageFormat,i]];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setTag:i];
        [button.layer setShadowRadius:5];
        [button.layer setShadowOffset:CGSizeMake(3, 5)];
        [button.layer setShadowOpacity:0.8];
        [button.layer setShadowColor:[UIColor blackColor].CGColor];
        
        if (m_storekit_ThemePaid == NO && i > limite_LITE) 
            button.hidden = YES;
        else 
            button.hidden = NO;
        [scrollView addSubview:button];
    }
    
    int themeID;
    switch (index) {
        case 0: themeID = m_backgroundThemeID;  break;
        case 1: themeID = m_lessonThemeID;      break;
        case 2: themeID = m_homeworkThemeID;    break;
        default: break;
    }
    
    UIImageView *starIV   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
    [starIV setFrame:CGRectMake(btnSize.width - 34 ,
                                kTheme_StartPointY + (themeID - 1 ) * btnSize.height * 1.4 + btnSize.height - 34 ,
                                32,
                                32)];
    starIV.tag = kDefault_StarTag;
    [scrollView addSubview:starIV];
}

- (void)selectBackground:(id)sender 
{
    UIButton *thisButton = (UIButton *)sender;
    m_backgroundThemeID = thisButton.tag;
    UIImageView *starIV;
    starIV = (UIImageView *)[[m_bgScrollView subviews] objectAtIndex:(kTheme_Background_Count + 1)];
    [starIV setFrame:CGRectMake(thisButton.frame.origin.x + thisButton.frame.size.width - 32,
                                thisButton.frame.origin.y + thisButton.frame.size.height - 32,
                                32,
                                32)];
}

- (void)selectLessonBox:(id)sender
{
    UIButton *thisButton = (UIButton *)sender;
    m_lessonThemeID = thisButton.tag;
    UIImageView *starIV;
    starIV = (UIImageView *)[[m_boxScrollView subviews] objectAtIndex:(kTheme_LessonBox_Count + 1)];
    [starIV setFrame:CGRectMake(thisButton.frame.origin.x + thisButton.frame.size.width - 32,
                                thisButton.frame.origin.y + thisButton.frame.size.height - 32,
                                32,
                                32)];
}

- (void)selectHomework:(id)sender
{
    UIButton *thisButton = (UIButton *)sender;
    m_homeworkThemeID = thisButton.tag;
    UIImageView *starIV;
    starIV = (UIImageView *)[[m_hwScrollView subviews] objectAtIndex:(kTheme_Homework_Count + 1)];
    [starIV setFrame:CGRectMake(thisButton.frame.origin.x + thisButton.frame.size.width - 32,
                                thisButton.frame.origin.y + thisButton.frame.size.height - 32,
                                32,
                                32)];
}

#pragma mark - nav & IBAction

- (void)InitNavigationBar
{   
    //  < toFace ......... save refreshoffset
    NSMutableArray *itemButtons = [[NSMutableArray alloc] initWithCapacity:2];
    UIBarButtonItem *saveThemeButton        = [[UIBarButtonItem alloc] initWithTitle:@"确定" 
                                                                               style:UIBarButtonItemStyleBordered 
                                                                              target:self 
                                                                              action:@selector(SaveTheme)];
    UIBarButtonItem *refreshOffsetButton    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                            target:self 
                                                                                            action:@selector(RefreshOffset)];
    
    [itemButtons addObject:refreshOffsetButton];
    [itemButtons addObject:saveThemeButton];
    self.navigationItem.rightBarButtonItems = itemButtons;
}

- (IBAction)SaveTheme
{
    // 课程列表界面->课程表->主题选择
    m_curriculumVC.m_faceItem.m_bgThemeID = [NSNumber numberWithInt:m_backgroundThemeID];
    m_curriculumVC.m_faceItem.m_lnThemeID = [NSNumber numberWithInt:m_lessonThemeID];
    m_curriculumVC.m_faceItem.m_hwThemeID = [NSNumber numberWithInt:m_homeworkThemeID];
    [m_mainDelegate Refresh];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)RefreshOffset
{    
    int offsetBg = kTheme_StartPointY + (m_backgroundThemeID - 1) * kTheme_Backgound_ButtonHeight * 1.4;
    int offsetLn = kTheme_StartPointY + (m_lessonThemeID     - 1) * kTheme_LessonBox_ButtonHeight * 1.4;
    int offsetHw = kTheme_StartPointY + (m_homeworkThemeID   - 1) * kTheme_Homeworks_ButtonHeight * 1.4;
    offsetBg = offsetBg <= 300 ? offsetBg : (offsetBg - 200);
    offsetLn = offsetLn <= 300 ? offsetLn : (offsetLn - 200);
    offsetHw = offsetHw <= 300 ? offsetHw : (offsetHw - 200);
    
    CGPoint offsetLenth;
    int scrollCount = 3;
    for (int i = 0; i < scrollCount; i++)
    {
        switch (i) {
            case 0:  offsetLenth = CGPointMake(0, offsetBg); break;
            case 1:  offsetLenth = CGPointMake(0, offsetLn); break;
            case 2:  offsetLenth = CGPointMake(0, offsetHw); break;
            default: offsetLenth = CGPointMake(0, 0);        break;
        }
        UIScrollView * scrollView = [m_scrollViewArray objectAtIndex:i];
        [UIScrollView animateWithDuration:1.0f 
                               delay:0 
                               options:UIViewAnimationCurveLinear
                               animations:^{ scrollView.contentOffset = CGPointMake(0, 0); }
                               completion:^( BOOL finished){} ];
        [scrollView setContentOffset:offsetLenth animated:YES];
    }
}

- (IBAction)Cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
