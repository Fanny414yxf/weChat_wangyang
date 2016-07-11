//
//  DS_SendVoiceItemView.h
//  WeChat
//
//  Created by wangyang on 16/7/10.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const KSendVoiceItemViewWidth;
extern CGFloat const KSendVoiceItemViewHeight;

@interface DS_SendVoiceItemView : UIView

+ (instancetype)shortVoiceView;
+ (instancetype)sendVoiceView;
+ (instancetype)cancelVoiceView;

@end
