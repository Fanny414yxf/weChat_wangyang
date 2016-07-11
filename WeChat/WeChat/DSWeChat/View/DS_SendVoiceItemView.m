//
//  DS_SendVoiceItemView.m
//  WeChat
//
//  Created by wangyang on 16/7/10.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_SendVoiceItemView.h"

CGFloat const KSendVoiceItemViewWidth = 180.f;
CGFloat const KSendVoiceItemViewHeight = 180.f;
@interface DS_SendVoiceItemView()
@end

@implementation DS_SendVoiceItemView

+ (instancetype)shortVoiceView
{
    DS_SendVoiceItemView *item = ({
        DS_SendVoiceItemView *item = [[DS_SendVoiceItemView alloc] init];
        item.backgroundColor = [UIColor colorWithRed:224/255. green:224/255. blue:242/255. alpha:0.6];
        item;
    });
    UILabel *label = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = DS_CustomLocalizedString(@"Message too short", @"");
        CGFloat x = 10;
        CGFloat h = 18;
        CGFloat y = KSendVoiceItemViewWidth - h - 10;
        CGFloat w = KSendVoiceItemViewWidth - 2 * x;
        label.frame = (CGRect){x,y,w,h};
        label;
    });
    [item addSubview:label];
    return item;
}

+ (instancetype)sendVoiceView
{
    DS_SendVoiceItemView *item = ({
        DS_SendVoiceItemView *item = [[DS_SendVoiceItemView alloc] init];
        item.backgroundColor = [UIColor colorWithRed:224/255. green:224/255. blue:242/255. alpha:0.6];
        item;
    });
    UILabel *label = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = DS_CustomLocalizedString(@"Slide up to cancel", @"");
        CGFloat x = 10;
        CGFloat h = 18;
        CGFloat y = KSendVoiceItemViewWidth - h - 10;
        CGFloat w = KSendVoiceItemViewWidth - 2 * x;
        label.frame = (CGRect){x,y,w,h};
        label;
    });
    [item addSubview:label];
    return item;
}

+ (instancetype)cancelVoiceView
{
    DS_SendVoiceItemView *item = ({
        DS_SendVoiceItemView *item = [[DS_SendVoiceItemView alloc] init];
        item.backgroundColor = [UIColor colorWithRed:224/255. green:224/255. blue:242/255. alpha:0.6];
        item;
    });
    UILabel *label = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3.;
        label.text = DS_CustomLocalizedString(@"Release to cancel", @"");
        CGFloat x = 10;
        CGFloat h = 18;
        CGFloat y = KSendVoiceItemViewWidth - h - 10;
        CGFloat w = KSendVoiceItemViewWidth - 2 * x;
        label.frame = (CGRect){x,y,w,h};
        label;
    });
    [item addSubview:label];
    return item;
}

@end
