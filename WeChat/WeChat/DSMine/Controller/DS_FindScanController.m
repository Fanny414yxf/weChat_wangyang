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

@interface DS_FindScanController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong)DS_FindScanTypeView *scanTypeView;
//设备属性
@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
@property (strong,nonatomic)NSString *resultStr;

@end

@implementation DS_FindScanController

#pragma mark - life cricle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DS_CustomLocalizedString(@"QR Code", nil);
    [self.view addSubview:self.scanTypeView];
    [self initSweepView];
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
    CGSize size = self.view.bounds.size;
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

#pragma mark -----AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        self.resultStr = metadataObject.stringValue;
        
    }
    
    [_session stopRunning];
//    [self.timer invalidate];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self dismissViewControllerAnimated:YES completion:NULL];
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
@end
