//
//  XQDConfigParser.h
//  kaixindai
//
//  Created by EriceWang on 2017/2/21.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import <Foundation/Foundation.h>
//该类主要用于本地参数的解析
@interface XQDConfigParser : NSObject<NSXMLParserDelegate>
//所有Plugin的信息
@property (strong, nonatomic) NSMutableDictionary *featureNames;
//需要预加载的plugin名字
@property (strong, nonatomic) NSMutableArray *startupPluginNames;

@end
