//
//  selectLessonScreen.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 10/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "selectLessonScreen.h"
#import "ServiceManager.h"
#import "TextManager.h"
#import "CommonDefs.h"
#import "FlippedView.h"
#import "MiscFunc.h"

@implementation selectLessonScreen

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    //[[NSColor blueColor] setFill];// oded change here
    //[[NSColor colorWithRed:0/255.0f green:185/255.0f blue:242/255.0f alpha:1.0f] setFill];
    [[NSColor colorWithRed:0/255.0f green:198/255.0f blue:245/255.0f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    
    // Drawing code here.
}
- (void)awakeFromNib {
    /*
    for(NSView *view in [self subviews]) {
        NSRect frame = [view frame];
        frame.origin.y = NSMaxY([self bounds]) - NSMaxY([view frame]);
        [view setFrame:frame];
    }
     */
    TextManager *textM = [TextManager textmanager];
    BOOL RTL = [[ServiceManager serviceManager] RTL];
    if(RTL)
        [mTitle setAlignment:NSTextAlignmentRight];
    else
        [mTitle setAlignment:NSTextAlignmentLeft];
    [mTitle setStringValue:textM.selectALesson];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseDetailsDownlodedNotification) name:CourseDetailsDownlodedNotification object:nil];
}
-(void)viewDidAppear
{
    [mScrollView flashScrollers];
}
-(void)courseDetailsDownlodedNotification
{
    NSLog(@"courseDetailsDownlodedNotification");
    [self updateContent];
}
//-(void)viewDidEndLiveResize
-(void)viewWillLayout
{
    //[super viewDidEndLiveResize];
}
-(void)updateContent
{
    if(!mScrollView)
        return;
    if(mScrollerItems)
    {
        for (int i = 0; i < [mScrollerItems count]; ++i)
        {
            NSView *v = [mScrollerItems objectAtIndex:i];
            [v removeFromSuperview];
        }
        [mScrollerItems removeAllObjects];
    }
    ServiceManager *serviceM = [ServiceManager serviceManager];
    int numOffLessons = [serviceM numOfLessons];
    int yPos = mTitle.frame.origin.y + mTitle.frame.size.height;
    int firstXGap = 36;
    int firstYGap = 36;
    int itemW = 76;
    int itemH = 54;
    int itemsXGap = 5;
    int itemsYGap = itemsXGap;
    int xPos = firstXGap;
    yPos = firstYGap;
    //int www = mScrollView.frame.size.width;
    int numOfItemInW = round((mScrollView.frame.size.width - (firstXGap * 2)) / (itemW + itemsXGap));
    if(numOfItemInW == 0)
        return;
    firstXGap = round((mScrollView.frame.size.width - (numOfItemInW*(itemW + itemsXGap))) / 2);
    xPos = firstXGap;
    
    //CGRect rect = mScrollView.frame;
    //int numOfItemInH = round(mScrollView.frame.size.height - (firstYGap * 2) / (itemH + itemsYGap));
    int numberOfLines = 0;
    if(!mScrollerItems)
    {
        mScrollerItems = [[NSMutableArray alloc] init];
    }
    mCurrentSelectedLesson = 0;
    TextManager *textM = [TextManager textmanager];
    if([[ServiceManager serviceManager] isThisLessonFreeOrPurchased:mCurrentSelectedLesson])
    {
        [mBottomLabel setStringValue:textM.clickLesson];
    }
    else
    {
        [mBottomLabel setStringValue:textM.itemNotAvailable];
    }
    //mBottomLabel.text = textM.clickLesson;
    [mBottomLabel setStringValue:textM.clickLesson];
    FlippedView *contentView = [[FlippedView alloc] initWithFrame:CGRectMake(0, 0, mScrollView.frame.size.width, mScrollView.frame.size.height) ];
    for (int i = 0; i < numOffLessons; ++i)
    {
        NSView *v = [[NSView alloc] initWithFrame:CGRectMake(xPos, yPos, itemW, itemH)];
        [v setWantsLayer:YES];
        v.layer.borderWidth = 0.0;
        if(i == 0)
        {
            //v.backgroundColor = [NSColor grayColor];
            // oded changed [v.layer setBackgroundColor:[[NSColor grayColor] CGColor]];
            [v.layer setBackgroundColor:[[NSColor yellowColor] CGColor]];
        }
        else
        {
            //v.backgroundColor = [NSColor whiteColor];
            [v.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
        }
        CGRect rect = CGRectMake(0, 0, v.frame.size.width, v.frame.size.height);
        if([serviceM isThisLessonFree:i])
        {
            //UIImageView *vIcon = [[UIImageView alloc] initWithFrame:CGRectMake(round(v.frame.size.width/2), 0, 14, 14)];
            NSImageView *vIcon = [[NSImageView alloc] initWithFrame:rect];
            vIcon.image = [NSImage imageNamed:@"Present_FREE50_icon.png"];
            [v addSubview:vIcon];
            
        }
        
        //CustomFontLabel *numberLbl = [[CustomFontLabel alloc] initWithFrame:CGRectMake(10, 0, v.frame.size.width, v.frame.size.height - 8)];
        NSTextField *numberLbl = [[NSTextField alloc] initWithFrame:CGRectMake(4, 10, v.frame.size.width-8, v.frame.size.height-30)];
        [numberLbl setFont:[NSFont fontWithName:[MiscFunc fontWithIndex:FontIndexArimo ] size:10]];
        [numberLbl setAlignment:NSTextAlignmentCenter];
        [numberLbl.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
        [numberLbl setBackgroundColor:[NSColor clearColor]];
        [numberLbl setDrawsBackground:YES];
        [numberLbl setBordered:NO];
        /*
         [textField setFont:[NSFont fontWithName:@"Arial" size:48]];
         [textField setTextColor:[NSColor whiteColor]];
         [textField setStringValue:@"Some Text"];
         [textField setBackgroundColor:[NSColor blackColor]];
         [textField setDrawsBackground:YES];
         [textField setBordered:NO];
         */
        //numberLbl.numberOfLines = 0;
        //numberLbl.textAlignment =  NSTextAlignmentCenter;
        /*
        if(IS_IPAD)
            numberLbl.font = [UIFont fontWithName:[MiscFunc fontWithIndex:FontIndexArimo] size:12.0];
        else
            numberLbl.font = [UIFont fontWithName:[MiscFunc fontWithIndex:FontIndexArimo] size:8.0];
         */
        //numberLbl.text = [NSString stringWithFormat:@"%d", (i+1)];
        [numberLbl setStringValue:[serviceM vimeoLessonItemTitle:i]];
        //numberLbl.text = [serviceM vimeoLessonItemTitle:i];
        //numberLbl.shadowColor = [UIColor clearColor];
        [v addSubview:numberLbl];
        
        //UIButton *gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSButton *gotoBtn = [[NSButton alloc] init];
        [gotoBtn setStringValue:@""];
        [[gotoBtn cell] setBackgroundColor:[NSColor clearColor]];
        [[gotoBtn cell] setTitle:@""];
        //[gotoBtn addTarget:self action:@selector(lessonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [gotoBtn setTarget:self];
        [gotoBtn setAction:@selector(lessonPressed:)];
        //[gotoBtn setBackgroundColor:[UIColor clearColor]];
        //CGRect rect = CGRectMake(0, 0, v.frame.size.width, v.frame.size.height);
        gotoBtn.frame = rect;
        gotoBtn.tag = i;
        //[gotoBtn setWantsLayer:YES];
        gotoBtn.bordered = NO;
        //gotoBtn.bezelStyle = NSRoundedBezelStyle;
        /*
        gotoBtn.layer.borderWidth = 0.0;
         gotoBtn.layer.borderColor = [[NSColor clearColor] CGColor];
        gotoBtn.layer.borderWidth = 1.0f;
        gotoBtn.layer.borderColor = [[NSColor clearColor] CGColor];
        gotoBtn.layer.cornerRadius = 3.0;
         */
        [v addSubview:gotoBtn];
        /*
        if([serviceM isThisLessonFree:i])
        {
            //UIImageView *vIcon = [[UIImageView alloc] initWithFrame:CGRectMake(round(v.frame.size.width/2), 0, 14, 14)];
            NSImageView *vIcon = [[NSImageView alloc] initWithFrame:rect];
            vIcon.image = [NSImage imageNamed:@"Present_FREE50_icon.png"];
            [v addSubview:vIcon];
            
        }
         */
        v.layer.borderWidth = 1.0f;
        v.layer.borderColor = [[NSColor clearColor] CGColor];
        v.layer.cornerRadius = 3.0;
        
        [mScrollerItems addObject:v];
        //[mScrollView addSubview:v];
        [contentView addSubview:v];
        xPos += itemW + itemsXGap;
        if((i + 1) % numOfItemInW == 0)
        {
            yPos = yPos + itemH + itemsYGap;
            xPos = firstXGap;
            numberOfLines += 1;
        }
    }
    CGFloat _height = (numberOfLines + 2) * itemH + (numberOfLines + 2) * itemsYGap;
    //[mScrollView setContentSize:CGSizeMake(0, _height)];
    //mScrollView.contentSize = CGSizeMake(0, _height);
    //[mScrollView.documentView setFrame: NSMakeRect(0,0,mScrollView.frame.size.width, _height) ];
    //[mScrollView.documentView setFrame: NSMakeRect(0,0,mScrollView.frame.size.width, 2000) ];
    contentView.frame = NSMakeRect(0, 0, mScrollView.frame.size.width-26, _height);
    [mScrollView setWantsLayer:YES];
    //mScrollView.layer.backgroundColor = [[NSColor blueColor] CGColor];
    //mScrollView.backgroundColor = [NSColor clearColor];
    [mScrollView  setDocumentView :contentView];
    mScrollView.scrollerStyle = NSScrollerStyleOverlay;
    
}

-(IBAction)lessonPressed:(id)sender
{
    NSLog(@"lessonPressed %d",(int)((NSButton *)sender).tag);
    TextManager *textM = [TextManager textmanager];
    int btnIndex = (int)((NSButton *)sender).tag;
    if([[ServiceManager serviceManager] isThisLessonFreeOrPurchased:btnIndex])
    {
        //mBottomLabel.text = textM.clickLesson;// @"Click lesson again to enter it";
        [mBottomLabel setStringValue:textM.clickLesson];
    }
    else
    {
        //mBottomLabel.text = textM.itemNotAvailable;// @"This item is available only after purchase";
        [mBottomLabel setStringValue:textM.itemNotAvailable];
    }
    if(mCurrentSelectedLesson == btnIndex && [[ServiceManager serviceManager] isThisLessonFreeOrPurchased:btnIndex])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(lessonActivated:)])
            [_delegate lessonActivated:btnIndex];
        return;
    }
    mCurrentSelectedLesson = btnIndex;
    for (int i = 0; i < [mScrollerItems count]; ++i)
    {
        NSView *v = [mScrollerItems objectAtIndex:i];
        if(i == (int)((NSButton *)sender).tag)
        {
            //v.backgroundColor = [UIColor grayColor];
            // oded changed [v.layer setBackgroundColor:[[NSColor grayColor] CGColor]];
            [v.layer setBackgroundColor:[[NSColor yellowColor] CGColor]];
            
        }
        else
        {
            //v.backgroundColor = [UIColor whiteColor];
            [v.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
        }
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(lessonSelected:)])
        [_delegate lessonSelected:(int)((NSButton *)sender).tag];
}

/*
- (BOOL)isFlipped
{
    return YES;
}
 */
/*

 */
@end
