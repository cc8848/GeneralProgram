//
//  URLDefine.h
//  codebase
//
//  Created by iss on 15/9/24.
//  Copyright © 2015年 iss. All rights reserved.
//

#ifndef URLDefine_h
#define URLDefine_h


//************************************* 正式环境***************************************************
#ifdef PROD

#define Server    @"https://www.xiongxinghe.com/"
#define uploadServer    @"http://www.xiongxinghe.com:6001/"
#define HtmlServer  @"http://kfdemo.movitech.cn/www/moveHouse/index.html"
#define JPUSHKEY @"2e1bfad06b33b235a2d180a6"
#define JPUSHSECRET @"7921bfcba48ab4b0f3789f45"
#define WeChatKey @"wxfe6869363b85700e"
#define WeChatSecrett @"c6da999b02169c1bcc7915b2729cd7a1"
#define ShareSDK_Key @"284235896639a"
#define SinaWeiboKey @"2092075659"
#define SinaWeiboSecrett @"3bad967233f2218a1ea5140c052d7116"
#define AliPaySceme @"alipayhgy"


//************************************* UAT环境 ***************************************************
#elif UAT

#define Server    @"http://zulin.xiongxinghe.com/"
#define uploadServer    @"http://zulin.xiongxinghe.com:6001/"
#define HtmlServer  @"http://kfdemo.movitech.cn/www/moveHouse/index.html"
#define JPUSHKEY @"0d15c4c46cb39a8ff74325aa"
#define JPUSHSECRET @"4c2cb0b859f628dec4a6b2d5"
#define WeChatKey @"wxfe6869363b85700e"
#define WeChatSecrett @"93035163f30fbbae90a5bb6d1cfd366c"
#define ShareSDK_Key @"284235896639a"
#define SinaWeiboKey @"2092075659"
#define SinaWeiboSecrett @"3bad967233f2218a1ea5140c052d7116"
#define AliPaySceme @"alipayhgy"


//************************************* QA环境 ***************************************************
#elif QA

#define Server    @"https://172.19.50.189:6002/"
#define uploadServer    @"http://zulin.xiongxinghe.com:6001/"
#define HtmlServer  @"http://kfdemo.movitech.cn/www/moveHouse/index.html"
#define JPUSHKEY @"70df6ec2ba96056eea939657"
#define JPUSHSECRET @"c55e42da46b80fc5828b0ee3"
#define WeChatKey @"wxfe6869363b85700e"
#define WeChatSecrett @"223844f1cfadf11607216eb69f8e0df9"
#define ShareSDK_Key @"284235896639a"
#define SinaWeiboKey @"2092075659"
#define SinaWeiboSecrett @"3bad967233f2218a1ea5140c052d7116"
#define AliPaySceme @"alipayhgy"

//************************************* Dev环境 ***************************************************
#elif Dev

#define Server    @"https://172.19.50.189:6002/"
#define uploadServer    @"http://zulin.xiongxinghe.com:6001/"
#define HtmlServer  @"http://kfdemo.movitech.cn/www/moveHouse/index.html"
#define JPUSHKEY @"70df6ec2ba96056eea939657"
#define JPUSHSECRET @"c55e42da46b80fc5828b0ee3"
#define WeChatKey @"wxfe6869363b85700e"
#define WeChatSecrett @"223844f1cfadf11607216eb69f8e0df9"
#define ShareSDK_Key @"284235896639a"
#define SinaWeiboKey @"2092075659"
#define SinaWeiboSecrett @"3bad967233f2218a1ea5140c052d7116"
#define AliPaySceme @"alipayhgy"


//**************************************** 其它环境 ************************************************
#else

#define Server    @"https://www.xiongxinghe.com/"
#define uploadServer    @"http://www.xiongxinghe.com:6001/"
#define HtmlServer @"http://kfdemo.movitech.cn/www/moveHouse/index.html" //敏房宝UAT
#define JPUSHKEY @"0d15c4c46cb39a8ff74325aa"
#define JPUSHSECRET @"4c2cb0b859f628dec4a6b2d5"
#define WeChatKey @"wxfe6869363b85700e"
#define WeChatSecrett @"223844f1cfadf11607216eb69f8e0df9"
#define ShareSDK_Key @"284235896639a"
#define SinaWeiboKey @"2092075659"
#define SinaWeiboSecrett @"3bad967233f2218a1ea5140c052d7116"
#define AliPaySceme @"alipayhgy"

#endif

#endif /* URLDefine_h */
