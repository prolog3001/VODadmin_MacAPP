//
//  MainScreenViewcontroller.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 08/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CartScreen;
@class VideoScreen;
@class ItemInfoScreen;
@class InfoScreen;
@class PdfScreen;
@class ActivityView;
#import "selectLessonScreen.h"
#import "MoreAppsScreen.h"
#import "CustomFontButton.h"

@interface MainScreenViewcontroller : NSViewController <selectLessonScreenDelegate , NSAnimationDelegate , moreAppsScreenDelegate>
{
    IBOutlet NSView *mMiddleScreen;
    IBOutlet CartScreen *mCartScreen;
    IBOutlet VideoScreen *mVideoScreen;
    IBOutlet selectLessonScreen *mSelectLessonScreen;
    IBOutlet ItemInfoScreen *mItemInfoScreen;
    IBOutlet InfoScreen *mInfoScreen;
    IBOutlet PdfScreen *mPdfScreen;
    IBOutlet MoreAppsScreen *mMoreAppsScreen;
    IBOutlet ActivityView *mActivityView;
    IBOutlet NSButton *mYellowTopArrow;
    IBOutlet NSButton *mInfoButton;
    IBOutlet NSButton *mCartButton;
    IBOutlet CustomFontButton *mPlusButton;
    IBOutlet NSImageView  *mGreenVImage;
    NSMutableArray *mItemsRectArr;
    NSArray *mEnvScreensArr;
    NSSize mNewWindowSize;
    NSSize mOriginalSize;
    BOOL mInit;
    int mCurrentLessonShown;
    NSViewAnimation *mMoreAppsAnim;
    NSViewAnimation *mMoreAppsAnimShow;
    NSViewAnimation *mPdfFullAnim;
    NSViewAnimation *mSelectLessonAnim;
    
    IBOutlet NSView *mBannerView;
    IBOutlet NSImageView *mBannerImage;
    BOOL mLessonBeingActivated;
}


-(IBAction)cartPressed:(id)sender;
-(IBAction)selectLessonPressed:(id)sender;
-(IBAction)playMoviePressed:(id)sender;
-(IBAction)infoPressed:(id)sender;
-(IBAction)moreAppsPressed:(id)sender;
-(IBAction)pdfPressed:(id)sender;
-(IBAction)closeMoreAppsPressed:(id)sender;
-(IBAction)bannerPressed:(id)sender;
-(void)needAnimationBack:(NSView *)AV withDuration:(NSTimeInterval)animTime andItemIdx:(int)itemIdx;
-(void)windowWillResize:(NSSize)frameSize;
-(void)pdfFullScreenPressed;
-(void)pdfSharePressedWithLink:(NSString *)pdfLink;
@end
