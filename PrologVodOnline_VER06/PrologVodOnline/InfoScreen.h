//
//  InfoScreen.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 14/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomFontLabel.h"

@interface InfoScreen : NSView
{
    IBOutlet NSImageView *mProductIcon;
    IBOutlet NSButton *mProductIconBtn;
    IBOutlet CustomFontLabel *mTitle;
    IBOutlet NSTextView *mTextView;
    IBOutlet NSScrollView *mScrollView;
    IBOutlet CustomFontLabel *mMakatLabel;
    BOOL mNeedToUpdateContent;
}
-(void)viewDidAppear;
@end
