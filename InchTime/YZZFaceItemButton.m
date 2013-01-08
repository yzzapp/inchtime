//
//  YZZFaceItemButton.m
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-6.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZFaceItemButton.h"
#import <QuartzCore/QuartzCore.h>


@implementation YZZFaceItemButton
@synthesize button;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:button];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteMenu:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

// display a menu with a single item to allow the piece's transform to be reset
- (void)showDeleteMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(Delete:)];
        // CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        
        [self becomeFirstResponder];
        [menuController setMenuItems:[NSArray arrayWithObject:deleteMenuItem]];
        // [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
        [menuController setTargetRect:CGRectMake(self.frame.size.width/2, 0, 0, 0) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
        
        pieceForDelete = [gestureRecognizer view];
    }
}

// UIMenuController requires that we can become first responder or it won't display
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)Delete:(UIMenuController *)controller
{
    CGPoint locationInSuperview = [pieceForDelete convertPoint:CGPointMake(CGRectGetMidX(pieceForDelete.bounds), CGRectGetMidY(pieceForDelete.bounds)) toView:[pieceForDelete superview]];
    
    [[pieceForDelete layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    [pieceForDelete setCenter:locationInSuperview];
    
    //[UIView beginAnimations:nil context:nil];
    [pieceForDelete setTransform:CGAffineTransformIdentity];
    //[UIView commitAnimations];
    
    [delegate Delete:self];
}

@end
