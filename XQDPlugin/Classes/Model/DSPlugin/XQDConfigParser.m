//
//  XQDConfigParser.m
//  kaixindai
//
//  Created by EriceWang on 2017/2/21.
//  Copyright © 2017年 Ericdong. All rights reserved.
//

#import "XQDConfigParser.h"
@interface XQDConfigParser ()
@property (strong, nonatomic) NSMutableDictionary *settings;
@property (copy, nonatomic) NSString *featureName;
@end

@implementation XQDConfigParser
- (instancetype)init {
    self = [super init];
    if (self) {
        self.settings = [NSMutableDictionary dictionary];
        self.featureNames = [NSMutableDictionary dictionary];
        self.startupPluginNames = [NSMutableArray array];
        self.featureName = nil;
    }
    return self;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([elementName isEqualToString:@"preference"]) {
        _settings[attributeDict[@"name"]] = attributeDict[@"value"];
    } else if([elementName isEqualToString:@"feature"]){
        _featureName = [attributeDict[@"name"] lowercaseString];
    } else if (_featureName &&[elementName isEqualToString:@"param"] ) {
        NSString *paraName =[attributeDict[@"name"] lowercaseString];
        NSString *value = attributeDict[@"value"];
        if ([paraName isEqualToString:@"ios-package"]) {
            _featureNames[_featureName] = value;
        }
        BOOL paramIsOnload = [paraName isEqualToString:@"onload"] && [@"true" isEqualToString:value];
        BOOL attributeIsOnload = [@"true" isEqualToString:[attributeDict[@"onload"] lowercaseString]];
        if (paramIsOnload || attributeIsOnload) {
            [self.startupPluginNames addObject:_featureName];
        }
                        
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"feature"]) {
        _featureName = nil;
    }
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSAssert(NO, @"config.xml parse error line %ld col %lld", parser.lineNumber, parser.columnNumber);
}
@end
