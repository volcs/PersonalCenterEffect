//
//  ExpandHeader.m
//  VPersonalComponent
//
//  Created by Vols on 15/8/21.
//  Copyright (c) 2015年 Vols. All rights reserved.
//
#define kExpandContentOffset @"contentOffset"

#import "VExpandHeader.h"

@implementation VExpandHeader{
    __weak UIScrollView *_scrollView;   //scrollView或者其子类
    __weak UIView *_expandView;         //背景可以伸展的View
    
    CGFloat _expandHeight;
}

- (void)dealloc {
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:kExpandContentOffset];
        _scrollView = nil;
    }
    _expandView = nil;
}

+ (id)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView {
    VExpandHeader *expandHeader = [VExpandHeader new];
    [expandHeader expandWithScrollView:scrollView expandView:expandView];
    return expandHeader;
}

- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView {
    
    _expandHeight = CGRectGetHeight(expandView.frame);
    
    _scrollView = scrollView;
    _scrollView.contentInset = UIEdgeInsetsMake(_expandHeight, 0, 0, 0);
    [_scrollView insertSubview:expandView atIndex:0];
    [_scrollView addObserver:self forKeyPath:kExpandContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView setContentOffset:CGPointMake(0, -_expandHeight)];
    
    _expandView = expandView;
    
//    _expandView.contentMode = UIViewContentModeScaleAspectFill;
    _expandView.contentMode = UIViewContentModeScaleToFill;
    _expandView.clipsToBounds = YES;
    
    [self reSizeView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (![keyPath isEqualToString:kExpandContentOffset]) {
        return;
    }
    [self scrollViewDidScroll:_scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < _expandHeight * -1) {
        CGRect currentFrame = _expandView.frame;
        currentFrame.origin.y = offsetY;
        currentFrame.size.height = -1*offsetY;
        _expandView.frame = currentFrame;
    }
}


- (void)reSizeView{
    [_expandView setFrame:CGRectMake(0, -1*_expandHeight, CGRectGetWidth(_expandView.frame), _expandHeight)];
}


@end
