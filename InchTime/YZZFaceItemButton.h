//
//  YZZFaceItemButton.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-6.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZZFaceItemButton;

@protocol YZZFaceItemButtonDelegate <NSObject>

-(void)Delete: (YZZFaceItemButton *)button;

@end

@interface YZZFaceItemButton : UIView <UIGestureRecognizerDelegate>
{
    UIView *pieceForDelete;
}

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) id <YZZFaceItemButtonDelegate> delegate;

@end
