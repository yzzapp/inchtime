//
//  YZZAboutVC.h
//  DesignColumn
//
//  Created by 暂时还没对象的高级工程师老王 on 11-12-6.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2011年 北京云指针科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class YZZAboutVC;

@protocol AboutViewDelegate <NSObject>

- (void)CloseAboutView:(YZZAboutVC *)aboutVC;

@end


@interface YZZAboutVC : UIViewController <UITextViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) id <AboutViewDelegate> delegate;

- (IBAction)NavHomepage:    (id)sender;
- (IBAction)MailtoYZZ:      (id)sender;
- (IBAction)Close:          (id)sender;

@end
