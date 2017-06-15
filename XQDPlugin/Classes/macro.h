//
//  macro.h
//  gongfudai
//
//  Created by David Lan on 15/6/18.
//  Copyright (c) 2015年 dashu. All rights reserved.
//

#ifndef gongfudai_macro_h
#define gongfudai_macro_h
// for applications installed and exera infomation for identfier image
#define PUBLIC_KEY          @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFweUCcbpWo1e1D86ELyDwmsW2PHOqdbc0av/wyPs8mfxckfWb9+CIVaeCUB44cBcNEMQZ/0uuKOL07XytWReO9rIerOIdw6dUKfnd6j6YiB6J2N1/K50clYKunLUeUjI/ATJqi4l4B4T15swbfQwSvssXWKLImevBSvJmxrvIJwIDAQAB"

//version
#define IOS_VERSION         [[UIDevice currentDevice] systemVersion]
#define IOS_OR_LATER(s)       ([[[UIDevice currentDevice] systemVersion] compare:[NSString stringWithFormat:@"%@",@(s)] options:NSNumericSearch] != NSOrderedAscending)


//device
#define SCREEN_BOUNDS       ([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT       ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH        ([UIScreen mainScreen].bounds.size.width)
#define IS_568              (SCREEN_HEIGHT == 568)
#define IS_iPad             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_Iphone4          (SCREEN_HEIGHT == 480)
#define IS_Iphone5          (SCREEN_HEIGHT == 568)
#define IS_Iphone6          (SCREEN_HEIGHT == 667)
#define IS_Iphone6p          (SCREEN_HEIGHT == 736)
#define IS_Iphone6p_Or_Later (SCREEN_HEIGHT >= 736)
#define DSMAX(a,b)            a>b?a:b
#define DSMIN(a,b)            a<b?a:b

#define ScaleFrom_iPhone5_Desgin(_X_) (_X_ * (SCREEN_WIDTH/320))
#define ScaleFrom_iPhone6_Desgin(_X_) (_X_ * (SCREEN_WIDTH/375))

//COLOR
#define DS_CClear               [UIColor clearColor]
#define DS_CRGB(r,g,b,a)        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define DS_CHex(rgbValue)       [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DS_F(fontName,fontSize) [UIFont fontWithName:fontName size:fontSize]


#define RGBCOLOR(r,g,b)                     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)                  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(hex)                       [UIColor colorWithHexString:hex alpha:1]
#define NAVIGATION_BAR_COLOR                HEXCOLOR(@"4b80ff")


#define NAVIGATION_BAR_TINT_COLOR           HEXCOLOR(@"eeeeee")
#define BAR_BUTTON_ITEM_COLOR               HEXCOLOR(@"eeeeee")
#define THEME_COLOR                         HEXCOLOR(@"4b80ff")
#define BG_COLOR                            HEXCOLOR(@"f9f9f9")
#define GFD_BUTTON_COLOR                    HEXCOLOR(@"ffffff")
#define ALERT_DANGER_COLOR                  HEXCOLOR(@"F55C23")
#define ALERT_SUCCESS_COLOR                 HEXCOLOR(@"5cb85c")
#define COLOR_SUPER_GRAY                    HEXCOLOR(@"f2f2f2")//2b2d39
#define COLOR_DANGER                        HEXCOLOR(@"F55C23")
#define COLOR_SUCCESS                       HEXCOLOR(@"5cb85c")
#define COLOR_DEFAULT                       HEXCOLOR(@"EEEEEE")

//工具方法(本地数据存储)
#define DS_GET(k)           [[NSUserDefaults standardUserDefaults] stringForKey:k.tripleDESEncrypt].tripleDESDecrypt.getSetFromJson
#define DS_SET(k,v)         [[NSUserDefaults standardUserDefaults] setObject:v.tripleDESEncrypt forKey:k.tripleDESEncrypt]


#define CUSTOMER_SET(k, value) [[NSUserDefaults standardUserDefaults] ds_setObject:value forKey:k]
#define CUSTOMER_GET(k) [[NSUserDefaults standardUserDefaults] ds_objectForKey:k]


#define DS_SETBOOL(k, v)  [[NSUserDefaults standardUserDefaults] setBool:v forKey:k]
#define DS_GETBOOL(k)       [[NSUserDefaults standardUserDefaults] boolForKey:k]
//#define DS_REMOVE(k)        [[NSUserDefaults standardUserDefaults] removeObjectForKey:k.tripleDESEncrypt]
#define DS_GET_IMG(n)        [UIImage imageNamed:n]
#define DS_STR_FORMAT(a,b)       [NSString stringWithFormat:a,b]
#define GET_NONNIL_VAL(v)   v==nil?[NSNull null]:v
#define GET_NIB_WITHNAME(n) [[[NSBundle mainBundle]loadNibNamed:n owner:self options:nil]firstObject]

#define DS_AVAILABLE(s) (!s||[s isMemberOfClass:[NSNull class]])?@"":s
#define DSLog(FORMAT,...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#endif
//
