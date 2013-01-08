//
//  YZZFace.h
//  InchTime
//
//  Created by 暂时还没对象的高级工程师老王 on 12-2-5.
//  Updated by 石 戬 on 12-4-15
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZZFaceItem.h"

@interface YZZFace : NSObject

@property (nonatomic, strong) NSMutableArray * m_faceItemList;

- (void)Save;
- (void)Load;
- (void)Rename: (NSString *)originFullFilePath name:(NSString *)destinationFullFilePath;

- (void)Append: (YZZFaceItem *)faceItem;
- (void)Remove: (YZZFaceItem *)faceItem;

@end