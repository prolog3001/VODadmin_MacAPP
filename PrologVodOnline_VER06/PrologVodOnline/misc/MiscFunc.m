//
//  MiscFunc.m
//
//  Created by Tomer Lavi on 11/17/11.
//  Copyright (c) 2011 Assist Software Solutions. All rights reserved.
//

#import "MiscFunc.h"
//#import "DSActivityView.h"
#import "ServiceManager.h"




static NSInteger nActivityViewRefCount = 0;
//static NSInteger nRelativeCountCount = 0;
static NSString *fontsNames[] = {@"Arimo", @"Arimo-Italic", @"Arimo-BoldItalic",@"Arimo-Bold",@"OpenSans",@"OpenSans-Italic",@"OpenSans-BoldItalic",@"OpenSans-Bold",   };
/*
 Arimo           = 0
 Arimo-Italic           = 1
 Arimo-BoldItalic          = 2
 Arimo-Bold        = 3
 */

@implementation MiscFunc
+ (dispatch_queue_t) BackgroundQueue {
    return ((ServiceManager *)[ServiceManager serviceManager]).BackgroundQueue;
    //return dispatch_get_main_queue();
}
/*
+ (void) ShowActivityView:(UIView *)view
{
    [MiscFunc RunOnMainThread:^(void) {[MiscFunc ShowActivityView:view message:@""];}];
}
+ (void) HideActivityView
{
    nActivityViewRefCount = MAX(--nActivityViewRefCount, 0);
    if (nActivityViewRefCount) return;
    [MiscFunc RunOnMainThread:^(void) {[DSActivityView removeView];}];
}
+ (void) ShowActivityView:(UIView *)view message:(NSString *)sMessage {
    if (nActivityViewRefCount++) return;
    [MiscFunc RunOnMainThread:^(void) {[DSBezelActivityView newActivityViewForView:view withLabel:sMessage width:280];}];
}
 */
+(NSString *)fontWithIndex:(int)index
{
    return [fontsNames[index] mutableCopy];
}
// Assumes input like "#00FF00" (#RRGGBB).
/*
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
+(int)textViewHeightForText:(NSString *)str andDic:(NSDictionary *)params
{
    UIFont *fontTextView;
    CGSize constraintSize;
    if(!params)
    {
        fontTextView = [UIFont systemFontOfSize:15];
        constraintSize = CGSizeMake(160, MAXFLOAT);
    }
    else
    {
        fontTextView = [params objectForKey:@"font"];
        constraintSize = CGSizeMake([[params objectForKey:@"width"] integerValue], MAXFLOAT);
    }
    CGRect textRect = [str boundingRectWithSize:constraintSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:fontTextView}
                                        context:nil];
    return textRect.size.height;
}

#pragma mark - message views
+ (void) ShowErrorMessage:(NSString*)sMsg {
    #ifndef SHARE_EXTENSION
	[MiscFunc RunOnMainThread:^(void) {[[[UIAlertView alloc] initWithTitle:@"Error" message:sMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];}];
    #endif
}

+ (void) ShowErrorMessage:(NSString*)sMsg onView:(UIViewController*)vTop {
	[MiscFunc ShowErrorMessage:sMsg];
	return;
	//
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed: @"PopupView" owner:nil options:nil];
	UIView *vMessage = [nib objectAtIndex:0];
	vMessage.center = vTop.view.center;
	UILabel *lblTitle = (UILabel *)[vMessage viewWithTag:1];
	lblTitle.text = @"Error";
	UILabel *lblMessage = (UILabel *)[vMessage viewWithTag:2];
	lblMessage.text = sMsg;
	UIButton *btn = (UIButton *)[vMessage viewWithTag:3];
	[btn addTarget:vMessage action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
	
	[vTop.view addSubview:vMessage];
}

+ (void) ShowInfoMessage:(NSString*)sMsg {
#ifndef SHARE_EXTENSION
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:NSLocalizedString(@"Sportspage", nil)
						  message:sMsg
						  delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[MiscFunc RunOnMainThread:^(void) {[alert show];}];
#endif
}

+ (void) ShowInfoMessage:(NSString*)sMsg onView:(UIViewController*)vTop {
	[MiscFunc RunOnMainThread:^(void) {[MiscFunc ShowInfoMessage:sMsg];}];
}


*/

#pragma mark - MultiThreading

+ (void) RunOnMainThread:(dispatch_block_t)block {
	dispatch_async(dispatch_get_main_queue(), block);
}
/*
+ (dispatch_queue_t) BackgroundQueue {
    return ((UserManager *)[UserManager userManager]).BackgroundQueue;
    //return dispatch_get_main_queue();
}

*/
+(NSString *)getCacheDirPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

@end
@implementation NSDictionary (JRAdditions)

- (NSDictionary *) dictionaryByReplacingNullsWithNil:(NSDictionary*)sourceDictionary {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:sourceDictionary];
    const id nul = [NSNull null];
    
    for(NSString *key in replaced) {
        const id object = [sourceDictionary objectForKey:key];
        if(object == nul) {
            [replaced setValue:nil forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:replaced];
}

-(NSDictionary *) nestedDictionaryByReplacingNullsWithNil:(NSDictionary*)sourceDictionary
{
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:sourceDictionary];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    [sourceDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        object = [sourceDictionary objectForKey:key];
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *innerDict = object;
            [replaced setObject:[self nestedDictionaryByReplacingNullsWithNil:innerDict] forKey:key];
            
        }
        else if([object isKindOfClass:[NSArray class]]){
            NSMutableArray *nullFreeRecords = [NSMutableArray array];
            for (id record in object) {
                
                if([record isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *nullFreeRecord = [self nestedDictionaryByReplacingNullsWithNil:record];
                    [nullFreeRecords addObject:nullFreeRecord];
                }
                ////new if//// for languages of profile
                else
                {
                    if([record isKindOfClass:[NSString class]])
                    {
                        [nullFreeRecords addObject:record];
                    }
                }
            }
            [replaced setObject:nullFreeRecords forKey:key];
        }
        else
        {
            if(object == nul) {
                [replaced setObject:blank forKey:key];
            }
        }
    }];
    
    return [NSDictionary dictionaryWithDictionary:replaced];
}@end
