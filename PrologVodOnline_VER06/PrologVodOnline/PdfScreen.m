//
//  PdfScreen.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 14/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "PdfScreen.h"
#import "CommonDefs.h"
#import "ServiceManager.h"
#import "MiscFunc.h"
#import "MainScreenViewcontroller.h"
#import "TextManager.h"

@implementation PdfScreen

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor grayColor] setFill];
    NSRectFill(dirtyRect);
    
    // Drawing code here.
}- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.frame configuration:theConfiguration];
    webView.frame = CGRectMake(0, 50, self.frame.size.width, self.frame.size.height - 50);
    //[webView setWantsLayer:YES];
    //webView.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    //webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    //[webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    //webView.navigationDelegate = self;
    
    //NSURL *nsurl=[NSURL URLWithString:@"http://www.apple.com"];
    //NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    //[webView loadRequest:nsrequest];
    
    webView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    /*
     view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleBottomMargin;
     */
    //webView.UIDelegate
    mWebView = webView;
    [self addSubview:webView];
    
    mAlreadyInit = NO;
    mLoading = NO;
    mCurrentPageChanged = YES;
    mCurrentPdfFileIndex = 0;
    _mFullScreenMode = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseDetailsDownlodedNotification) name:CourseDetailsDownlodedNotification object:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == mWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"observeValueForKeyPath");
        NSLog(@"%@",change);
        mLoading = NO;
        mWebView.hidden = NO;
        //[MiscFunc HideActivityView];
    }
}
-(void)updateContent
{
    
    mCurrentPageChanged = NO;
    //mWebView.scalesPageToFit = YES;
    //mWebView.delegate = self;
    NSString *pdfLink = [[ServiceManager serviceManager] pdfItemUrl:mCurrentPdfFileIndex];
    DLog(@"pdfLink = %@",pdfLink);
    NSURL *url = [NSURL URLWithString:pdfLink];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //mTitle.text = [[ServiceManager serviceManager] pdfItemTitle:mCurrentPdfFileIndex];
    [mTitle setStringValue:[[ServiceManager serviceManager] pdfItemTitle:mCurrentPdfFileIndex]];
    if(![[ServiceManager serviceManager] isThisPdfFreeOrPurchased:mCurrentPdfFileIndex])
    {
        mWebView.hidden = YES;
        mBottomLabel.hidden = NO;
        _mFullScreenBtn.hidden = YES;
        mShareBtn.hidden = YES;
        return;
    }
    mWebView.hidden = NO;
    //mBottomLabel.text = ((TextManager *)[TextManager textmanager]).itemNotAvailable;
    mBottomLabel.hidden = YES;
    _mFullScreenBtn.hidden = NO;
    mShareBtn.hidden = NO;
    /*
    if(!mLoading)
    {
        //[mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        mWebView.hidden = YES;
        mLoading = YES;
        //[MiscFunc ShowActivityView:self];
        [mWebView loadRequest:request];
    }
     */
    [mWebView loadRequest:request];
    
    //}
    
    
    
}
-(void)courseDetailsDownlodedNotification
{
    DLog(@"courseDetailsDownlodedNotification");
    mCurrentPdfFileIndex = 0;
    [self updateContent];
}
- (void)mouseDown:(NSEvent *)theEvent{
    //Do nothing to not propagate the click event to descendant views
}

- (BOOL)isFlipped
{
    return YES;
}
-(void)viewDidAppear
{
    mIsVisiable = YES;
}
-(IBAction)fullScreenPressed:(id)sender
{
    [self.mParent pdfFullScreenPressed];
}
-(IBAction)plusPressed:(id)sender
{
    //[MiscFunc HideActivityView];
    int numOfPdf = [[ServiceManager serviceManager] numOfCoursePdfs];
    mCurrentPdfFileIndex = (mCurrentPdfFileIndex + 1) % numOfPdf;
    mCurrentPageChanged = YES;
    [self updateContent];
}
-(IBAction)sharePressed:(id)sender
{
    NSString *pdfLink = [[ServiceManager serviceManager] pdfItemUrl:mCurrentPdfFileIndex];
    [self.mParent pdfSharePressedWithLink:pdfLink];
}
/*
-(void)viewDidDisappear
{
    //DLog(@"viewDidDisappear viewDidDisappear viewDidDisappear");
    mIsVisiable = NO;
    if(mWebView)
    {
        mLoading = NO;
        [mWebView stopLoading];
        [MiscFunc HideActivityView];
        
    }
}
 */
@end
