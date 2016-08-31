//
//  CommonDefs.h
//  nextTo
//
//  Created by Gilad Kedmi on 11/12/14.
//  Copyright (c) 2014 Gphone. All rights reserved.
//

#ifndef VODUniversal_CommonDefs_h
#define VODUniversal_CommonDefs_h


#endif



typedef enum {
    MainScreenStateTypeDefault = 0,
    MainScreenStateTypeCart1,
    MainScreenStateTypeCart2,
} MainScreenStateType;
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define CourseDetailsDownlodedNotification @"CourseDetailsDownlodedNotification"
#define MoreAppsIconsDownlodedNotification @"MoreAppsIconsDownlodedNotification"
#define ProductWasPurchasedNotification @"ProductWasPurchasedNotification"
#define CheckPurchaseRecordNotification @"CheckPurchaseRecordNotification"

#define ITEMS_COUNTUR_COLOR [NSColor colorWithRed:239/255.0f green:231/255.0f blue:14/255.0f alpha:1.0f]

#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif
//STEM in WebService.h
