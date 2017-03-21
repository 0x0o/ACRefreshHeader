//
//  ACRefreshHeader.m
//  ProjectDemo
//
//  Created by 0x0 on 2017/3/16.
//  Copyright © 2017年 0x0. All rights reserved.
//

#import "ACRefreshHeader.h"

@interface ACRefreshHeader ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView; // 需要添加刷新控件的scrollView

@property (weak, nonatomic) UIView *headerBackgroundView; //刷新控件整个父视图
@property (weak, nonatomic) UIImageView *arrowImageView; //箭头
@property (weak, nonatomic) UIActivityIndicatorView *indicatorView; // 菊花
@property (weak, nonatomic) UILabel *statusTextLabel; // 刷新状态的Label

@property (nonatomic, getter=isRefreshing) BOOL refreshing;
@end


@implementation ACRefreshHeader{
    CGFloat _headerBackgroundViewH; // 整个刷新控件背景高度
    CGFloat _contentHeight;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    if ([super init]) {
        self.refreshing = NO;
        _scrollView = scrollView;
        [self initView];
    }
    return self;
}




- (void)initView {
    // 初始化
    _headerBackgroundViewH = 100;
    CGFloat scrollViewW = _scrollView.frame.size.width;
    
    // 整个Header
    UIView *headerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -_headerBackgroundViewH, scrollViewW, _headerBackgroundViewH)];
    self.headerBackgroundView = headerBackgroundView;
    _headerBackgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headerBackgroundView];
    
    
    CGFloat arrowW = 13;
    CGFloat arrowH = 14;
    CGFloat arrowX = scrollViewW/2 - 30 - arrowW;
    CGFloat arrowY = _headerBackgroundViewH - 35;
    
    // 箭头
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    self.arrowImageView = arrowImageView;
    arrowImageView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    arrowImageView.image = [UIImage imageNamed:@"refresh_icon"];
    [self.headerBackgroundView addSubview:arrowImageView];
    
    CGFloat labelY = arrowY;
    CGFloat labelW = 60;
    CGFloat labelH = arrowH;
    CGFloat labelX = scrollViewW/2 - labelW/2 + 7;
    
    // 文字
    UILabel *statusTextLabel = [[UILabel alloc] init];
    statusTextLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    self.statusTextLabel = statusTextLabel;
    statusTextLabel.text = @"正在刷新";
    statusTextLabel.font           = [UIFont systemFontOfSize:13];
    statusTextLabel.textColor      = [UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00];
    statusTextLabel.textAlignment  = NSTextAlignmentCenter;
    [self.headerBackgroundView addSubview:statusTextLabel];
    
    // 菊花
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    [self.headerBackgroundView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        _contentHeight = _scrollView.contentSize.height;
        
        if (_scrollView.isDragging) {
            CGFloat currentPosition = _scrollView.contentOffset.y;
            
            if (self.isRefreshing) return;
            
            [UIView animateWithDuration:0.25f animations:^{
                //下拉 -130
                if (currentPosition < -_headerBackgroundViewH* 1.3 ) {
                    self.arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
                    self.statusTextLabel.text = @"释放更新";
                }else {
                    //上拉
                    self.arrowImageView.transform = CGAffineTransformIdentity;
                    self.statusTextLabel.text = @"下拉刷新";
                }
            }];
        }else {
            if ([self.statusTextLabel.text isEqualToString:@"释放更新"]) {
                [self startRefreshing];
            }
        }
    }
}

- (void)startRefreshing {
    if (!self.isRefreshing) {
        self.refreshing = YES;
        self.statusTextLabel.text   = @"加载中...";
        self.arrowImageView.hidden  = YES;
        self.indicatorView.hidden   = NO;
        [self.indicatorView startAnimating];
        [UIView animateWithDuration:0.2f animations:^{
            
            CGFloat currentPosition = _scrollView.contentOffset.y;
            NSLog(@"currentPosition:%.f",currentPosition);
            
            if (currentPosition > -_headerBackgroundViewH * 1.3) { //-130 比刷新的时候短就再下滑一点到刷新状态的高度
                _scrollView.contentOffset = CGPointMake(0, currentPosition - _headerBackgroundViewH * 1.3);
            }
            _scrollView.contentInset = UIEdgeInsetsMake(_headerBackgroundViewH*1.3, 0, 0, 0);
        }];
    }
}


- (void)stopRefreshing {
    self.refreshing = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2f animations:^{
            CGFloat currentPosition = _scrollView.contentOffset.y;
            if (currentPosition != 0) {
                _scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            }
        }completion:^(BOOL finished) {
            self.statusTextLabel.text = @"下拉刷新";
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            self.arrowImageView.hidden    = NO;
            self.arrowImageView.transform = CGAffineTransformIdentity;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRefreshing" object:nil];
        }];
    });
}


- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}






@end
