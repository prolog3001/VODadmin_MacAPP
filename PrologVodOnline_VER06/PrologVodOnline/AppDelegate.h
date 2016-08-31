//
//  AppDelegate.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 08/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainScreenViewcontroller.h"

@interface AppDelegate : NSObject <NSApplicationDelegate , NSWindowDelegate>
{
    MainScreenViewcontroller *mMainScreenViewController;
}

@property (assign) IBOutlet NSWindow *window;

@end

