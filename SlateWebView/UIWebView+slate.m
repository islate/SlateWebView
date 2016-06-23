//
//  UIWebView+slate.m
//  SlateCore
//
//  Created by lin yize on 16-6-23.
//  Copyright (c) 2016年 islate. All rights reserved.
//

#import "UIWebView+slate.h"

#import "SlateURI.h"

@implementation UIWebView (slate)

#pragma mark - iFrame

- (NSInteger)getiFrameCount
{
    NSString *script = @"function getiFrameCount() {"
    "  return document.querySelectorAll('iframe').length;"
    "}"
    "getiFrameCount();";
    NSString *result = [self stringByEvaluatingJavaScriptFromString:script];
    return [result integerValue];
}

- (NSString *)getiFrameSrcWithIndex:(NSUInteger)index
{
    NSString *script = [NSString stringWithFormat:
                        @"function getiFrameSrc() {"
                        "  return document.querySelectorAll('iframe')[%lu].src;"
                        "}"
                        "getiFrameSrc();", (unsigned long)index];
    NSString *result = [self stringByEvaluatingJavaScriptFromString:script];
    return result;
}

- (BOOL)isiFrameURL:(NSURL *)url
{
    NSInteger count = [self getiFrameCount];
    for (NSInteger i = 0; i < count; i++)
    {
        NSString *iFrameURL = [self getiFrameSrcWithIndex:i];
        if (iFrameURL.length > 0)
        {
            if ([iFrameURL isEqualToString:url.absoluteString])
            {
                if (![SlateURI canOpenURI:[NSURL URLWithString:iFrameURL]]
                    && ![url.scheme.lowercaseString isEqualToString:@"webridge"])
                {
                    // 不是slateuri 或者 不是webridge消息
                    // 说明是个iFrame，要在webView内打开它
                    return YES;
                }
                break;
            }
        }
    }
    return NO;
}

#pragma mark - video

- (NSInteger)getVideoCount
{
    NSString *script = @"function getVideoCount() {"
    "  return document.querySelectorAll('video').length;"
    "}"
    "getVideoCount();";
    NSString *result = [self stringByEvaluatingJavaScriptFromString:script];
    return [result integerValue];
}

- (NSString *)getVideoSrcWithIndex:(NSUInteger)index
{
    NSString *script = [NSString stringWithFormat:
                        @"function getVideoSrc() {"
                        "  return document.querySelectorAll('video')[%lu].src;"
                        "}"
                        "getVideoSrc();", (unsigned long)index];
    NSString *result = [self stringByEvaluatingJavaScriptFromString:script];
    return result;
}

- (void)setVideoSrcWithIndex:(NSUInteger)index videoSrc:(NSString *)videoSrc
{
    NSString *script = [NSString stringWithFormat:
                        @"var video = document.querySelectorAll('video')[%lu];"
                        "video.src = '%@';", (unsigned long)index, videoSrc];
    [self stringByEvaluatingJavaScriptFromString:script];
}

#pragma mark - metaTag

- (NSString *)metaTag:(NSString *)metaTagName
{
    NSString *getMetaTagJS = [NSString stringWithFormat:
                              @"function getMetaTag() {"
                              @"  var m = document.getElementsByTagName('meta');"
                              @"  for(var i in m) { "
                              @"    if(m[i].name == '%@') {"
                              @"      return m[i].content;"
                              @"    }"
                              @"  }"
                              @"  return '';"
                              @"}"
                              @"getMetaTag();", metaTagName];
    
    return [self stringByEvaluatingJavaScriptFromString:getMetaTagJS];
}

@end
