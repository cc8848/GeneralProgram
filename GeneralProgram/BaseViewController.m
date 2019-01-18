//
//  BaseViewController.m
//  dzm
//
//  Created by dzmmac on 14-9-25.
//  Copyright (c) 2014年 dzmmac. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>
#import "WSPhotosBroseVC.h"
#import "JFImagePickerController.h"

//获取通讯录
#import "LJContactManager.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>


//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareSheetConfiguration.h>

//支付
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface BaseViewController ()<UIActionSheetDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏设置

    [self.navigationController.navigationBar setTranslucent:NO];


}

- (BOOL)StringIsNullOrEmpty:(NSString *)str
{
    return (str == nil || [str isKindOfClass:[NSNull class]] || str.length == 0 || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"]);
}

-(void)showUIActionSheet:(NSString *)TitleStr cancestr:(NSString *)canceStr otherFirststr:(NSString *)otherFirstStr  otherSecondstr:(NSString *)otherSecondStr sheettag:(NSInteger)sheetTag{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:TitleStr delegate:self cancelButtonTitle:canceStr destructiveButtonTitle:nil otherButtonTitles:otherFirstStr,otherSecondStr, nil];
    sheet.tag = sheetTag;
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1001) {
        if (buttonIndex == 0) {
            [self   selectcreatAction];
        }
        else if (buttonIndex == 1){
            [self selectAction];
        }
        else{
            
        }
    }
    else{
        if (buttonIndex == 0) {
            [self pickImageFromCamera];
        }
        else if (buttonIndex == 1){
            [self pickImageFromAlbum];
        }
        else{
            
        }
    }
    
}

//从相机拍摄视频
- (void)selectcreatAction{
    NSLog(@"从相机拍摄视频");
    dispatch_async(dispatch_get_main_queue(), ^{
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无相机权限，请去设置-隐私中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alertView show];
            return;
        }
        
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        
        picker.delegate=self;
        picker.allowsEditing=NO;
        picker.videoMaximumDuration = 15.0;//视频最长长度
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量
        //媒体类型：@"public.movie" 为视频  @"public.image" 为图片
        //这里只选择展示视频
        picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
        picker.sourceType= UIImagePickerControllerSourceTypeCamera;
        UIViewController *viewController;
        if ([AppDelegate instance].window.rootViewController.presentedViewController!=nil) {
            viewController=[AppDelegate instance].window.rootViewController.presentedViewController;
        }else if ([AppDelegate instance].window.rootViewController.presentingViewController!=nil){
            viewController=[AppDelegate instance].window.rootViewController.presentingViewController ;
        }else{
            viewController=[AppDelegate instance].window.rootViewController ;
        }
        [viewController presentViewController:picker animated:NO completion:nil];
    });
}

//从相册选择视频
- (void)selectAction{
    NSLog(@"从相册选择视频");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无相册权限，请去设置-隐私中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alertView show];
            return;
        }
        
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        
        picker.delegate=self;
        picker.allowsEditing=NO;
        picker.videoMaximumDuration = 15.0;//视频最长长度
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量
        //媒体类型：@"public.movie" 为视频  @"public.image" 为图片
        //这里只选择展示视频
        picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
        picker.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        UIViewController *viewController;
        if ([AppDelegate instance].window.rootViewController.presentedViewController!=nil) {
            viewController=[AppDelegate instance].window.rootViewController.presentedViewController;
        }else if ([AppDelegate instance].window.rootViewController.presentingViewController!=nil){
            viewController=[AppDelegate instance].window.rootViewController.presentingViewController ;
        }else{
            viewController=[AppDelegate instance].window.rootViewController ;
        }
        [viewController presentViewController:picker animated:NO completion:nil];
    });
}

// 相机拍照片
- (void)pickImageFromCamera{
    dispatch_async(dispatch_get_main_queue(), ^{
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无相机权限，请去设置-隐私中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alertView show];
            return;
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = NO;
        //    imagePicker.showsCameraControls = YES;
        UIViewController *viewController;
        if ([AppDelegate instance].window.rootViewController.presentedViewController!=nil) {
            viewController=[AppDelegate instance].window.rootViewController.presentedViewController;
        }else if ([AppDelegate instance].window.rootViewController.presentingViewController!=nil){
            viewController=[AppDelegate instance].window.rootViewController.presentingViewController ;
        }else{
            viewController=[AppDelegate instance].window.rootViewController ;
        }
        [viewController presentViewController:imagePicker animated:NO completion:nil];
    });
}

// 相册选取图片
- (void)pickImageFromAlbum{
    dispatch_async(dispatch_get_main_queue(), ^{
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无相册权限，请去设置-隐私中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alertView show];
            return;
        }
        //限制最多选择数量
        NSInteger count = 1;
        [JFImagePickerController setMaxCount:count];
        JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[UIViewController new]];
        picker.pickerDelegate = self;
        UIViewController *viewController;
        if ([AppDelegate instance].window.rootViewController.presentedViewController!=nil) {
            viewController=[AppDelegate instance].window.rootViewController.presentedViewController;
        }else if ([AppDelegate instance].window.rootViewController.presentingViewController!=nil){
            viewController=[AppDelegate instance].window.rootViewController.presentingViewController ;
        }else{
            viewController=[AppDelegate instance].window.rootViewController ;
        }
        [viewController presentViewController:picker animated:NO completion:nil];
    });
}

#pragma mark - JFImagePicker Delegate -

- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    NSMutableArray *arr = [NSMutableArray array];
    
    //    __weak typeof(self)weakSelf = self;
    for (ALAsset *asset in picker.assets) {
        [[JFImageManager sharedManager] imageWithAsset:asset resultHandler:^(CGImageRef imageRef, BOOL longImage) {
            UIImage *images = [UIImage imageWithCGImage:imageRef];
            dispatch_async(dispatch_get_main_queue(), ^{
                [arr addObject:images];
                //        [self calulateImageFileSize:images];
                NSDictionary *dic = [NSDictionary alloc];
                [HTTPRequest uploadMostImageWithURLString:[NSString stringWithFormat:@"%@apiProd/file/file/upload",uploadServer] parameters:dic uploadDatas:arr uploadName:@"file" success:^ (id Json){
                    if (self.HttpjsonBlock) {
                        self.HttpjsonBlock(@"照片", Json);
                    }
                } failure:^( NSError * _Nonnull error) {
                    
                }];
                
            });
        }];
    }
    [self imagePickerDidCancel:picker];
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [JFImagePickerController clear];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
//    __weak typeof(self)weakSelf = self;
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    NSMutableArray *arr = [NSMutableArray array];
    if ([mediaType isEqualToString:@"public.movie"]){
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
        //        NSData *data = [NSData dataWithContentsOfURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        
        AVURLAsset *audioAsset=[AVURLAsset URLAssetWithURL:url options:nil];
        CMTime audioDuration=audioAsset.duration;
        float audioDurationSeconds=CMTimeGetSeconds(audioDuration);
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
            
            if (audioDurationSeconds > 15.0f) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该视频超过了最大限制" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [picker dismissViewControllerAnimated:YES completion:nil];
                return;
            }
        }
        NSLog(@"url %@",url);
        NSDictionary *dic = [NSDictionary alloc];
        [HTTPRequest uploadvideoWithURLString:[NSString stringWithFormat:@"%@apiProd/file/file/upload",uploadServer] parameters:dic uploadDatas:url uploadName:@"file" success:^ (id Json){
            if (self.HttpjsonBlock) {
                self.HttpjsonBlock(@"视频", Json);
            }
        } failure:^( NSError * _Nonnull error) {
            
        }];
    }
    else{
        UIImage *images=[info objectForKey:UIImagePickerControllerOriginalImage];;
        [arr addObject:images];
        //        [self calulateImageFileSize:images];
        NSDictionary *dic = [NSDictionary alloc];
        [HTTPRequest uploadMostImageWithURLString:[NSString stringWithFormat:@"%@apiProd/file/file/upload",uploadServer] parameters:dic uploadDatas:arr uploadName:@"file" success:^ (id Json){
            if (self.HttpjsonBlock) {
                self.HttpjsonBlock(@"照片", Json);
            }
        } failure:^( NSError * _Nonnull error) {
            
        }];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 校验通讯录权限
 */
- (void)checkAddressBookAuth:(void (^)(BOOL auth))result {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusNotDetermined:    //用户还没有选择(第一次)
        {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {  //授权
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result) {
                            result(YES);
                        }
                    });
                }else {         //拒绝
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result) {
                            result(NO);
                        }
                    });
                }
            });
        }
            break;
        case kABAuthorizationStatusRestricted:       //家长控制
        {
            if (result) {
                result(NO);
            }
        }
            break;
        case kABAuthorizationStatusDenied:           //用户拒绝
        {
            if (result) {
                result(NO);
            }
        }
            break;
        case kABAuthorizationStatusAuthorized:       //已授权
        {
            if (result) {
                result(YES);
            }
        }
            break;
        default:
            break;
    }
#else
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusNotDetermined:    //用户还没有选择(第一次)
        {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts
                                   completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                       if (granted) {  //授权
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if (result) {
                                                   result(YES);
                                               }
                                           });
                                       }else {         //拒绝
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if (result) {
                                                   result(NO);
                                               }
                                           });
                                       }
                                   }];
        }
            break;
        case CNAuthorizationStatusRestricted:       //家长控制
        {
            if (result) {
                result(NO);
            }
        }
            break;
        case CNAuthorizationStatusDenied:           //用户拒绝
        {
            if (result) {
                result(NO);
            }
        }
            break;
        case CNAuthorizationStatusAuthorized:       //已授权
        {
            if (result) {
                result(YES);
            }
        }
            break;
        default:
            break;
    }
#endif
}


- (void)chooseshare:(NSString *)str1 Str2:(NSString *)str2 Str3:(NSString *)str3 Str4:(NSString *)str4 {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@", str4];
        urlStr= [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:str2
                                         images:str3
                                            url:url
                                          title:str1
                                           type:SSDKContentTypeAuto];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@      %@",str1,url] title:nil images:str3 video:nil url:nil latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeAuto];
        
        NSArray *items = nil;
        items = @[
                  @(SSDKPlatformSubTypeWechatSession),
                  @(SSDKPlatformSubTypeWechatTimeline),
//                  @(SSDKPlatformTypeSinaWeibo),
                  @(SSDKPlatformTypeCopy)
                  ];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        
        SSUIShareSheetConfiguration *config = [[SSUIShareSheetConfiguration alloc] init];
        
        config.directSharePlatforms = @[@(SSDKPlatformTypeCopy),@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession)];
        
        [ShareSDK showShareActionSheet:nil
                           customItems:items
                           shareParams:shareParams
                    sheetConfiguration:config
                        onStateChanged:^(SSDKResponseState state,
                                         SSDKPlatformType platformType,
                                         NSDictionary *userData,
                                         SSDKContentEntity *contentEntity,
                                         NSError *error,
                                         BOOL end) {
                            if (platformType == SSDKPlatformTypeCopy) {
                                switch (state) {
                                    case SSDKResponseStateSuccess:
                                    {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"拷贝成功"
                                                                                            message:nil
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:@"确定"
                                                                                  otherButtonTitles:nil];
                                        [alertView show];
                                        break;
                                    }
                                    case SSDKResponseStateFail:
                                    {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拷贝失败"
                                                                                        message:[NSString stringWithFormat:@"%@",error]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil, nil];
                                        [alert show];
                                        break;
                                    }
                                    default:
                                        break;
                                }
                            }
                            else{
                                switch (state) {
                                    case SSDKResponseStateSuccess:
                                    {
                                        
                                    }
                                    case SSDKResponseStateFail:
                                    {
                                        
                                        break;
                                    }
                                    default:
                                        break;
                                }
                            }
                        }];
    });
}

//微信支付
- (void)wxPay:(NSString *)str1{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [self dictionaryWithJsonString:str1];
        NSString *stamp  =  [dic objectForKey:@"timeStamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dic objectForKey:@"partnerId"];
        req.prepayId            = [dic objectForKey:@"prepayId"];
        req.nonceStr            = [dic objectForKey:@"nonceStr"];;
        req.timeStamp           = stamp.intValue;
        req.package             = [dic objectForKey:@"packageValue"];
        req.sign                = [dic objectForKey:@"sign"];
        [WXApi sendReq:req];
        
    });
}

//支付宝支付
- (void)aliPay:(NSString *)str1 {
    
//    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *orderSpec = str1;
        
        [[AlipaySDK defaultService] payOrder:orderSpec fromScheme:AliPaySceme callback:^(NSDictionary *resultDic) {
//            NSInteger restultCode  =[[resultDic objectForKey:@"resultStatus"] integerValue];
        }];
    });
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)flickingQRCode:(void (^)(NSString * codeStr))resultsucc{
    MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error);
        } else {
            NSLog(@"扫描结果：%@",result);
            if (resultsucc) {
                resultsucc(result);
            }
            
        }
    }];
    [self.navigationController pushViewController:scanVc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
