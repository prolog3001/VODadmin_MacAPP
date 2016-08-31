//
//  AppDelegate.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 08/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "AppDelegate.h"
#import "MKStoreKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[MKStoreKit sharedKit] startProductRequest];
    //self.window.delegate = self;
    [self.window setDelegate:self];
    // Insert code here to initialize your application
    mMainScreenViewController = [[MainScreenViewcontroller alloc] initWithNibName:@"MainScreenViewcontroller" bundle:nil];
    // 2. Add the view controller to the Window's content view
    [self.window.contentView addSubview:mMainScreenViewController.view];
    mMainScreenViewController.view.frame = ((NSView*)self.window.contentView).bounds;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (NSSize)windowWillResize:(NSWindow *)sender
                    toSize:(NSSize)frameSize
{
    NSLog(@"size is changing %f wide and %f tall",frameSize.width,frameSize.height);
    [mMainScreenViewController windowWillResize:frameSize];
    return frameSize;
}
@end
