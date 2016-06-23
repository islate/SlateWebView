//
//  UIWebView+slate.h
//  SlateCore
//
//  Created by lin yize on 16-6-23.
//  Copyright (c) 2016年 islate. All rights reserved.
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
