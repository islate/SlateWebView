//
//  SlateWebView.m
//  SlateCore
//
//  Created by lin yize on 16-6-23.
//  Copyright (c) 2016年 islate. All rights reserved.
//

#import "SlateWebView.h"

#import "SlateUtils.h"
#import "SlateURI.h"

@interface SlateWebView ()

@property (nonatomic, weak) NSURLRequest *requestToLoad;

@end

@implementation SlateWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.allowsInlineMediaPlayback = YES;
        self.mediaPlaybackRequiresUserAction = NO;
        self.dataDetectorTypes = UIDataDetectorTypeNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO; // 让网页可以透明
        self.scalesPageToFit = YES;
        
        // 去掉默认阴影
        for (UIView *shadowView in self.scrollView.subviews)
        {
            if ([shadowView isKindOfClass:[UIImageView class]])
            {
                shadowView.hidden = YES;
            }
        }
        
        _bridge = [SlateWebridge sharedBridge];
    }
    return self;
}

- (void)loadRequest:(NSURLRequest *)request
{
    [super loadRequest:request];
    
    self.requestToLoad = request;
}

#pragma mark - webridge

- (void)evalJSCommand:(NSString *)jsCommand jsParams:(id)jsParams completionHandler:(void (^)(id, NSError *))completionHandler
{
    [_bridge evalJSCommand:jsCommand jsParams:jsParams completionHandler:completionHandler webView:self];
}

#pragma mark - unload

- (void)unload
{
    [self stopLoading];
    self.delegate = nil;
    if ([[UIDevice currentDevice].systemVersion intValue] >= 7.0 && [[UIDevice currentDevice].systemVersion intValue] < 9.0)
    {
        self.scrollView.delegate = nil;
    }
}

#pragma mark - shouldStartLoadWithRequest

- (SlateWebViewShouldLoadType)shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL    clickNavType = (navigationType == UIWebViewNavigationTypeLinkClicked);
    BOOL    otherNavType = (navigationType == UIWebViewNavigationTypeOther);
    
    if (request.URL.fragment && self.request.mainDocumentURL)
    {
        NSURL *oldURL = [[NSURL alloc] initWithScheme:self.request.mainDocumentURL.scheme
                                                 host:self.request.mainDocumentURL.host
                                                 path:self.request.mainDocumentURL.path];
        NSURL *anchorURL = [[NSURL alloc] initWithScheme:request.URL.scheme
                                                    host:request.URL.host
                                                    path:request.URL.path];
        if ([oldURL.absoluteString isEqualToString:anchorURL.absoluteString])
        {
            // 打开本页锚点  linyize 2014.09.15
            return SlateWebViewShouldLoadTypeBuiltin;
        }
    }
    
    if (clickNavType || otherNavType)
    {
        if ([[request.URL.scheme lowercaseString] isEqualToString:@"tel"])
        {
            // 拨打电话
            return SlateWebViewShouldLoadTypeBuiltin;
        }
        
        if (otherNavType && [self isiFrameURL:request.URL])
        {
            // 加载iframe
            return SlateWebViewShouldLoadTypeBuiltin;
        }

        if ([[request.URL.scheme lowercaseString] isEqualToString:@"mailto"])
        {
            // 写邮件
            [[UIApplication sharedApplication] openURL:request.URL];
            return SlateWebViewShouldLoadTypeCustom;
        }
        
        if ([[request.URL.host lowercaseString] isEqualToString:@"itunes.apple.com"])
        {
            // 苹果商店链接
            [[UIApplication sharedApplication] openURL:request.URL];
            return SlateWebViewShouldLoadTypeCustom;
        }
        
        if (self.request == nil)
        {
            return SlateWebViewShouldLoadTypeBuiltin;
        }
        
        BOOL isAction = (clickNavType
                         || (![self isLoading]
                             && self.request != nil
                             && ![self.request.URL.absoluteString isEqualToString:self.requestToLoad.URL.absoluteString]));
        if (isAction)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(webViewShouldLoadAction:webView:)])
            {
                id<SlateWebViewDelegate> slateDelegate = (id<SlateWebViewDelegate>)self.delegate;
                if (![slateDelegate webViewShouldLoadAction:request.URL webView:self])
                {
                    return SlateWebViewShouldLoadTypeCustom;
                }
            }
        }
        
        if ([_bridge isWebridgeMessage:request.URL])
        {
            [_bridge handleWebridgeMessage:request.URL webView:self];
            return SlateWebViewShouldLoadTypeCustom;
        }

        if ([SlateURI canOpenURI:request.URL])
        {
            // 自定义uri
            [SlateURI openURI:request.URL];
            return SlateWebViewShouldLoadTypeCustom;
        }
        
        if (isAction)
        {
            return SlateWebViewShouldLoadTypeAction;
        }
    }
    
    return SlateWebViewShouldLoadTypeUnknown;
}

@end
