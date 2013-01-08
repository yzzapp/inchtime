//
//  YZZAboutVC.m
//  DesignColumn
//
//  Created by 暂时还没对象的高级工程师老王 on 11-12-6.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2011年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZAboutVC.h"

@implementation YZZAboutVC
@synthesize delegate;

- (void)viewDidUnload
{
    [super viewDidUnload];
    delegate = nil;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)NavHomepage:(id)sender {
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:@"http://site.douban.com/129642/"]];
}

- (IBAction)MailtoYZZ:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailSender = [[MFMailComposeViewController alloc]init];
        
        [mailSender setSubject:@"寸光阴课程表(inchtime) 反馈"];
        [mailSender setMessageBody:@"To 云指针：<br /> <br/>" isHTML:YES];
        [mailSender setToRecipients:[[NSArray alloc]initWithObjects: @"yunzhizhen@vip.163.com", nil]];
        [mailSender setCcRecipients:[[NSArray alloc]initWithObjects: @"wangyunpeng_pro@163.com", nil]];
        
        mailSender.mailComposeDelegate = self;
        mailSender.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        [mailSender setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [mailSender setModalPresentationStyle:UIModalPresentationFormSheet];
        
        [self presentModalViewController:mailSender animated:YES];
    }
}

- (IBAction)Close:(id)sender 
{
    [delegate CloseAboutView:self];
}

#pragma mark - Implement MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:       [self alertWithTitle:nil msg:@"邮件发送成功"]; break;
        case MFMailComposeResultSaved:      [self alertWithTitle:nil msg:@"邮件保存成功"]; break;
        case MFMailComposeResultFailed:     [self alertWithTitle:nil msg:@"邮件发送失败"]; break;
        case MFMailComposeResultCancelled:  break;
        default: break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)alertWithTitle:(NSString *)_title_ msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_ 
                                                    message:msg 
                                                   delegate:nil 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil];
    [alert show];
}

@end
