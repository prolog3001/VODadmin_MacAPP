//
//  PdfScreen.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 14/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>
#import "CustomFontLabel.h"
@class MainScreenViewcontroller;

@interface PdfScreen : NSView
{
    //IBOutlet WebView *mWebView;
    WKWebView *mWebView;
    int mCurrentPdfFileIndex;
    IBOutlet NSView *mTopView;
    BOOL mAlreadyInit;
    BOOL mCurrentPageChanged;
    BOOL mLoading;
    IBOutlet CustomFontLabel *mTitle;
    IBOutlet CustomFontLabel *mBottomLabel;
    //IBOutlet UIButton *mFullScreenBtn;
    IBOutlet NSButton *mShareBtn;
    BOOL mIsVisiable;
}
@property (nonatomic, assign) MainScreenViewcontroller *mParent;
@property (nonatomic, assign) IBOutlet NSButton *mFullScreenBtn;
@property (nonatomic, assign) BOOL mFullScreenMode;
-(void)viewDidAppear;
-(void)viewDidDisappear;
//-(IBAction)topViewPressed:(id)sender;
-(IBAction)plusPressed:(id)sender;
-(IBAction)fullScreenPressed:(id)sender;
//-(IBAction)sharePressed:(id)sender;
-(void)updateContent;
@end
