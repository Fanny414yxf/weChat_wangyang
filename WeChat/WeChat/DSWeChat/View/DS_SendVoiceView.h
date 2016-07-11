//
//  DS_SendVoiceView.h
//  WeChat
//
//  Created by wangyang on 16/7/10.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SendVoiceViewType) {
    SendVoiceViewTypeShortTime,
    SendVoiceViewTypeSendVoice,
    SendVoiceViewTypeCancelVoice
};

@interface DS_SendVoiceView : UIView

+ (instancetype)instance;
- (void)showVoiceViewType:(SendVoiceViewType)viewType;
- (void)dismiss;

@end
