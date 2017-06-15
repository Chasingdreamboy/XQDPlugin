//
//  XQDRefreshGifHeader.m
//  gongfudaiNew
//
//  Created by EriceWang on 2016/12/23.
//  Copyright © 2016年 dashu. All rights reserved.
//

#import "XQDRefreshGifHeader.h"
#import "UIImage+Resize.h"
#import "UIView+Expand.h"

@implementation XQDRefreshGifHeader
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    UIImage *image = self.gifView.image;
    if (self.state == MJRefreshStateIdle) {
        CGSize size = image.size;
        if (pullingPercent > 1.0) {
            pullingPercent = 1.0;
        }
        self.gifView.image = [image resizedImageToSize:CGSizeMake(size.width * pullingPercent, size.height * pullingPercent)];
    }
}
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
    [super setImages:images duration:duration forState:state];
    self.gifView.height = self.mj_h;
}
@end
