//
//  HTTPRequest.m
//  GeneralProgram
//
//  Created by Mac 1 on 2018/12/6.
//  Copyright © 2018年 Mac 1. All rights reserved.
//

#import "HTTPRequest.h"
#import "AFHTTPSessionManager.h"

@implementation HTTPRequest


+  (void)uploadMostImageWithURLString:(NSString *)URLString
                           parameters:(id)parameters
                          uploadDatas:(NSArray *)uploadDatas
                           uploadName:(NSString *)uploadName
                              success:(void (^)(id Json))success
                              failure:(void (^)(NSError *))failure{

    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
        for (int i=0;i< uploadDatas.count; i++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            UIImage *image = uploadDatas[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.28);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file"] fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            success([dic objectForKey:@"data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+  (void)uploadvideoWithURLString:(NSString *)URLString
                       parameters:(id)parameters
                      uploadDatas:(NSURL *)uploadDatas
                       uploadName:(NSString *)uploadName
                          success:(void (^)(id Json))success
                          failure:(void (^)(NSError *))failure{
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 120.0;
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.mp4",str];
        NSData *imageData = [NSData dataWithContentsOfURL:uploadDatas];;
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file"] fileName:fileName mimeType:@"video/mpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            success([dic objectForKey:@"data"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//post请求
+  (void)postWithURLString:(NSString *)URLString
                parameters:(id)parameters
                   success:(void (^)(id Json))success
                   failure:(void (^)(NSError *))failure{
    
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            success(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//Get请求
+  (void)GetWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id Json))success
                  failure:(void (^)(NSError *))failure{
    
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            success(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}


@end
