//
//  DS_SendVoiceView.m
//  WeChat
//
//  Created by wangyang on 16/7/10.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_SendVoiceView.h"
#import "DS_SendVoiceItemView.h"

@interface DS_SendVoiceView ()

@property (nonatomic,strong)DS_SendVoiceItemView *itemView;
@property (nonatomic,strong)UIWindow *window;

@end

@implementation DS_SendVoiceView

+ (instancetype)instance
{
    static dispatch_once_t onceToken;
    
    static DS_SendVoiceView *view = nil;
    dispatch_once(&onceToken, ^{
        view = [self new];
    });
    return view;
}

- (void)showVoiceViewType:(SendVoiceViewType)viewType
{
    if (self.itemView){
        [self.itemView removeFromSuperview];
        self.itemView = nil;
    }
    switch (viewType) {
        case SendVoiceViewTypeShortTime:
            self.itemView = [DS_SendVoiceItemView shortVoiceView];
            break;
        case SendVoiceViewTypeSendVoice:
            self.itemView = [DS_SendVoiceItemView sendVoiceView];
            break;
        case SendVoiceViewTypeCancelVoice:
            self.itemView = [DS_SendVoiceItemView cancelVoiceView];
            break;
            
        default:
            break;
    }
    CGFloat w = KSendVoiceItemViewWidth;
    CGFloat h = KSendVoiceItemViewWidth;
    CGFloat x = (UISCREENWIDTH - w) * 0.5;
    CGFloat y = (UISCREENHEIGHT - h) * 0.5;
    self.itemView.frame = (CGRect){x,y,w,h};
    if (!self.window) {
        self.window = ({
            UIWindow *windows = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            windows.hidden = NO;
            windows.windowLevel = 3000;
            windows.backgroundColor = [UIColor clearColor];
            windows;
        });
    }
    [self.window addSubview:self.itemView];
}

- (void)dismiss
{
    self.window = nil;
    self.itemView = nil;
}
@end
