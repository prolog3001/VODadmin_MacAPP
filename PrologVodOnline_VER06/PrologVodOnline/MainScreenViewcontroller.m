//
//  MainScreenViewcontroller.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 08/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "MainScreenViewcontroller.h"
#import "CartScreen.h"
#import "VideoScreen.h"
#import "selectLessonScreen.h"
#import "ServiceManager.h"
#import "CommonDefs.h"
#import "ItemInfoScreen.h"
#import "InfoScreen.h"
#import "PdfScreen.h"
#import "ActivityView.h"
#import "MKStoreKit.h"
#import "IAPManager.h"

@interface MainScreenViewcontroller ()

@end
typedef enum {
    GUIItemMiddleRect = 0,
} GUIItemsRects;
@implementation MainScreenViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    mInit = NO;
    mLessonBeingActivated = NO;
    mSelectLessonScreen.delegate = self;
    mMoreAppsScreen.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseDetailsDownlodedNotification) name:CourseDetailsDownlodedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKStoreKitProductPurchasedNotification:) name:kMKStoreKitProductPurchasedNotification object:nil];
    [self.view setWantsLayer:YES];
    [mMiddleScreen setWantsLayer:YES];
    [mActivityView setWantsLayer:YES];
    //mActivityView.alphaValue = 0.5;
   // mActivityView.layer.backgroundColor = [[NSColor orangeColor] CGColor];
    //mActivityView.hidden = NO;
    [mMiddleScreen.layer setBackgroundColor:[[NSColor blackColor] CGColor]];
    // Do view setup here.
    if(!mEnvScreensArr)
    {
        //mEnvScreensArr = [NSArray arrayWithObjects:mCartScreen,mInfoScreen,mSelectLessonScreen,mPdfScreen,mMoreAppsScreen, nil];
        mEnvScreensArr = [NSArray arrayWithObjects:mCartScreen,mInfoScreen,mSelectLessonScreen,mPdfScreen,mMoreAppsScreen, nil];
    }
    [[ServiceManager serviceManager] downlaodMoreAppsIcons];
    if([[ServiceManager serviceManager] hasContent])// lets refresh
    {
        int courseIndex = (int)[[[ServiceManager serviceManager] prologIDs] indexOfObject:[[ServiceManager serviceManager] currentPrologAppID]];
        
        //int currentAppIndex = (int)[[[ServiceManager serviceManager] currentPrologAppID] integerValue];
        [[ServiceManager serviceManager] downloadCourse:courseIndex WithAnim:NO andView:self.view];
        
    }
    else
    {
        [[ServiceManager serviceManager] downloadCourse:0 WithAnim:YES andView:self.view];
        [self showActivityView];
    }
    if([[ServiceManager serviceManager] isCurrentCoursePro])
    {
        mCartButton.hidden = YES;
        mGreenVImage.hidden = NO;
    }
    else
    {
        
        if([[ServiceManager serviceManager] needToShowBanner])
        {
            mBannerView.hidden = NO;
        }
        else
        {
            mBannerView.hidden = YES;
        }
        
        mCartButton.hidden = NO;
        mGreenVImage.hidden = YES;
    }
    mPdfScreen.mParent = self;
    //[[ServiceManager serviceManager] downloadCourse:0 WithAnim:YES andView:self.view];
    
}
-(void)MKStoreKitProductPurchasedNotification:(NSNotification *)notification
{
    DLog(@"MKStoreKitProductPurchasedNotification - %@",notification.object);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *purchasedProductID = notification.object;
        if([mCartScreen isDescendantOf:self.view])
        {
            //[self cartPressed:nil];
            //[self moveToCart];
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                context.duration = 0.6;
                mCartScreen.animator.alphaValue = 0;
                context.allowsImplicitAnimation = YES;
                //[[NSAnimationContext currentContext] setDuration:1.2];
                //[mMiddleScreen.animator.layer setAffineTransform: CGAffineTransformIdentity];
            }
                                completionHandler:^{
                                    //[self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_down.png"];
                                    //mInfoButton.alpha = 1.0;
                                    [mCartScreen removeFromSuperview];
                                    //[self changeBackgroundButtonImageWithAnim:mCartButton image:@"Basket_icon.png"];
                                }];
            [self needAnimationBack:mMiddleScreen withDuration:1 andItemIdx:GUIItemMiddleRect];
        }
        mCartButton.hidden = YES;
        mBannerView.hidden = YES;
        mGreenVImage.hidden = NO;
        [[IAPManager iapManager] productPurchased:purchasedProductID];
        [self setPlayButtonAppearence];
        [[NSNotificationCenter defaultCenter] postNotificationName:ProductWasPurchasedNotification object:nil userInfo:nil];
        
    });
        
}
-(void)showActivityView
{
    mActivityView.hidden = NO;
}
-(void)hideActivityView
{
    mActivityView.hidden = YES;
}
-(void)viewDidLayout
{
    [super viewDidLayout];
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
    if(!mInit)
    {
        mOriginalSize = self.view.frame.size;
        mNewWindowSize = self.view.frame.size;
        mInit = YES;
    }
    
    CGRect rect = mCartScreen.frame;
    rect.size.width = round(1 *self.view.frame.size.width /3);
    rect.size.height = self.view.frame.size.height;
    mCartScreen.frame = rect;
    [mCartScreen setWantsLayer:YES];
    rect = mSelectLessonScreen.frame;
    rect.size.height = round(self.view.frame.size.height / 2) - 100;
    //rect.size.height = mVideoScreen.frame.origin.y + mVideoScreen.frame.size.height - 40;
    rect.size.width = self.view.frame.size.width;
    mSelectLessonScreen.frame = rect;
    
    rect = mInfoScreen.frame;
    rect.size.width = self.view.frame.size.width;
    rect.size.height = round(2 *self.view.frame.size.height /3) - 70;
    //rect.size.height = round(self.view.frame.size.height / 2) - 100;
    mInfoScreen.frame = rect;
    //[mVideoScreen canPlay];
    [mMiddleScreen setWantsLayer:YES];
    //mMiddleScreen.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    [mSelectLessonScreen setWantsLayer:YES];
    mMoreAppsScreen.frame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [mMoreAppsScreen setWantsLayer:YES];
    if(!mItemsRectArr)
    {
        
        mItemsRectArr = [NSMutableArray arrayWithObjects:[NSValue valueWithRect:mMiddleScreen.frame], nil];
    }
    /*
    int wDelta = (mNewWindowSize.width - mOriginalSize.width) / 2;
    int hDelta = mNewWindowSize.height - mOriginalSize.height;
    for (int i; i < [mItemsRectArr count]; i = i + 1) {
        NSRect toRect = [[mItemsRectArr objectAtIndex:i] rectValue];
        toRect.size.width += wDelta;
        toRect.size.height += hDelta;
        [mItemsRectArr replaceObjectAtIndex:i withObject:[NSValue valueWithRect:toRect]];
    }
     */
    if(!mPdfScreen.mFullScreenMode)
    {
        CGRect rect = mPdfScreen.frame;
        //rect.size.width = round(2 *self.view.frame.size.width /3);
        //rect.size.height = self.view.frame.size.height;
        
        rect.size.width = self.view.frame.size.width;
        rect.size.height = self.view.frame.size.height - (self.view.frame.size.height - mVideoScreen.frame.origin.y + mVideoScreen.frame.size.height - 30);
        rect.size.height = self.view.frame.size.height - rect.size.height;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        mPdfScreen.frame = rect;
    }
    mBannerImage.image = [NSImage imageNamed:@"bannerImage.png"];
    [mBannerImage setWantsLayer:YES];
    mBannerImage.layer.backgroundColor = [[NSColor clearColor] CGColor];
    [mBannerView setWantsLayer:YES];
    mBannerView.layer.backgroundColor = [[NSColor clearColor] CGColor];
    [mSelectLessonScreen viewWillLayout];
    [mMoreAppsScreen viewWillLayout];
    [mActivityView viewWillLayout];
    
}
- (BOOL)isFlipped
{
    return YES;
}
-(void)courseDetailsDownlodedNotification
{
    NSString *itemTitle = [[ServiceManager serviceManager] vimeoLessonItemTitle:0];
    NSString *itemDesc = [[ServiceManager serviceManager] vimeoLessonItemDesc:0];
    BOOL LTRDir = [[ServiceManager serviceManager] vimeoLessonLTRDirection:0];
    [mItemInfoScreen updateContent:itemTitle Desc:itemDesc andDir:LTRDir];
    mItemInfoScreen.hidden = NO;
    [mVideoScreen setVideoUrl:[[ServiceManager serviceManager] vimeoLessonItemUrl:0]];
    [mVideoScreen setPreviewImage:[[ServiceManager serviceManager] vimeoLessonPreviewImage:0]];
    mCurrentLessonShown = 0;
    
    [self setPlayButtonAppearence];
    
    //[mVideoScreen canPlayMovie];
    if([[ServiceManager serviceManager] isCurrentCoursePro])
    {
        mCartButton.hidden = YES;
        mGreenVImage.hidden = NO;
    }
    else
    {
        
        if([[ServiceManager serviceManager] needToShowBanner])
        {
            mBannerView.hidden = NO;
        }
        else
        {
            mBannerView.hidden = YES;
        }
        
        mCartButton.hidden = NO;
        mGreenVImage.hidden = YES;
    }
    
    
    [self hideActivityView];
}
-(void)moveToSelectLesson
{
    //mMiddleScreen.transform = CGAffineTransformMakeTranslation(0,mSelectLessonScreen.frame.size.height );
    //CGAffineTransform transform = CGAffineTransformMakeTranslation(100,100 );
    //[[mMiddleScreen layer] setAffineTransform: transform];
    //mMiddleScreen.frame = CGRectMake(80, 80, mMiddleScreen.frame.size.width, mMiddleScreen.frame.size.height);
    if(![mSelectLessonScreen isDescendantOf:self.view])
    {
        [self.view addSubview:mSelectLessonScreen];
        mSelectLessonScreen.animator.alphaValue = 0;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1;
            mSelectLessonScreen.animator.alphaValue = 1;
            mInfoButton.animator.alphaValue = 0;
            /*
            context.allowsImplicitAnimation = YES;
            [[NSAnimationContext currentContext] setDuration:1.2];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0,mSelectLessonScreen.frame.size.height );
            //mMiddleScreen.animator.layer.affineTransform = transform;
            [mMiddleScreen.animator.layer setAffineTransform: transform];
             */
        }
                            completionHandler:^{
                                [self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_up.png"];
                                [mSelectLessonScreen viewDidAppear];
                                //[mSelectLessonScreen viewDidAppear];
                                
                            }];
        
        NSViewAnimation *theAnim;
        NSMutableDictionary* animDict = [NSMutableDictionary dictionaryWithCapacity:3];
        // Specify which view to modify.
        [animDict setObject:mMiddleScreen forKey:NSViewAnimationTargetKey];
        // Specify the starting position of the view.
        [animDict setObject:[NSValue valueWithRect:mMiddleScreen.frame]
                          forKey:NSViewAnimationStartFrameKey];
        // Change the ending position of the view.
        NSRect  newViewFrame = mMiddleScreen.frame;
        newViewFrame.origin.y += mSelectLessonScreen.frame.size.height;
        [animDict setObject:[NSValue valueWithRect:newViewFrame]
                          forKey:NSViewAnimationEndFrameKey];
        // Create the view animation object.
        theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                                   arrayWithObjects:animDict, nil]];
        // Set some additional attributes for the animation.
        [theAnim setDuration:1];    // One and a half seconds.
        [theAnim setAnimationCurve:NSAnimationEaseIn];
        
        // Run the animation.
        [theAnim startAnimation];
         
        
    }
    else
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1;
            mSelectLessonScreen.animator.alphaValue = 0;
            context.allowsImplicitAnimation = YES;
            [[NSAnimationContext currentContext] setDuration:1.2];
            [mMiddleScreen.animator.layer setAffineTransform: CGAffineTransformIdentity];
        }
                            completionHandler:^{
                                [self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_down.png"];
                                //mInfoButton.alpha = 1.0;
                                [mSelectLessonScreen removeFromSuperview];
                            }];
        [self needAnimationBack:mMiddleScreen withDuration:1 andItemIdx:GUIItemMiddleRect];
        
    }
    
    
    
}
-(void)needAnimationBack:(NSView *)AV withDuration:(NSTimeInterval)animTime andItemIdx:(int)itemIdx
{
    //NSRect toRect = [[mItemsRectArr objectAtIndex:itemIdx] rectValue];
    NSRect toRect = AV.frame;
    toRect.origin.x = 0;
    toRect.origin.y = 0;
    NSViewAnimation *theAnim;
    NSMutableDictionary* animDict = [NSMutableDictionary dictionaryWithCapacity:3];
    // Specify which view to modify.
    [animDict setObject:AV forKey:NSViewAnimationTargetKey];
    // Specify the starting position of the view.
    [animDict setObject:[NSValue valueWithRect:AV.frame]
                 forKey:NSViewAnimationStartFrameKey];
    // Change the ending position of the view.
    
    [animDict setObject:[NSValue valueWithRect:toRect]
                 forKey:NSViewAnimationEndFrameKey];
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animDict, nil]];
    // Set some additional attributes for the animation.
    [theAnim setDuration:animTime];    // One and a half seconds.
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    
    // Run the animation.
    [theAnim startAnimation];
}
-(IBAction)cartPressed:(id)sender
{
    //[self moveToCart];
    if(![mCartScreen isDescendantOf:self.view])
    {
        //if(CGAffineTransformEqualToTransform(mMiddleScreen.transform, CGAffineTransformIdentity))
        if(mMiddleScreen.frame.origin.x == 0 && mMiddleScreen.frame.origin.y == 0)
        {
            [mVideoScreen pauseMovie];
            [self moveToCart];
        }
        else
        {
            void(^accept)() = ^(void) {
                //[self moveToCart];
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                               selector:@selector(moveToCart)
                                               userInfo:nil
                                                repeats:NO];
            };
            [self setScreenState:MainScreenStateTypeDefault withAnim:YES completionBlock:accept];
        }
    }
    else
    {
        [self moveToCart];
    }
}
-(IBAction)selectLessonPressed:(id)sender
{
    //[self moveToSelectLesson];
    if([self needToShowSelectLesson])
    {
        if([self isScreenClearSelectLesson])
        {
            [self moveToSelectLesson];
        }
        else
        {
            
            void(^accept)() = ^(void) {
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                               selector:@selector(moveToSelectLesson)
                                               userInfo:nil
                                                repeats:NO];
                //[self moveToSelectLesson];
            };
            
            [self setScreenState:MainScreenStateTypeDefault withAnim:YES completionBlock:accept];
        }
    }
    else
    {
        //[self moveToSelectLesson];
        [self setScreenState:MainScreenStateTypeDefault withAnim:YES completionBlock:nil];
    }
}
-(BOOL)needToShowSelectLesson
{
    for (int i = 0; i < [mEnvScreensArr count]; ++i) {
        NSView *screen = [mEnvScreensArr objectAtIndex:i];
        if([screen isKindOfClass:[InfoScreen class]] || [screen isKindOfClass:[selectLessonScreen class]])
        {
            if([screen isDescendantOf:self.view])
            {
                return NO;
            }
        }
    }
    return YES;
}
-(BOOL)isScreenClearSelectLesson
{
    if(([mPdfScreen superview] && mPdfScreen.animator.alphaValue > 0.0) || mMiddleScreen.frame.origin.x != 0 || mMiddleScreen.frame.origin.y != 0)
        return NO;
    else
        return YES;
}
-(void)moveToCart
{
    if(![mCartScreen isDescendantOf:self.view])
    {
        [self.view addSubview:mCartScreen];
        mCartScreen.animator.alphaValue = 0;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1;
            mCartScreen.animator.alphaValue = 1;
        }
                            completionHandler:^{
                                //mCartScreen.hidden = YES;
                                //mCartScreen.alphaValue = 1;
                                [self changeBackgroundButtonImageWithAnim:mCartButton image:@"Chevron_yellow_left.png"];
                            }];
        NSViewAnimation *theAnim;
        NSMutableDictionary* animDict = [NSMutableDictionary dictionaryWithCapacity:3];
        // Specify which view to modify.
        [animDict setObject:mMiddleScreen forKey:NSViewAnimationTargetKey];
        // Specify the starting position of the view.
        [animDict setObject:[NSValue valueWithRect:mMiddleScreen.frame]
                     forKey:NSViewAnimationStartFrameKey];
        // Change the ending position of the view.
        NSRect  newViewFrame = mMiddleScreen.frame;
        newViewFrame.origin.x += mCartScreen.frame.size.width;
        [animDict setObject:[NSValue valueWithRect:newViewFrame]
                     forKey:NSViewAnimationEndFrameKey];
        // Create the view animation object.
        theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                                   arrayWithObjects:animDict, nil]];
        // Set some additional attributes for the animation.
        [theAnim setDuration:1];    // One and a half seconds.
        [theAnim setAnimationCurve:NSAnimationEaseIn];
        
        // Run the animation.
        [theAnim startAnimation];
    }
    else
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.6;
            mCartScreen.animator.alphaValue = 0;
            context.allowsImplicitAnimation = YES;
            //[[NSAnimationContext currentContext] setDuration:1.2];
            //[mMiddleScreen.animator.layer setAffineTransform: CGAffineTransformIdentity];
        }
                            completionHandler:^{
                                //[self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_down.png"];
                                //mInfoButton.alpha = 1.0;
                                [mCartScreen removeFromSuperview];
                                [self changeBackgroundButtonImageWithAnim:mCartButton image:@"Basket_icon.png"];
                            }];
        [self needAnimationBack:mMiddleScreen withDuration:1 andItemIdx:GUIItemMiddleRect];
    }
    //mCartScreen.hidden = YES;
    //[mCartScreen setOpaque:NO];  //Tells the window manager that the window might have transparent parts.
    //[mCartScreen setBackgroundColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.0]];
    /*
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        //mCartScreen.hidden = NO;
        context.duration = 1.0;
        
        //Animation code
        CGAffineTransform transform = CGAffineTransformMakeTranslation(50,50 );
        [[mCartScreen layer] setAffineTransform: transform];
        
    } completionHandler:^{
        //Completion Code
        NSLog(@"Completed");
    }];
     */
    
}
-(void)setPlayButtonAppearence
{
    [mVideoScreen setPlayButtonAppearence:[[ServiceManager serviceManager] isThisLessonFreeOrPurchased:mCurrentLessonShown]];
    
}
#pragma mark selectLessonScreenDelegate methods
-(void)lessonSelected:(int)lessonIndex
{
    mCurrentLessonShown = lessonIndex;
    [self setPlayButtonAppearence];
    NSString *itemTitle = [[ServiceManager serviceManager] vimeoLessonItemTitle:lessonIndex];
    NSString *itemDesc = [[ServiceManager serviceManager] vimeoLessonItemDesc:lessonIndex];
    BOOL LTRDir = [[ServiceManager serviceManager] vimeoLessonLTRDirection:lessonIndex];
    [mItemInfoScreen updateContent:itemTitle Desc:itemDesc andDir:LTRDir];
    
    mItemInfoScreen.hidden = NO;
    [mVideoScreen stopMovie];
    [mVideoScreen setVideoUrl:[[ServiceManager serviceManager] vimeoLessonItemUrl:lessonIndex]];
    [mVideoScreen setPreviewImage:[[ServiceManager serviceManager] vimeoLessonPreviewImage:lessonIndex]];
    /*
    if(CGAffineTransformEqualToTransform(mItemInfoScreen.transform, CGAffineTransformIdentity))
    {
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             mVideoScreen.transform = CGAffineTransformMakeTranslation(mItemInfoScreen.frame.size.width,0);
                             mItemInfoScreen.transform = CGAffineTransformMakeTranslation(0, - (mItemInfoScreen.frame.origin.y - mVideoScreen.frame.origin.y));
                             //mItemInfoScreen.transform = CGAffineTransformMakeTranslation(0, - 40);
                             
                         }
                         completion:^(BOOL finished) {
                             // Completion Block
                         }];
     
    }
     */
}
-(void)lessonActivated:(int)lessonIndex
{
    if(mLessonBeingActivated)
    {
        return;
    }
    mLessonBeingActivated = YES;
    mCurrentLessonShown = lessonIndex;
    //[self playMoviePressed:nil];
    
    [self setPlayButtonAppearence];
    
    void(^accept)() = ^(void) {
        [self playMoviePressed:nil];
        mLessonBeingActivated = NO;
    };
    [self setScreenState:MainScreenStateTypeDefault withAnim:YES completionBlock:accept];
    
}
-(IBAction)playMoviePressed:(id)sender
{
    if([[ServiceManager serviceManager] isThisLessonFreeOrPurchased:mCurrentLessonShown])
    {
        BOOL reach = [[ReachabilityManager reachabilityManager] isReachable];
        /*
        if(!reach)
        {
            NSString *message =  ((TextManager *)[TextManager textmanager]).noInternet;
            [UIAlertView showWithTitle:nil
                               message:message
                     cancelButtonTitle:((TextManager *)[TextManager textmanager]).noInternetOK
                     otherButtonTitles:nil
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  if (buttonIndex == [alertView cancelButtonIndex]) {
                                  }
                                  else  {
                                      
                                  }
                              }];
            return;
        }
         */
        [mVideoScreen canPlayMovie];
    }
    else
    {
        [self cartPressed:nil];
    }
    
}
-(void)windowWillResize:(NSSize)frameSize
{
    mNewWindowSize = frameSize;
}
-(void)changeBackgroundButtonImageWithAnim:(NSButton *)btn image:(NSString *)btnImageName
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5;
        btn.animator.alphaValue = 0;
    }
                        completionHandler:^{
                            
                            [btn setImage:[NSImage imageNamed:btnImageName]];
                            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                                context.duration = 0.5;
                                btn.animator.alphaValue = 1;
                            }
                                                completionHandler:^{
                                                    
                                                    
                                                }];
                        }];
    
}
-(IBAction)infoPressed:(id)sender
{
    if(![mInfoScreen isDescendantOf:self.view])
    {
        
        if([self isScreenClearForInfo])
        {
            [self moveToInfoScreen];
        }
        else
        {
            
            void(^accept)() = ^(void) {
                [self moveToInfoScreen];
            };
            [self setScreenState:MainScreenStateTypeDefault withAnim:YES completionBlock:accept];
        }
    }
    else
    {
        [self moveToInfoScreen];
    }
}
-(IBAction)moreAppsPressed:(id)sender
{
    if([mMoreAppsScreen superview])
        return;
    [mVideoScreen pauseMovie];
    [self moveToMoreScreen];
}
-(void)moveToMoreScreen
{
    
    mMoreAppsScreen.frame = CGRectMake(0, -mMoreAppsScreen.frame.size.height, mMoreAppsScreen.frame.size.width, mMoreAppsScreen.frame.size.height);
    [self.view addSubview:mMoreAppsScreen];
    NSViewAnimation *theAnim;
    NSMutableDictionary* animDict = [NSMutableDictionary dictionaryWithCapacity:3];
    // Specify which view to modify.
    [animDict setObject:mMoreAppsScreen forKey:NSViewAnimationTargetKey];
    // Specify the starting position of the view.
    [animDict setObject:[NSValue valueWithRect:mMoreAppsScreen.frame]
                 forKey:NSViewAnimationStartFrameKey];
    // Change the ending position of the view.
    NSRect  newViewFrame = mMoreAppsScreen.frame;
    newViewFrame.origin.y = 0;
    
    [animDict setObject:[NSValue valueWithRect:newViewFrame]
                 forKey:NSViewAnimationEndFrameKey];
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animDict, nil]];
    theAnim.delegate = self;
    // Set some additional attributes for the animation.
    [theAnim setDuration:1];    // One and a half seconds.
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    mMoreAppsAnimShow = theAnim;
    // Run the animation.
    [theAnim startAnimation];
    //[mMoreAppsScreen setScreen];
}
-(IBAction)closeMoreAppsPressed:(id)sender
{
    NSViewAnimation *theAnim;
    /*
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [mMoreAppsScreen removeFromSuperview];
    }];
     */
    NSMutableDictionary* animDict = [NSMutableDictionary dictionaryWithCapacity:3];
    // Specify which view to modify.
    [animDict setObject:mMoreAppsScreen forKey:NSViewAnimationTargetKey];
    // Specify the starting position of the view.
    [animDict setObject:[NSValue valueWithRect:mMoreAppsScreen.frame]
                 forKey:NSViewAnimationStartFrameKey];
    // Change the ending position of the view.
    NSRect  newViewFrame = mMoreAppsScreen.frame;
    newViewFrame.origin.y = -mMoreAppsScreen.frame.size.height;
    
    [animDict setObject:[NSValue valueWithRect:newViewFrame]
                 forKey:NSViewAnimationEndFrameKey];
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animDict, nil]];
    // Set some additional attributes for the animation.
    [theAnim setDuration:1];    // One and a half seconds.
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    theAnim.delegate = self;
    //[theAnim setAnimationBlockingMode:NSAnimationBlocking];
    
    
    
    // Run the animation.
    mMoreAppsAnim = theAnim;
    [theAnim startAnimation];
}
-(IBAction)pdfPressed:(id)sender
{
    if(![mPdfScreen isDescendantOf:self.view])
    {
        //if(CGAffineTransformEqualToTransform(mMiddleScreen.transform, CGAffineTransformIdentity))
        if(mMiddleScreen.frame.origin.x == 0 && mMiddleScreen.frame.origin.y == 0)
        {
            [self moveToPdf];
        }
        else
        {
            void(^accept)() = ^(void) {
                [self moveToPdf];
            };
            [self setScreenState:MainScreenStateTypeDefault withAnim:YES completionBlock:accept];
        }
    }
    else
    {
        [self moveToPdf];
    }
}
-(IBAction)bannerPressed:(id)sender
{
    DLog(@"-(IBAction)bannerPressed:(id)sender");
    NSString *bannerLink = [[ServiceManager serviceManager] bannerLink];
    NSURL *url = [NSURL URLWithString:bannerLink];
    [[NSWorkspace sharedWorkspace] openURL:url];
}
-(void)moveToPdf
{
    if(![mPdfScreen isDescendantOf:self.view])
    {
        [self.view addSubview:mPdfScreen];
        mPdfScreen.animator.alphaValue = 0;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1;
            mPdfScreen.animator.alphaValue = 1;
            mCartButton.animator.alphaValue = 0;
            mCartButton.hidden = YES;
            //[mPdfScreen viewDidAppear];
            mPlusButton.hidden = NO;
            mGreenVImage.animator.alphaValue = 0.0;
            mPlusButton.animator.alphaValue = 1.0;
            //mMoreAppsButton.animator.alphaValue = 0.0;
            mInfoButton.animator.alphaValue = 0.0;
            
        }
                            completionHandler:^{
                                //[self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_up.png"];
                                //[self changeButtonImageWithAnim:mInfoButton image:nil];
                                [self changeBackgroundButtonImageWithAnim:mInfoButton image:nil];
                                //[mInfoScreen viewDidAppear];
                                
                            }];
        
    }
    else
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1;
            mPdfScreen.animator.alphaValue = 0;
            mCartButton.animator.alphaValue = 1.0;
            mCartButton.hidden = NO;
            //mMoreAppsButton.alpha = 1.0;
            mInfoButton.animator.alphaValue = 1.0;
            mPlusButton.animator.alphaValue = 0.0;
            mGreenVImage.animator.alphaValue = 1.0;
            context.allowsImplicitAnimation = YES;
            [[NSAnimationContext currentContext] setDuration:1.2];
            [mMiddleScreen.animator.layer setAffineTransform: CGAffineTransformIdentity];
        }
                            completionHandler:^{
                                [self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_down.png"];
                                [self changeBackgroundButtonImageWithAnim:mInfoButton image:@"Info_icon.png"];
                                //mInfoButton.alpha = 1.0;
                                [mPdfScreen removeFromSuperview];
                                mPlusButton.hidden = YES;
                            }];
        [self needAnimationBack:mMiddleScreen withDuration:1 andItemIdx:GUIItemMiddleRect];
    }
    /*
    if(![mPdfScreen isDescendantOf:self.view])
    {
        [self.view addSubview:mPdfScreen];
        //[self.view bringSubviewToFront:mPdfButton];
        mPdfScreen.alpha = 0.0;
        [UIView animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [mPdfScreen setAlpha:1.0];
                             [mCartButton setAlpha:0.0];
                             //////////changed///////
                             if(IS_IPAD)
                                 mVideoScreen.transform = CGAffineTransformMakeTranslation(0,-130);
                             else
                                 mVideoScreen.transform = CGAffineTransformMakeTranslation(0,-80);
                             [mPdfScreen viewDidAppear];
                             mPlusButton.hidden = NO;
                             mGreenVImage.alpha = 0.0;
                             mPlusButton.alpha = 1.0;
                             mMoreAppsButton.alpha = 0.0;
                             mInfoButton.alpha = 0.0;
                             
                         }
                         completion:^(BOOL finished) {
                             //[mPdfScreen viewDidAppear];
                             // Completion Block
                         }];
        
    }
    else
    {
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [mPdfScreen setAlpha:0.0];
                             [mCartButton setAlpha:1.0];
                             mMoreAppsButton.alpha = 1.0;
                             mInfoButton.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             // Completion Block
                             [mPdfScreen viewDidDisappear];
                             [mPdfScreen removeFromSuperview];
                         }];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             mMiddleScreen.transform = CGAffineTransformIdentity;
                             //[self setScreenState:MainScreenStateTypeDefault];
                         }
                         completion:^(BOOL finished) {
                             // Completion Block
                             [UIView animateWithDuration:0.4
                                                   delay:0.2
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  mPlusButton.alpha = 0.0;
                                                  mGreenVImage.alpha = 1.0;
                                                  mVideoScreen.transform = CGAffineTransformIdentity;
                                              }
                                              completion:^(BOOL finished) {
                                                  // Completion Block
                                                  mPlusButton.hidden = YES;
                                                  //[mPdfButton setBackgroundImage:[UIImage imageNamed:@"PDF_icon.png"] forState:UIControlStateNormal];
                                                  [self changeBackgroundButtonImageWithAnim:mPdfButton image:@"PDF_icon.png"];
                                              }];
                         }];
    }
     */
}
-(BOOL)isScreenClearForInfo
{
    if([mPdfScreen superview] && mPdfScreen.animator.alphaValue > 0.0)
        return NO;
    else
        return YES;
}
-(void)moveToInfoScreen
{
    if(![mInfoScreen isDescendantOf:self.view])
    {
        [self.view addSubview:mInfoScreen];
        mInfoScreen.animator.alphaValue = 0;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1;
            mInfoScreen.animator.alphaValue = 1;
            
        }
                            completionHandler:^{
                                [self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_up.png"];
                                //[self changeButtonImageWithAnim:mInfoButton image:nil];
                                [self changeBackgroundButtonImageWithAnim:mInfoButton image:nil];
                                [mInfoScreen viewDidAppear];
                                
                            }];
        
        NSViewAnimation *theAnim;
        NSMutableDictionary* animDict = [NSMutableDictionary dictionaryWithCapacity:3];
        // Specify which view to modify.
        [animDict setObject:mMiddleScreen forKey:NSViewAnimationTargetKey];
        // Specify the starting position of the view.
        [animDict setObject:[NSValue valueWithRect:mMiddleScreen.frame]
                     forKey:NSViewAnimationStartFrameKey];
        // Change the ending position of the view.
        NSRect  newViewFrame = mMiddleScreen.frame;
        newViewFrame.origin.y += mInfoScreen.frame.size.height;
        [animDict setObject:[NSValue valueWithRect:newViewFrame]
                     forKey:NSViewAnimationEndFrameKey];
        // Create the view animation object.
        theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                                   arrayWithObjects:animDict, nil]];
        // Set some additional attributes for the animation.
        [theAnim setDuration:1];    // One and a half seconds.
        [theAnim setAnimationCurve:NSAnimationEaseIn];
        
        // Run the animation.
        [theAnim startAnimation];
    }
    else
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 1;
            mInfoScreen.animator.alphaValue = 0;
            context.allowsImplicitAnimation = YES;
            [[NSAnimationContext currentContext] setDuration:1.2];
            [mMiddleScreen.animator.layer setAffineTransform: CGAffineTransformIdentity];
        }
                            completionHandler:^{
                                [self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_down.png"];
                                [self changeBackgroundButtonImageWithAnim:mInfoButton image:@"Info_icon.png"];
                                //mInfoButton.alpha = 1.0;
                                [mInfoScreen removeFromSuperview];
                            }];
        [self needAnimationBack:mMiddleScreen withDuration:1 andItemIdx:GUIItemMiddleRect];
    }
}
-(void)setScreenState:(int)newState withAnim:(BOOL)anim completionBlock:(void (^)(void))blockName;
{
    switch (newState) {
        case MainScreenStateTypeDefault:
            if(anim)
            {
                [self needAnimationBack:mMiddleScreen withDuration:0.6 andItemIdx:GUIItemMiddleRect];
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.5;
                    mInfoScreen.animator.alphaValue = 0;
                    for (int i = 0; i < [mEnvScreensArr count]; ++i) {
                        NSView *screen = [mEnvScreensArr objectAtIndex:i];
                        if([screen isDescendantOf:self.view])
                        {
                            screen.animator.alphaValue = 0.0;
                        }
                    }
                    mPlusButton.animator.alphaValue = 0.0;
                    mYellowTopArrow.animator.alphaValue = 1.0;
                    mInfoButton.animator.alphaValue = 1.0;
                    //mPdfButton.animator.alphaValue = 1.0;
                    //mMoreAppsButton.animator.alphaValue = 1.0;
                    mInfoButton.animator.alphaValue = 1.0;
                    mPlusButton.animator.alphaValue = 0.0;
                    mGreenVImage.animator.alphaValue = 1.0;
                    mCartButton.animator.alphaValue = 1.0;
                    mCartButton.hidden = NO;
                    
                    context.allowsImplicitAnimation = YES;
                    [[NSAnimationContext currentContext] setDuration:1.2];
                    [mMiddleScreen.animator.layer setAffineTransform: CGAffineTransformIdentity];
                }
                                    completionHandler:^{
                                        [self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_down.png"];
                                        [self changeBackgroundButtonImageWithAnim:mInfoButton image:@"Info_icon.png"];
                                        //[self changeBackgroundButtonImageWithAnim:mPdfButton image:@"PDF_icon.png"];
                                        [self changeBackgroundButtonImageWithAnim:mCartButton image:@"Basket_icon.png"];
                                        for (int i = 0; i < [mEnvScreensArr count]; ++i) {
                                            NSView *screen = [mEnvScreensArr objectAtIndex:i];
                                            if([screen isDescendantOf:self.view])
                                            {
                                                [screen removeFromSuperview];
                                            }
                                        }
                                        mPlusButton.hidden = YES;
                                        if(blockName)
                                        {
                                            blockName();
                                        }
                                    }];
                //[self needAnimationBack:mMiddleScreen withDuration:1 andItemIdx:GUIItemMiddleRect];
                /*
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     mMiddleScreen.transform = CGAffineTransformIdentity;
                                     mVideoScreen.transform = CGAffineTransformIdentity;
                                     mItemInfoScreen.transform = CGAffineTransformIdentity;
                                     [self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_down.png"];
                                     [self changeButtonImageWithAnim:mInfoButton image:@"Info_icon.png"];
                                     [self changeBackgroundButtonImageWithAnim:mPdfButton image:@"PDF_icon.png"];
                                     [self changeBackgroundButtonImageWithAnim:mCartButton image:@"Basket_icon.png"];
                                     
                                     
                                     //[mYellowTopArrow setBackgroundImage:[UIImage imageNamed:@"Chevron_yellow_down.png"] forState:UIControlStateNormal];
                                     //[mInfoButton setBackgroundImage:[UIImage imageNamed:@"Info_icon.png"] forState:UIControlStateNormal];
                                     //[mPdfButton setBackgroundImage:[UIImage imageNamed:@"PDF_icon.png"] forState:UIControlStateNormal];
                                     mYellowTopArrow.alpha = 1.0;
                                     mInfoButton.alpha = 1.0;
                                     mPdfButton.alpha = 1.0;
                                     mMoreAppsButton.alpha = 1.0;
                                     mInfoButton.alpha = 1.0;
                                     mPlusButton.alpha = 0.0;
                                     mGreenVImage.alpha = 1.0;
                                     [mCartButton setAlpha:1.0];
                                     for (int i = 0; i < [mEnvScreensArr count]; ++i) {
                                         UIView *screen = [mEnvScreensArr objectAtIndex:i];
                                         if([screen isDescendantOfView:self.view])
                                         {
                                             screen.alpha = 0.0;
                                         }
                                     }
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     // Completion Block
                                     mPlusButton.hidden = YES;;
                                     [mPdfScreen viewDidDisappear];
                                     for (int i = 0; i < [mEnvScreensArr count]; ++i) {
                                         UIView *screen = [mEnvScreensArr objectAtIndex:i];
                                         if([screen isDescendantOfView:self.view])
                                         {
                                             [screen removeFromSuperview];
                                         }
                                     }
                                     if(blockName)
                                     {
                                         blockName();
                                     }
                                     
                                 }];
                 */
            }
            /*
            else
            {
                mMiddleScreen.transform = CGAffineTransformIdentity;
                mVideoScreen.transform = CGAffineTransformIdentity;
                mItemInfoScreen.transform = CGAffineTransformIdentity;
                
                [self changeBackgroundButtonImageWithAnim:mYellowTopArrow image:@"Chevron_yellow_down.png"];
                [self changeButtonImageWithAnim:mInfoButton image:@"Info_icon.png"];
                [self changeBackgroundButtonImageWithAnim:mPdfButton image:@"PDF_icon.png"];
                
                //[mYellowTopArrow setBackgroundImage:[UIImage imageNamed:@"Chevron_yellow_down.png"] forState:UIControlStateNormal];
                //[mInfoButton setBackgroundImage:[UIImage imageNamed:@"Info_icon.png"] forState:UIControlStateNormal];
                //[mPdfButton setBackgroundImage:[UIImage imageNamed:@"PDF_icon.png"] forState:UIControlStateNormal];
                mYellowTopArrow.alpha = 1.0;
                mInfoButton.alpha = 1.0;
                mPdfButton.alpha = 1.0;
                for (int i = 0; i < [mEnvScreensArr count]; ++i) {
                    UIView *screen = [mEnvScreensArr objectAtIndex:i];
                    if([screen isDescendantOfView:self.view])
                    {
                        [screen removeFromSuperview];
                    }
                }
                if(blockName)
                {
                    blockName();
                }
            }
            */
            break;
            
        default:
            break;
    }
}


- (void)animationDidEnd:(NSAnimation *)animation
{
    if(animation == mMoreAppsAnim)
    {
        [mMoreAppsScreen removeFromSuperview];
        mMoreAppsAnim = nil;
    }
    else
        
    {
        if(animation == mPdfFullAnim)
        {
            if(mPdfScreen.mFullScreenMode)
                //[self changeButtonImageWithAnim:mPdfScreen.mFullScreenBtn image:@"FullScreen_Exit_icon.png"];
                [self changeBackgroundButtonImageWithAnim:mPdfScreen.mFullScreenBtn image:@"FullScreen_Exit_icon.png"];
            else
                //[self changeButtonImageWithAnim:mPdfScreen.mFullScreenBtn image:@"FullScreen_icon.png"];
                [self changeBackgroundButtonImageWithAnim:mPdfScreen.mFullScreenBtn image:@"FullScreen_icon.png"];
        }
        else
            
        {
            if(animation == mMoreAppsAnimShow)
            {
                [mMoreAppsScreen viewDidAppear];
            }
        }
    }
}
-(void)appSelected:(int)appIndex
{
    [self closeMoreAppsPressed:nil];
    [mVideoScreen stopMovie];
    BOOL hacContentForThisCourse = [[ServiceManager serviceManager] hacContentForThisCourse:appIndex];
    [[ServiceManager serviceManager] downloadCourse:appIndex WithAnim:!hacContentForThisCourse andView:self.view];
    if(hacContentForThisCourse)
    {
        if([[ServiceManager serviceManager] isCurrentCoursePro])
        {
            mCartButton.hidden = YES;
        }
        else
        {
            mCartButton.hidden = NO;
        }
    }
    else
    {
        [self showActivityView];
    }
    
}
-(void)pdfSharePressedWithLink:(NSString *)pdfLink
{
    /*
    NSActivityViewController *controller =
    [[NSActivityViewController alloc]
     initWithActivityItems:@[pdfLink]
     applicationActivities:nil];
    if(IS_IPAD)
    {
        if ( [controller respondsToSelector:@selector(popoverPresentationController)] ) {
            // iOS8
            controller.popoverPresentationController.sourceView = self.view;
        }
        
    }
    
    [self presentViewController:controller animated:YES completion:nil];
     */
    NSSharingServicePicker *sharingServicePicker = [[NSSharingServicePicker alloc] initWithItems:@[pdfLink]];
    //sharingServicePicker.delegate = self;
    
    [sharingServicePicker showRelativeToRect:self.view.bounds
                                      ofView:self.view
                               preferredEdge:NSMinYEdge];
}
-(void)pdfFullScreenPressed
{
    
    NSViewAnimation *theAnim;
    NSMutableDictionary* animDict = [NSMutableDictionary dictionaryWithCapacity:3];
    // Specify which view to modify.
    [animDict setObject:mPdfScreen forKey:NSViewAnimationTargetKey];
    // Specify the starting position of the view.
    [animDict setObject:[NSValue valueWithRect:mPdfScreen.frame]
                 forKey:NSViewAnimationStartFrameKey];
    // Change the ending position of the view.
    NSRect  newViewFrame = mPdfScreen.frame;
    if(mPdfScreen.mFullScreenMode)
    {
        mPdfScreen.mFullScreenMode = NO;
        newViewFrame.size.width = self.view.frame.size.width;
        newViewFrame.size.height = self.view.frame.size.height - (self.view.frame.size.height - mVideoScreen.frame.origin.y + mVideoScreen.frame.size.height);
        newViewFrame.size.height = self.view.frame.size.height - newViewFrame.size.height;
        newViewFrame.origin.y = self.view.frame.size.height - newViewFrame.size.height;
    }
    else
    {
        mPdfScreen.mFullScreenMode = YES;
        //mPdfScreen.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        newViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    
    [animDict setObject:[NSValue valueWithRect:newViewFrame]
                 forKey:NSViewAnimationEndFrameKey];
    // Create the view animation object.
    theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray
                                                               arrayWithObjects:animDict, nil]];
    theAnim.delegate = self;
    // Set some additional attributes for the animation.
    [theAnim setDuration:1];    // One and a half seconds.
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    mPdfFullAnim = theAnim;
    // Run the animation.
    [theAnim startAnimation];
    /*
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if(mPdfScreen.mFullScreenMode)
                         {
                             mPdfScreen.mFullScreenMode = NO;
                             CGRect rect = mPdfScreen.frame;
                             rect.size.width = self.view.frame.size.width;
                             rect.size.height = self.view.frame.size.height - (mVideoScreen.frame.origin.y + mVideoScreen.frame.size.height);
                             rect.origin.y = self.view.frame.size.height - rect.size.height;
                             mPdfScreen.frame = rect;
                         }
                         else
                         {
                             mPdfScreen.mFullScreenMode = YES;
                             mPdfScreen.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         if(mPdfScreen.mFullScreenMode)
                             [self changeButtonImageWithAnim:mPdfScreen.mFullScreenBtn image:@"FullScreen_Exit_icon.png"];
                         else
                             [self changeButtonImageWithAnim:mPdfScreen.mFullScreenBtn image:@"FullScreen_icon.png"];
                         
                     }];
     */
}
@end
