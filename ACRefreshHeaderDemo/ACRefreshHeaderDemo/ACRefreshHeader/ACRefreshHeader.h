//
//  ACRefreshHeader.h
//  ProjectDemo
//
//  Created by 0x0 on 2017/3/16.
//  Copyright © 2017年 0x0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACRefreshHeader : UIView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
- (void)startRefreshing;
- (void)stopRefreshing;
@end
