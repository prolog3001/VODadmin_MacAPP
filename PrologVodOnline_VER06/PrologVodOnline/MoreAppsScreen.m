//
//  MoreAppsScreen.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 16/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "MoreAppsScreen.h"
#import "ServiceManager.h"
#import "CommonDefs.h"
#import "NSImageView+WebCache.h"
#import "MiscFunc.h"
#import "IAPManager.h"
#import "TextManager.h"
#import "NSImageView+WebCache.h"
#import "FlippedView.h"



@implementation MoreAppsScreen

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    
    // Drawing code here.
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    mAlreadyInit = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productWasPurchasedNotification) name:ProductWasPurchasedNotification object:nil];
}
- (void)mouseDown:(NSEvent *)theEvent{
    //Do nothing to not propagate the click event to descendant views
}
-(void)productWasPurchasedNotification
{
    if(mVImagesArray)
    {
        for (int i = 0; i < [mVImagesArray count]; ++i) {
            NSImageView *VIcon = [mVImagesArray objectAtIndex:i];
            if([[IAPManager iapManager] isThisCoursedPurchased:(int)VIcon.tag])
            {
                VIcon.hidden = NO;
            }
            else
            {
                VIcon.hidden = YES;
            }
        }
    }
}
-(void)viewDidAppear
{
    [mScrollView flashScrollers];
}
-(void)viewWillLayout
{
    if(!mAlreadyInit)
    {
        mAlreadyInit = YES;
        TextManager *textM = [TextManager textmanager];
        ServiceManager *serviceM = [ServiceManager serviceManager];
        if([serviceM hasMoreApps])
        {
            [self buildScrollerIfNeeded];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreAppsIconsDownlodedNotification) name:MoreAppsIconsDownlodedNotification object:nil];
        }
        mGetThisAppBtn.layer.borderWidth = 1.0f;
        mGetThisAppBtn.layer.borderColor = [ITEMS_COUNTUR_COLOR CGColor];
        //mGetThisAppBtn.layer.borderColor = [[NSColor clearColor] CGColor];
        [mGetThisAppBtn setTitle:textM.getThisApp];
        [mGetThisAppBtn setTitle:textM.getThisApp];
        [mGetThisAppBtn setTitleColor:[NSColor whiteColor]];
        //mGetThisAppBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        BOOL RTL = [[ServiceManager serviceManager] RTL];
        if(RTL)
            [mTitle setAlignment:NSTextAlignmentRight];
            //mTitle.textAlignment = NSTextAlignmentRight;
        else
            mTitle.alignment = NSTextAlignmentLeft;
        [mTitle setStringValue:textM.moreAppsTitle];
        [mDownLablel setStringValue:textM.wouldLikeGetThisApp];
        //mTitle.text = textM.moreAppsTitle;
        //mDownLablel.text = textM.wouldLikeGetThisApp;
        //CGRect rect1 = mDownLablel.frame;
        //int a = 8;
        //mDownLablel.backgroundColor = [UIColor redColor];
        
    }
    mScrollView.scrollerStyle = NSScrollerStyleOverlay;
    mScrollView.scrollerKnobStyle = NSScrollerKnobStyleLight;
    
}
-(void)moreAppsIconsDownlodedNotification
{
    [self buildScrollerIfNeeded];
}
-(void)buildScrollerIfNeeded
{
    //if(mAlreadyInit)
     //   return;
    mAlreadyInit = YES;
    if(!mRadioImagesArray)
    {
        mRadioImagesArray = [[NSMutableArray alloc] init];
    }//mItemsTitlesArray
    if(!mItemsTitlesArray)
    {
        mItemsTitlesArray = [[NSMutableArray alloc] init];
    }//
    if(!mVImagesArray)
    {
        mVImagesArray = [[NSMutableArray alloc] init];
    }
    ServiceManager *serviceM = [ServiceManager serviceManager];
    NSArray *numOffApps = [serviceM prologIDs];
    int yPos = mCloseBtn.frame.origin.y + mCloseBtn.frame.size.height;
    FlippedView *contentView = [[FlippedView alloc] initWithFrame:CGRectMake(0, 0, mScrollView.frame.size.width, mScrollView.frame.size.height) ];
    /*
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, mDownLablel.frame.origin.y - yPos)];
    //CGRect rect1 = mDownLablel.frame;
    //CGRect rect = CGRectMake(0, yPos, self.frame.size.width, mDownLablel.frame.origin.y - yPos);
    mScrollView.backgroundColor = [UIColor clearColor];
    mScrollView.pagingEnabled = NO;
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.showsVerticalScrollIndicator = NO;
    mScrollView.scrollsToTop = NO;
    mScrollView.scrollEnabled = YES;
    mScrollView.delaysContentTouches = YES;
     */
    yPos = 20;
    int iconWidth = 60;
    int iconHeight = 60;
    int gapBetweenIcons = 20;
    /*
    if(IS_IPAD)
    {
        iconWidth = 120;
        iconHeight = 120;
        gapBetweenIcons = 40;
    }
     */
    CGRect itemRect =CGRectMake(round(mScrollView.frame.size.width/2) - round(iconWidth/2), yPos, iconWidth, iconHeight);
    for (int i = 0; i < [numOffApps count]; ++i) {
        
        NSView *v = [[NSView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, iconHeight)];
        //[v setWantsLayer:YES];
        [v.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
        v.layer.borderWidth = 2.0;
        v.layer.borderColor = [[NSColor clearColor] CGColor];
        //v.backgroundColor = [UIColor clearColor];
        CGRect radioImageRect = CGRectMake(round(v.frame.size.width / 4) - 20, round(v.frame.size.height / 2) - 20/2, 20, 20);
        /*
        if(IS_IPAD)
        {
            radioImageRect = CGRectMake(round(v.frame.size.width / 4) - 40, round(v.frame.size.height / 2) - 40/2, 40, 40);
        }
         */
        NSImageView *radioIcon = [[NSImageView alloc] initWithFrame:radioImageRect];
        radioIcon.tag = i;
        [mRadioImagesArray addObject:radioIcon];
        /*
         if([serviceM currentCourseIndex] == i)
         {
         radioIcon.image = [UIImage imageNamed:@"Radio_ON_icon.png"];
         mCurrentCheckedCourse = i;
         }
         else
         {
         radioIcon.image = [UIImage imageNamed:@"Radio_OFF_icon.png"];
         }
         */
        [v addSubview:radioIcon];
        CGRect productImageRect = CGRectMake(radioIcon.frame.origin.x + radioIcon.frame.size.width + 10, round(v.frame.size.height / 2) - round(iconHeight / 2), iconWidth, iconHeight);
        NSImageView *appIcon = [[NSImageView alloc] initWithFrame:productImageRect];
        //appIcon.image = [UIImage imageNamed:[serviceM moreAppIconImage:i]];
        NSString *imageUrl = [serviceM moreAppIconImage:[[serviceM prologIDs] objectAtIndex:i]];
        
        [appIcon setImageURL:[NSURL URLWithString:imageUrl]];
        [v addSubview:appIcon];
        CGRect productTitleRect = CGRectMake(appIcon.frame.origin.x + appIcon.frame.size.width + 10, round(v.frame.size.height / 2) - round(iconHeight / 2), v.frame.size.width - v.frame.origin.x - (appIcon.frame.origin.x + appIcon.frame.size.width + 10), iconHeight-20);
        CustomFontLabel *productLabel = [[CustomFontLabel alloc] initWithFrame:productTitleRect];
        /*
        productLabel.numberOfLines = 0;
        productLabel.backgroundColor = [UIColor clearColor];
        if(IS_IPAD)
            productLabel.font = [UIFont fontWithName:[MiscFunc fontWithIndex:FontIndexArimoItalic] size:20.0];
        else
            productLabel.font = [UIFont fontWithName:[MiscFunc fontWithIndex:FontIndexArimoItalic] size:12.0];
        productLabel.textColor = [UIColor whiteColor];
        productLabel.text = [serviceM moreAppIconTitle:[[serviceM prologIDs] objectAtIndex:i]];
        productLabel.tag = i;
         */
        [productLabel setFont:[NSFont fontWithName:[MiscFunc fontWithIndex:0] size:20.0]];
        [productLabel setAlignment:NSTextAlignmentLeft];
        [productLabel.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
        [productLabel setBackgroundColor:[NSColor clearColor]];
        [productLabel setDrawsBackground:YES];
        [productLabel setBordered:NO];
        [productLabel setStringValue:[serviceM moreAppIconTitle:[[serviceM prologIDs] objectAtIndex:i]]];
        [productLabel setTextColor:[NSColor whiteColor]];
        productLabel.tag = i;
        if([serviceM currentCourseIndex] == i)
        {
            radioIcon.image = [NSImage imageNamed:@"Radio_ON_icon.png"];
            mCurrentCheckedCourse = i;
            productLabel.hidden = NO;
        }
        else
        {
            radioIcon.image = [NSImage imageNamed:@"Radio_OFF_icon.png"];
            productLabel.hidden = YES;
        }
        [mItemsTitlesArray addObject:productLabel];
        [v addSubview:productLabel];
        
        NSButton *vButton = [[NSButton alloc] init];
        
        [vButton setStringValue:@""];
        [vButton setTitle:@""];
        [[vButton cell] setBackgroundColor:[NSColor clearColor]];
        [[vButton cell] setBordered:NO];
        [[vButton cell] setStringValue:@""];
        
        [vButton setTarget:self];
        [vButton setAction:@selector(onCourseButtonTouch:)];
        
        
        vButton.frame = CGRectMake(0, 0, v.frame.size.width, v.frame.size.height);

        vButton.tag = i;
        vButton.layer.borderWidth = 0.0;
        [vButton setWantsLayer:YES];
        vButton.layer.backgroundColor = [[NSColor clearColor] CGColor];
        //vButton.layer.borderWidth = 2.0;
        //vButton.layer.borderColor = [[NSColor clearColor] CGColor];
        [v addSubview:vButton];
        
        CGRect checkedRect = radioIcon.frame;
        checkedRect.origin.y = 0;
        checkedRect.origin.x = appIcon.frame.origin.x + appIcon.frame.size.width + 8;
        NSImageView *checkIcon = [[NSImageView alloc] initWithFrame:checkedRect];
        checkIcon.image = [NSImage imageNamed:@"Check_icon_Green.png"];
        checkIcon.tag = i;
        [mVImagesArray addObject:checkIcon];
        [v addSubview:checkIcon];
        
        if([[IAPManager iapManager] isThisCoursedPurchased:i])
        {
            checkIcon.hidden = NO;
        }
        else
        {
            checkIcon.hidden = YES;
        }
        [contentView addSubview:v];
        
        /*
         [mScrollView addSubview:appIcon];
         
         UIImageView *gotoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(appIcon.frame.origin.x + appIcon.frame.size.width + 20, yPos, 30, 30)];
         gotoIcon.image = [UIImage imageNamed:@"GOTO_icon.png"];
         gotoIcon.center = CGPointMake(gotoIcon.center.x, appIcon.center.y);
         [mScrollView addSubview:gotoIcon];
         
         UIButton *gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         [gotoBtn addTarget:self action:@selector(onCourseButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
         [gotoBtn setBackgroundColor:[UIColor clearColor]];
         CGRect rect = CGRectMake(appIcon.frame.origin.x , yPos, gotoIcon.frame.origin.x + gotoIcon.frame.size.width - appIcon.frame.origin.x, appIcon.frame.size.height);
         gotoBtn.frame = rect;
         gotoBtn.tag = i;
         [mScrollView addSubview:gotoBtn];
         */
        
        yPos = yPos + iconHeight + gapBetweenIcons;
        itemRect.origin.y = yPos;
    }
    //CGFloat _height = (numberOfLines + 1) * itemHeight + (numberOfLines + 2) * spaceBetweenLines;
    contentView.frame = NSMakeRect(0, 0, mScrollView.frame.size.width - 30, yPos);
    [mScrollView  setDocumentView :contentView];
    //[mScrollView setHorizontalLineScroll:0.1];
    //mScrollView.enclosingScrollView.verticalScroller = nil;
    //mScrollView.scrollIndicatorInsets =  NSEdgeInsetsMake(0, 0, 0, 0);
    
    //[mScrollView setContentSize:CGSizeMake(0, yPos)];
    
    
}
-(void)onCourseButtonTouch:(id)sender
{
    int _tag = (int)((NSButton *)sender).tag;
    DLog(@"_tag = %d",_tag);
    for (int i = 0; i < [mRadioImagesArray count]; ++i) {
        NSImageView *radioIcon = [mRadioImagesArray objectAtIndex:i];
        if(radioIcon.tag == _tag)
        {
            radioIcon.image = [NSImage imageNamed:@"Radio_ON_icon.png"];
            mCurrentCheckedCourse = i;
        }
        else
        {
            radioIcon.image = [NSImage imageNamed:@"Radio_OFF_icon.png"];
        }
    }
    for (int i = 0; i < [mItemsTitlesArray count]; ++i)
    {
        CustomFontLabel *title = [mItemsTitlesArray objectAtIndex:i];
        if(title.tag == _tag)
        {
            title.hidden = NO;
        }
        else
        {
            title.hidden = YES;
        }
    }
    
}
-(IBAction)getThisAppPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(appSelected:)])
        [_delegate appSelected:mCurrentCheckedCourse];
}
@end
