//
//  BaseViewController.h
//  dzm
//
//  Created by dzmmac on 14-9-25.
//  Copyright (c) 2014年 dzmmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class BaseViewController;


@interface BaseViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (copy, nonatomic) void(^HttpjsonBlock)(NSString *source, id Json);//source来源，json数据

@property (nonatomic, strong) MBProgressHUD *hud;

- (BOOL)StringIsNullOrEmpty:(NSString *)str;//判断字符串是否为空

-(void)showUIActionSheet:(NSString *)TitleStr cancestr:(NSString *)canceStr otherFirststr:(NSString *)otherFirstStr  otherSecondstr:(NSString *)otherSecondStr sheettag:(NSInteger)sheetTag;

- (void)chooseshare:(NSString *)str1 Str2:(NSString *)str2 Str3:(NSString *)str3 Str4:(NSString *)str4;//分享  根据分享需求与h5协商传过来的
- (void)checkAddressBookAuth:(void (^)(BOOL auth))result;//检测通讯录访问权限，防止因权限问题崩溃

- (void)wxPay:(NSString *)str1;//微信支付
- (void)aliPay:(NSString *)str1;//支付宝支付
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;//json 转Dic
- (void)flickingQRCode:(void (^)(NSString * codeStr))resultsucc;
@end
