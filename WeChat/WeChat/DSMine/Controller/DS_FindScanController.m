//
//  DS_FindScanController.m
//  WeChat
//
//  Created by wangyang on 16/6/18.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_FindScanController.h"
#import "DS_FindScanTypeView.h"
#import <AVFoundation/AVFoundation.h>
#import "NSTimer+ScheduleTimer.h"

@interface DS_FindScanController ()<AVCaptureMetadataOutputObjectsDelegate> {
    NSInteger _nums;
    CGRect _originRect;
}

@property (nonatomic,strong)DS_FindScanTypeView *scanTypeView;
//设备属性
@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,strong)NSString *resultStr;

@property (nonatomic,strong)UIImageView *qrCodeImageView;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation DS_FindScanController

#pragma mark - life cricle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DS_CustomLocalizedString(@"QR Code", nil);
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view addSubview:self.scanTypeView];
    [self.view addSubview:self.qrCodeImageView];
    [self.view addSubview:self.lineImageView];
    [self initSweepView];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark ------初始化扫描视图------
-(void)initSweepView
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined)
    {
//        [self initUI];
        //如果设备正常，再初始化扫描相机等控件
        [self setupCamera];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"摄像头权限未开启！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
}

- (void)setupCamera
{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(!_device)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未检测到摄像头！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //限制扫描区域
    CGSize size = CGSizeMake(UISCREENWIDTH, UISCREENHEIGHT - 64 - KFrameSizeHeight);
    CGRect cropRect = self.view.bounds;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,cropRect.origin.x/size.width,cropRect.size.height/fixHeight,cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,(cropRect.origin.x + fixPadding)/fixWidth,cropRect.size.height/size.height,cropRect.size.width/fixWidth);
    }
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    // _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(0,0,UISCREENWIDTH,UISCREENHEIGHT);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    // Start
    [_session startRunning];
}

- (void)lineAnmations
{
    _nums++;
    CGFloat margin = _nums * 3;
    self.lineImageView.frame = CGRectOffset(_originRect, 0,margin);
    if (margin > self.qrCodeImageView.frame.size.height - 6) {
        _nums = 0;
    }
}

#pragma mark -----AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        self.resultStr = metadataObject.stringValue;
        
    }
    
    [_session stopRunning];
    [_timer invalidate];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//设置二维码图片阴影颜色
-(void)setShadowViewWithImageView:(UIImageView *)imgView withImg:(UIImage *)img
{
    imgView.image = img;
    imgView.layer.shadowOffset = CGSizeMake(0, 2);
    imgView.layer.shadowRadius = 2;
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowOpacity = 0.5;
}

#pragma mark - getter
- (DS_FindScanTypeView *)scanTypeView
{
    if (!_scanTypeView) {
        _scanTypeView = [[DS_FindScanTypeView alloc] init];
    }
    return _scanTypeView;
}

- (UIImageView *)qrCodeImageView
{
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrcode_frame.png"]];
        CGFloat w = 280;
        CGFloat x = (UISCREENWIDTH - w)*0.5;
        CGFloat y = 100;
        CGFloat h = 280;
        _qrCodeImageView.frame = CGRectMake(x, y, w, h);
    }
    return _qrCodeImageView;
}

- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrcode_move_line.png"]];
        CGFloat w = 250;
        CGFloat x = (self.qrCodeImageView.frame.size.width - w) * 0.5 + self.qrCodeImageView.frame.origin.x;
        CGFloat y = self.qrCodeImageView.frame.origin.y;
        CGFloat h = 6;
        _lineImageView.frame = CGRectMake(x, y, w, h);
        _originRect = _lineImageView.frame;
        WEAKSELF;
        _timer = [NSTimer scheduledTimerWithTimeInterval:.02 block:^{
            STRONGSELF;
            [strongSelf lineAnmations];
        } repeats:YES];
    }
    return _lineImageView;
}
@end
