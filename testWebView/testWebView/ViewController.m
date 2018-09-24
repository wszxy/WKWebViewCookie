//
//  ViewController.m
//  testWebView
//
//  Created by Li Xiaofan on 2018/8/23.
//  Copyright © 2018 Li Xiaofan. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

static NSHTTPCookie *s_cookie;

@interface ViewController () <WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self reCreateWebView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:NULL];
}

- (void)reCreateWebView {
    if (_webView) {
        [_webView removeFromSuperview];
        _webView = nil;
    }
    if (_request) {
        _request = nil;
    }
    [self initializeWebView];
    [self initializeButtons];
    
    NSHTTPCookieStorage *cookieJar2 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[cookieJar2 setCookie:s_cookie];
    
    [self refreshWebView];
    _label.text = @"新建(普通)成功!";
}

- (void)reCreateWebViewWithScript {
    if (_webView) {
        [_webView removeFromSuperview];
        _webView = nil;
    }
    if (_request) {
        _request = nil;
    }
    [self initializeWebViewWithScript];
    [self initializeButtons];
    
    [self refreshWebView];
    _label.text = @"新建(带script)成功!";
}

- (void)refreshWebView {
    if (!_request) {
        self.request= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.101/index.php"]];
    }
    [_webView loadRequest:_request];
    _label.text = @"刷新成功!";
}

- (void)deleteCookiesFiles {
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    NSError *errors;
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    
    _label.text = @"清理磁盘成功!";
}

- (void)deleteCookiesStotage {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    _label.text = @"清理内存成功!";

}

- (void)initializeWebView {
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 200, 200, 200)];
    self.webView.backgroundColor = [UIColor yellowColor];
    self.webView.frame = self.view.bounds;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:_webView];
}

- (void)initializeWebViewWithScript {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 20.f;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    WKUserContentController *userContentController = config.userContentController;
    NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = 'name_test=%@';", @"Config setting"];
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 200, 200, 200) configuration:config];
    self.webView.backgroundColor = [UIColor yellowColor];
    self.webView.frame = self.view.bounds;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:_webView];
}

- (void)initializeButtons {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 100, 30)];
    clearButton.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    [clearButton setTitle:@"清理磁盘" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(deleteCookiesFiles) forControlEvents:UIControlEventTouchUpInside];
    [_webView addSubview:clearButton];
    
    UIButton *clearButton2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 60, 100, 30)];
    clearButton2.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    [clearButton2 setTitle:@"清理内存" forState:UIControlStateNormal];
    [clearButton2 addTarget:self action:@selector(deleteCookiesStotage) forControlEvents:UIControlEventTouchUpInside];
    [_webView addSubview:clearButton2];
    
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 100, 30)];
    newButton.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    [newButton setTitle:@"新建(普通)" forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(reCreateWebView) forControlEvents:UIControlEventTouchUpInside];
    [_webView addSubview:newButton];
    
    
    UIButton *newButton2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 140, 100, 30)];
    newButton2.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    [newButton2 setTitle:@"新建(带script)" forState:UIControlStateNormal];
    [newButton2 addTarget:self action:@selector(reCreateWebViewWithScript) forControlEvents:UIControlEventTouchUpInside];
    [newButton2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_webView addSubview:newButton2];
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 180, 100, 30)];
    refreshButton.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
    [_webView addSubview:refreshButton];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 200, 50)];
    _label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _label.textColor = [UIColor blackColor];
    _label.textAlignment = NSTextAlignmentCenter;
    
    [_webView addSubview:_label];
}

- (void)becomeActive {
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://10.129.19.55/index.php"]];
    NSHTTPCookieStorage *cookieJar2 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookieJar2.cookies) {
        NSLog(@"becomeActive-----NSHTTPCookieStorage中的cookie%@", cookie);
    }
}

#pragma mark - WKNavigationDelegate
//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"页面开始加载时调用。   2");
}
//内容返回时调用，得到请求内容时调用(内容开始加载) -> view的过渡动画可在此方法中加载
- (void)webView:(WKWebView *)webView didCommitNavigation:( WKNavigation *)navigation
{
    NSLog(@"内容返回时调用，得到请求内容时调用。 4");
}
//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation
{
    NSLog(@"页面加载完成时调用。 5");
}
//请求失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error1:%@",error);
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error2:%@",error);
}
//在请求发送之前，决定是否跳转 -> 该方法如果不实现，系统默认跳转。如果实现该方法，则需要设置允许跳转，不设置则报错。
//该方法执行在加载界面之前
//Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Completion handler passed to -[ViewController webView:decidePolicyForNavigationAction:decisionHandler:] was not called'
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
    //不允许跳转
    //    decisionHandler(WKNavigationActionPolicyCancel);
    NSLog(@"在请求发送之前，决定是否跳转。  1");
}
//在收到响应后，决定是否跳转（同上）
//该方法执行在内容返回之前
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    //读取wkwebview中的cookie 方法1
    for (NSHTTPCookie *cookie in cookies) {
        if (@available(iOS 11.0, *)) {
//            [_webView.configuration.websiteDataStore.httpCookieStore setCookie:cookie completionHandler:^{
//
//            }];
        } else {
            // Fallback on earlier versions
        }
        //[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        //NSLog(@"wkwebview中的cookie:%@", cookie);
        //s_cookie = cookie;
    }
    //读取wkwebview中的cookie 方法2 读取Set-Cookie字段
    NSString *cookieString = [[response allHeaderFields] valueForKey:@"Set-Cookie"];
    NSLog(@"wkwebview中的cookie:%@", cookieString);
    
    //看看存入到了NSHTTPCookieStorage了没有
    NSHTTPCookieStorage *cookieJar2 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieJar2.cookies) {
        NSLog(@"NSHTTPCookieStorage中的cookie%@", cookie);
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"接收到服务器跳转请求之后调用");
}
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"webViewWebContentProcessDidTerminate");
}

@end
