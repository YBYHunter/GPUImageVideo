//
//  LeafButton.h
//  LeafButton
//
//  Created by Wang on 14-7-16.
//  Copyright (c) 2014年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LeafButtonTypeCamera,
    LeafButtonTypeVideo,
//    LeafButtonTypeRecord//录音
}LeafButtonType;
typedef enum {
    LeafButtonStateNormal,
    LeafButtonStateSelected
}LeafButtonState;
@class LeafButton;
typedef  void(^ClickedBlock)(LeafButton *button);
@interface LeafButton : UIView
@property (nonatomic,assign) LeafButtonType type;
@property (nonatomic,assign) LeafButtonState state;
@property (nonatomic,strong) void (^clickedBlock)(LeafButton *button);
@end
