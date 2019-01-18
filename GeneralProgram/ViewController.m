//
//  ViewController.m
//  GeneralProgram
//
//  Created by Mac 1 on 2018/12/6.
//  Copyright © 2018年 Mac 1. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"


//支付
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

//获取通讯录
#import "LJContactManager.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WKScriptMessageHandler>
{
    BOOL firstadd;
}
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic ,strong) UIImageView  *imageView;

@end

@implementation ViewController

- (void)dealloc {
    self.webView.navigationDelegate = nil;
    self.webView.UIDelegate = nil;
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"shareContent"];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"chooseVideo"];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"chooseImage"];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"chooseaddressbook"];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"wxpay"];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"alipay"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kNetworkReachabilityChangedNotification) name:@"kNetworkReachabilityChangedNotification" object:nil];
    firstadd = true;
    //创建webView
    [self createWebView];
    
    if (firstadd) {
        self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self.view addSubview:self.imageView];
        [self showHUDView];
    }
    //注册交互方式
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.targetURL] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:5.0];
//    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:self.targetURL]];
//    [self.webView loadRequest:request];
    [self.webView loadRequest:request];//加载网页
    
}

-(NSString*)targetURL
{
    if (!_targetURL) {
        _targetURL = HtmlServer;
    }
    return _targetURL;
}
#pragma mark - 创建webView
-(void)createWebView
{
    WKWebViewConfiguration * config =[[WKWebViewConfiguration alloc] init];
    config.userContentController =[[WKUserContentController alloc] init];
    //初始化偏好设置属性
    config.preferences =[[WKPreferences alloc] init];
    //允许视频播放
    if (@available(iOS 9.0, *)) {
        config.allowsAirPlayForMediaPlayback = YES;
    } else {
        // Fallback on earlier versions
    }
    // 允许在线播放
    config.allowsInlineMediaPlayback = YES;
    // 允许可以与网页交互，选择视图
    config.selectionGranularity = YES;
    
    // 是否支持JavaScript
    config.preferences.javaScriptEnabled =YES;
    config.suppressesIncrementalRendering = YES;

    //不通过交互是否打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically =NO;
    [config.userContentController addScriptMessageHandler:self name:@"shareContent"];
    [config.userContentController addScriptMessageHandler:self name:@"chooseVideo"];
    [config.userContentController addScriptMessageHandler:self name:@"chooseImage"];
    [config.userContentController addScriptMessageHandler:self name:@"chooseaddressbook"];
    [config.userContentController addScriptMessageHandler:self name:@"wxpay"];
    [config.userContentController addScriptMessageHandler:self name:@"alipay"];
    [config.userContentController addScriptMessageHandler:self name:@"flickingqrcode"];
    
    WKPreferences *preferences = [WKPreferences new];
    config.preferences = preferences;
    self.webView =[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
    self.webView.UIDelegate =self;
    self.webView.navigationDelegate=self;
    //开启手势触摸
    self.webView.allowsBackForwardNavigationGestures = YES;
    // 设置 可以前进 和 后退
    //开启手势触摸
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    //适应你设定的尺寸
    [self.webView sizeToFit];
    
    [self.view addSubview:self.webView];
    LRWeakSelf(self);
    
    self.HttpjsonBlock = ^(NSString *source, id Json) {
        if ([source isEqualToString:@"照片"]) {
            
            
            NSString *jsstr = [NSString stringWithFormat:@"setimage('%@')",Json];
            [weakself setjs:jsstr];
        }
        else if ([source isEqualToString:@"视频"]){
            NSString *jsstr = [NSString stringWithFormat:@"setvideo('%@')",Json];
            [weakself setjs:jsstr];
        }
        
    };

    
    
}

-(void)showHUDView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hidenHUDView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//需要用到标题就将navigationItem显示
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
    
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"didStar");
//    if (firstadd) {
//        [self showHUDView];
//    }
//    [self showHUDView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"didFinish");
    [self.imageView setHidden:YES];
    firstadd = false;
    [self hidenHUDView];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                    });
                });
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"didFail");
    
    if([error code] == NSURLErrorCancelled)  {//!webview在之前的请求还没有加载完成，下一个请求发起了，此时webview会取消掉之前的请求，因此会回调到失败这里。此时的code ==  NSURLErrorCancelled
        
        return;
    }
    [self hidenHUDView];
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    if (self.webView.URL.host) {
        
    }else
    {
        completionHandler();
    }
    
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    if (self.webView.URL.host) {
        
    }else
    {
        completionHandler(NO);
    }
}
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler
{
    if (self.webView.URL.host) {
        
    }else
    {
        completionHandler(@"");
    }
}

#pragma mark - WKScriptMessageHandler
//接收从js传给oc的数据
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"shareContent"]){
        NSDictionary *dic = message.body;
        NSString *titleStr = [dic objectForKey:@"title"];
        NSString *textStr = [dic objectForKey:@"text"];
        NSString *iamgePic = [dic objectForKey:@"iamgeurl"];
        NSString *shareurl = [dic objectForKey:@"shareurl"];
        [self  chooseshare:textStr Str2:titleStr Str3:iamgePic Str4:shareurl];
    }
    else if ([message.name isEqualToString:@"chooseVideo"]){
        [self showUIActionSheet:@"选择视频" cancestr:@"取消" otherFirststr:@"拍摄视频" otherSecondstr:@"媒体库选择" sheettag:1001];
    }
    
    else if ([message.name isEqualToString:@"chooseImage"]){
        [self showUIActionSheet:@"选择照片" cancestr:@"取消" otherFirststr:@"拍照" otherSecondstr:@"相册" sheettag:1002];
    }
    else if ([message.name isEqualToString:@"chooseaddressbook"]){
        LRWeakSelf(self);
        [self checkAddressBookAuth:^(BOOL auth) {
            if (auth) {
                [[LJContactManager sharedInstance] selectContactAtController:self complection:^(NSString *name, NSString *phone) {
                    phone =  [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    phone =  [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSString *jsstr = [NSString stringWithFormat:@"addressBook('%@','%@')",name,phone];
                    [weakself setjs:jsstr];
                    NSLog(@"联系人%@ 电话%@",name,phone);
                }];
            }
            else{
            }
        }];
    }
    else if ([message.name isEqualToString:@"wxpay"]){
        
        [self wxPay:@""];
        
    }
    else if ([message.name isEqualToString:@"alipay"]){
        [self aliPay:@""];
    }
    else if ([message.name isEqualToString:@"flickingqrcode"]){
        [self flickingQRCode:^(NSString *codeStr) {
            
            
        }];
    }
    
    
}

#pragma mark-- OC TO JS

- (void)setjs:(NSString *)jsstr{
    [self.webView evaluateJavaScript:jsstr completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"alert");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -通知中心
//网络变化刷新页面
- (void)kNetworkReachabilityChangedNotification {
    [self.webView reload ];//加载网页
}


@end
