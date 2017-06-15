//
//  UITableViewCell+Expand.m
//  gongfudai
//
//  Created by _tauCross on 14-7-22.
//  Copyright (c) 2014年 dashu. All rights reserved.
//

#import "UITableViewCell+Expand.h"

@implementation UITableViewCell (Expand)

- (UITableView *)tableView
{
    if([self.superview isKindOfClass:[UITableView class]])
    {
        return (UITableView *)self.superview;
    }
    else
    {
        return (UITableView *)self.superview.superview;
    }
}

- (NSIndexPath *)indexPath
{
    return [[self tableView] indexPathForCell:self];
}

@end
