//
//  MoreAppsScreen.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 16/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomFontButton.h"
#import "CustomFontLabel.h"

@protocol moreAppsScreenDelegate;

@interface MoreAppsScreen : NSView
{
    IBOutlet NSScrollView *mScrollView;
    IBOutlet NSTextField *mDownLablel;
    IBOutlet NSButton *mCloseBtn;
    NSMutableArray *mRadioImagesArray;
    NSMutableArray *mItemsTitlesArray;
    NSMutableArray *mVImagesArray;
    int mCurrentCheckedCourse;
    IBOutlet CustomFontButton* mGetThisAppBtn;
    IBOutlet CustomFontLabel *mTitle;
    BOOL mAlreadyInit;
}

@property (nonatomic, assign) id <moreAppsScreenDelegate> delegate;
-(void)setScreen;
-(void)updateScreen;
-(void)viewWillLayout;
-(IBAction)getThisAppPressed:(id)sender;
-(void)viewDidAppear;
@end
@protocol moreAppsScreenDelegate <NSObject>
@optional
-(void)appSelected:(int)appIndex;
@end