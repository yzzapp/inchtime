//
//  YZZTitleTextField.m
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-14.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZTitleTextField.h"

@implementation YZZTitleTextField

@synthesize m_TextField;
@synthesize m_Button;
@synthesize m_title;

@synthesize bIsDetail;
@synthesize bIsDouble;

@synthesize m_editDelegate;

// 1- 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    // 设置textfield
    m_TextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [m_TextField setReturnKeyType:UIReturnKeyDone];
    [m_TextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [m_TextField setTextAlignment:UITextAlignmentCenter];
    [m_TextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [m_TextField setAdjustsFontSizeToFitWidth:YES];    
    [m_TextField setDelegate:self];
    [m_TextField setTextColor:[UIColor whiteColor]];
    [m_TextField setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];  
    
    // 设置按钮
    m_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_Button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [m_Button addTarget:self action:@selector(singleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [m_Button addTarget:self action:@selector(singleButtonDoubleTaps:) forControlEvents:UIControlEventTouchDownRepeat];
    
    // 加入本view
    [self addSubview:m_TextField];
    [self addSubview:m_Button];
    
    return self;
}

#pragma mark - IBAction

-(IBAction)singleButtonPressed:(id)sender
{
    if (!bIsDouble)
    {
        if (bIsDetail)
        {
            bIsDetail = NO;
        } else {
            bIsDetail = YES;
        }
    }
    bIsDouble = NO;
}

-(IBAction)singleButtonDoubleTaps:(id)sender
{
    bIsDouble = YES;    
    m_Button.hidden = YES;
    
    [m_TextField becomeFirstResponder];
}

-(BOOL)editEnd:(UITextField *)textField
{
    m_title = m_TextField.text;
    m_Button.hidden = NO;
    
    [m_editDelegate EditFinished:self];
    return YES;
}

-(void)setText:(NSString *)text
{
    [m_TextField setText:text];
    m_title = text;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_TextField resignFirstResponder]; // 这条语句后，系统会直接调用后面的textFieldDidEndEditing，之后才会执行下面的return YES;
    return YES; // [self editEnd:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self editEnd:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if (range.location >= 20)
    {
        return NO; // return NO to not change text
    } else {
        return YES;    
    }
}

@end
