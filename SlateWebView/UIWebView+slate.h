//
//  UIWebView+slate.h
//  SlateCore
//
//  Created by linyize on 16/4/29.
//  Copyright © 2016年 Modern Mobile Digital Media Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (slate)

- (NSInteger)getiFrameCount;
- (NSString *)getiFrameSrcWithIndex:(NSUInteger)index;
- (BOOL)isiFrameURL:(NSURL *)url;

- (NSInteger)getVideoCount;
- (NSString *)getVideoSrcWithIndex:(NSUInteger)index;
- (void)setVideoSrcWithIndex:(NSUInteger)index videoSrc:(NSString *)videoSrc;

- (NSString *)metaTag:(NSString *)metaTagName;

@end
