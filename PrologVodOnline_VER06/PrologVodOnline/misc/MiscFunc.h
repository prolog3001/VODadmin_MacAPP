//
//  MiscFunc.h
//
//  Created by Tomer Lavi on 11/17/11.
//  Copyright (c) 2011 Assist Software Solutions. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <Cocoa/Cocoa.h>


typedef enum {
    FontIndexArimo = 0,
    FontIndexArimoItalic,
    FontIndexArimoBold,
    FontIndexArimoBoldItalic,
} FontIndex;


@interface MiscFunc : NSObject

+(NSString *)getCacheDirPath;
+(NSString *)fontWithIndex:(int)index;
+ (dispatch_queue_t) BackgroundQueue;
//+ (void) ShowActivityView:(UIView *)view;
//+ (void) ShowActivityView:(UIView *)view message:(NSString *)sMessage;
//+ (void) HideActivityView;


@end

@interface NSDictionary (JRAdditions)
-(NSDictionary *) nestedDictionaryByReplacingNullsWithNil:(NSDictionary*)sourceDictionary;
@end