//
//  NSString+Expand.m
//  gongfudai
//
//  Created by _tauCross on 14-7-16.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import "NSString+Expand.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <GTMBase64/GTMBase64.h>

@implementation NSString (Expand)

- (BOOL) isNormalStr
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9A-Za-z\u4E00-\u9FA5]*$"];
    return [predicate evaluateWithObject:self];
}


-(BOOL) isMobilePhone{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{11}$"];
    return [predicate evaluateWithObject:self];
}

-(BOOL) isValidPassword{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9A-Za-z]*$"];
//    return self!=nil&&[predicate evaluateWithObject:self]&&self.length>=6&&self.length<=18;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?!^\\d+$)(?!^[a-zA-Z]+$)[0-9a-zA-Z]{6,18}$"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9a-zA-Z]{6,}$"];
    return [predicate evaluateWithObject:self];
}

- (NSString *)md5
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+(NSString*)encodeURL:(NSString *)string
{
    return [string encodeURL];
}

- (NSString *)encodeURL
{
    CFTypeRef stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    NSString *newString = (__bridge NSString *)stringRef;
    
    CFRelease(stringRef);
    
    if (newString)
    {
        return newString;
    }
    return @"";
}

-(NSString *)decodeURL
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

+(NSString *)generateUUIDString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString*uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    return uuidString;
}

+ (NSDate *)mfDateFromDotNetJSONString:(NSString *)aJsonDateString
{
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:aJsonDateString options:0 range:NSMakeRange(0, [aJsonDateString length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[aJsonDateString substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [aJsonDateString substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [aJsonDateString substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [aJsonDateString substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

-(NSString *)add:(NSString *)aString
{
    return [NSString stringWithFormat:@"%@%@",self,aString];
}


-(BOOL)isChineseCharactor{
    if (self.length>0) {
        NSString *alphaBeta = [self substringToIndex:1];
        const char* u8Temp = [alphaBeta UTF8String];
        return 3==strlen(u8Temp);
    }
    return NO;
    
}

-(NSString *)tripleDESEncrypt
{
    return [self tripleDESEncryptWithKey:DESKEY];
}

-(NSString *)tripleDESDecrypt
{
    return [self tripleDESDecryptWithKey:DESKEY];
}

-(NSString *)tripleDESSpecialEncrypt
{
    return [self tripleDESEncryptOrDecrypt:kCCEncrypt isSpecial:YES key:DESKEY];
}

- (NSString *)tripleDESDecryptWithKey:(NSString *)key
{
    return [self tripleDESEncryptOrDecrypt:kCCDecrypt isSpecial:NO key:key];
}

- (NSString *)tripleDESEncryptWithKey:(NSString *)key
{
    return [self tripleDESEncryptOrDecrypt:kCCEncrypt isSpecial:NO key:key];
}

-(NSString*)tripleDESEncryptOrDecrypt:(CCOperation)encryptOrDecrypt isSpecial:(BOOL)aIsSpecial key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[key cStringUsingEncoding:NSASCIIStringEncoding];

    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        if(!aIsSpecial)
        {
            result = [GTMBase64 stringByEncodingData:myData];
        }
        else
        {
            NSString *myStr = [myData description];
            if([myStr hasPrefix:@"<"] && [myStr hasSuffix:@">"])
            {
                myStr = [myStr substringWithRange:NSMakeRange(1, [myStr length]-2)];
                result = [myStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            else
            {
                result = nil;
            }
        }
    }
    
    free(bufferPtr);
    
    return result;
}

- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(NSString*)trimWhitespace
{
    NSString *newStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr;
}

+ (NSString *)fourBitStringFromAmountString:(NSString *)amountString
{
    double amount = amountString.doubleValue;
    if(amount < 10000)
    {
        return [NSString stringWithFormat:@"%.2f", amount];
    }
    return [NSString stringWithFormat:@"%.2f万", amount / 10000.0];
}

- (BOOL) containsString: (NSString*) substring
{
    if (![substring isKindOfClass:[NSString class]]) {
        return NO;
    }
    NSRange range = [self rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

-(NSDictionary *)dictionaryValue{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}
+ (BOOL)isValidString:(NSString *)orignalString {
    if ([orignalString isKindOfClass:[NSNull class]] || !orignalString || !orignalString.length) {
        return NO;
    }
    return YES;
}
- (id)getSetFromJson {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id set = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error && error.code == 3840) {
        //本身就是字符串
        set = self;
    } else if (error) {
        set = nil;
    }
    return set;
}
- (NSString *)deleteMoreWhitespaceAndNewlineCharacter {
   NSString *result = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *components = [result componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    result = [components componentsJoinedByString:@""];//按单空格分割
    result = [result stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return result;
//    return self;
}
- (BOOL)isValidJSONFormat {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!result || error) {
        return NO;
    } else {
        return YES;
    }
}
@end
