//
//  HTTPRequest.h
//  GeneralProgram
//
//  Created by Mac 1 on 2018/12/6.
//  Copyright © 2018年 Mac 1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPRequest : NSObject
// 上传图片
+  (void)uploadMostImageWithURLString:(NSString *)URLString
                           parameters:(id)parameters
                          uploadDatas:(NSArray *)uploadDatas
                           uploadName:(NSString *)uploadName
                              success:(void (^)(id Json))success
                              failure:(void (^)(NSError *))failure;

//上传视频
+  (void)uploadvideoWithURLString:(NSString *)URLString
                       parameters:(id)parameters
                      uploadDatas:(NSURL *)uploadDatas
                       uploadName:(NSString *)uploadName
                          success:(void (^)(id Json))success
                          failure:(void (^)(NSError *))failure;



//post请求
+  (void)postWithURLString:(NSString *)URLString
                parameters:(id)parameters
                   success:(void (^)(id Json))success
                   failure:(void (^)(NSError *))failure;


//Git请求
+  (void)GetWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id Json))success
                  failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
