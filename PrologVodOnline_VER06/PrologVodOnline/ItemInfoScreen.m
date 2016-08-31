//
//  ItemInfoScreen.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 11/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "ItemInfoScreen.h"

@implementation ItemInfoScreen

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(void)updateContent:(NSString *)title Desc:(NSString *)desc andDir:(BOOL)LTR
{
    //[mTextView setHasHorizontalScroller:YES];
    //[[mTextView horizontalScroller] setAlphaValue:0];
    [mTextView setTextColor:[NSColor whiteColor]];
    //mTextView.contents
    //[mTitle setFont:[NSFont fontWithName:@"Lucida Grande" size:8]];
    
    [mTitle.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    [mTitle setBackgroundColor:[NSColor clearColor]];
    [mTitle setDrawsBackground:YES];
    [mTitle setBordered:NO];
    if(LTR)
    {
        [mTitle setAlignment:NSTextAlignmentLeft];
        [mTextView setAlignment:NSTextAlignmentLeft];
    }
    else
    {
        [mTitle setAlignment:NSTextAlignmentRight];
        [mTextView setAlignment:NSTextAlignmentRight];
    }
    [mTitle setStringValue:title];
    [mTextView setString:desc];
    mScrollView.scrollerStyle = NSScrollerStyleOverlay;
    mScrollView.scrollerKnobStyle = NSScrollerKnobStyleLight;
    [mScrollView flashScrollers];
    //mTextView.scrollerStyle = NSScrollerStyleOverlay;
    //mTextView.docu
    //[mTextView setContentOffset:CGPointZero animated:NO];
    //mTextView.scrollerStyle = NSScrollerStyleOverlay;
}

@end
