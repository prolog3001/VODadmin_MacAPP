//
//  InfoScreen.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 14/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "InfoScreen.h"
#import "CommonDefs.h"
#import "ServiceManager.h"
#import "MiscFunc.h"
#import "NSImageView+WebCache.h"

@implementation InfoScreen

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor grayColor] setFill];
    NSRectFill(dirtyRect);
    
    // Drawing code here.
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    //mAlreadyInit = NO;
    mNeedToUpdateContent = NO;
    [mMakatLabel setWantsLayer:YES];
    [mMakatLabel setBackgroundColor:[NSColor yellowColor]];
    [mMakatLabel setDrawsBackground:YES];
    [mMakatLabel.layer setCornerRadius:4.0];
    [mTitle setWantsLayer:YES];
    [mTitle setBackgroundColor:[NSColor yellowColor]];
    [mTitle setDrawsBackground:YES];
    
    //[mMakatLabel setBordered:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseDetailsDownlodedNotification) name:CourseDetailsDownlodedNotification object:nil];
}
-(void)updateContent
{
    [mTextView setTextColor:[NSColor blackColor]];
    [mTextView setBackgroundColor:[NSColor clearColor]];
    [mTextView setDrawsBackground:YES];

    ServiceManager *serviceM = [ServiceManager serviceManager];
    NSString *imageUrl = [serviceM productIcon];//[NSString stringWithFormat:@"%@%@",[serviceM productBaseURL],[serviceM productIcon]];
    
    [mProductIcon setImageURL:[NSURL URLWithString:imageUrl]];
    
    //[mProductIconBtn setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
    [mTitle setStringValue:[serviceM productName]];
    //mTitle.text = [serviceM productName];
    //mTextView.showsVerticalScrollIndicator = YES;
    [mTextView setString:[serviceM productDescription]];
    //mTextView.text = [serviceM productDescription];
    //mMakatLabel.font = [UIFont fontWithName:[MiscFunc fontWithIndex:(int)mMakatLabel.tag] size:9.0];
    //[mMakatLabel setFont:[NSFont fontWithName:[MiscFunc fontWithIndex:(int)mMakatLabel.tag] size:9.0]];
    [mMakatLabel setStringValue:[NSString stringWithFormat:@"#%@", [serviceM productMakat]]];
    //mMakatLabel.text = [NSString stringWithFormat:@"#%@", [serviceM productMakat]];
    if([serviceM productLTRDirection])
    {
        //mTextView.textAlignment = NSTextAlignmentLeft;
        [mTextView setAlignment:NSTextAlignmentLeft];
    }
    else
    {
        //mTextView.textAlignment = NSTextAlignmentRight;
        [mTextView setAlignment:NSTextAlignmentLeft];
    }
    mScrollView.scrollerStyle = NSScrollerStyleOverlay;
    //mScrollView.scrollerKnobStyle = NSScrollerKnobStyleLight;
    //[mScrollView flashScrollers];
    
}
-(void)courseDetailsDownlodedNotification
{
    DLog(@"courseDetailsDownlodedNotification");
    mNeedToUpdateContent = YES;
    [self updateContent];
}
-(void)viewDidAppear
{
    [mScrollView flashScrollers];
}
@end
