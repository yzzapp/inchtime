//
//  YZZTitleTextField.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-14.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZZTitleTextField;

@protocol CDoubleTapTextFieldDelegate <NSObject>

-(void) EditFinished: (YZZTitleTextField *)doubleTaps;

@end

@interface YZZTitleTextField : UIView <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *m_TextField;
@property (strong, nonatomic) UIButton *m_Button;
@property (strong, nonatomic) NSString *m_title;

@property (nonatomic) BOOL bIsDetail;
@property (nonatomic) BOOL bIsDouble;

@property (nonatomic, weak) id <CDoubleTapTextFieldDelegate> m_editDelegate;

-(IBAction)singleButtonPressed:(id)sender;
-(IBAction)singleButtonDoubleTaps:(id)sender;

-(BOOL)editEnd:(UITextField *)textField;
-(void)setText:(NSString *)text;

@end
