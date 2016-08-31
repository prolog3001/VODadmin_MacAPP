//
//  IAPManager.m
//  VODUniversal
//
//  Created by Gilad Kedmi on 17/12/2015.
//  Copyright © 2015 Gphone. All rights reserved.
//

#import "IAPManager.h"
#import "MKStoreKit.h"
#import <StoreKit/SKProduct.h>
#import "MiscFunc.h"
#import "CommonDefs.h"

static  IAPManager* instance = nil;

@implementation IAPManager

+ (id)iapManager
{
    if (!instance)
    {
        instance = [[IAPManager alloc] init];
    }
    return  instance;
}
-(id)init
{
    NSString *appDetailsFile = [[NSBundle mainBundle] pathForResource:@"MKStoreKitConfigs" ofType:@"plist"];
    NSDictionary *dic  = [NSDictionary dictionaryWithContentsOfFile:appDetailsFile];
    mProductIds = [dic objectForKey:@"Others"];
    [self setCoursesPurchases];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkStoreKitRestoredPurchasesNotification:) name:kMKStoreKitRestoredPurchasesNotification object:nil];
    return self;
}
-(void)setCoursesPurchases
{
    NSString *cachePath = [MiscFunc getCacheDirPath];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"CoursesPurchased.plist"];
    DLog(@"CoursesPurchased = %@",filePath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])//first time running
    {
        NSMutableDictionary *newdic = [[NSMutableDictionary alloc] init];
        //NSString *appDetailsFile = [[NSBundle mainBundle] pathForResource:@"MKStoreKitConfigs" ofType:@"plist"];
        //NSDictionary *dic  = [NSDictionary dictionaryWithContentsOfFile:appDetailsFile];
        //NSArray *arr = [dic objectForKey:@"Others"];
        for (NSString *productID in mProductIds) {
            if([[MKStoreKit sharedKit] isProductPurchased:productID])
            {
                [newdic setObject:[NSNumber numberWithBool:YES] forKey:productID];
            }
            else
            [newdic setObject:[NSNumber numberWithBool:NO] forKey:productID];
        }
        mCoursesPurchases = newdic;
        [newdic writeToFile:filePath atomically:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPurchaseRecordNotification) name:CheckPurchaseRecordNotification object:nil];
    }
    else
    {
       mCoursesPurchases = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
}
-(void)mkStoreKitRestoredPurchasesNotification:(NSNotification *)notification
{
    DLog(@"MKStoreKitProductPurchasedNotification - %@",notification.object);
}
-(void)checkPurchaseRecordNotification
{
    NSMutableDictionary *mutabledic = [[NSMutableDictionary alloc] initWithDictionary:mCoursesPurchases];
   // NSString *appDetailsFile = [[NSBundle mainBundle] pathForResource:@"MKStoreKitConfigs" ofType:@"plist"];
   // NSDictionary *dic  = [NSDictionary dictionaryWithContentsOfFile:appDetailsFile];
    //NSArray *arr = [dic objectForKey:@"Others"];
    for (NSString *productID in mProductIds) {
        if([[MKStoreKit sharedKit] isProductPurchased:productID])
        {
            [mutabledic setObject:[NSNumber numberWithBool:YES] forKey:productID];
        }
        else
            [mutabledic setObject:[NSNumber numberWithBool:NO] forKey:productID];
    }
    mCoursesPurchases = nil;
    mCoursesPurchases = mutabledic;
    NSString *cachePath = [MiscFunc getCacheDirPath];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"CoursesPurchased.plist"];
    [mCoursesPurchases writeToFile:filePath atomically:YES];
}
-(BOOL)isThisCoursedPurchased:(int)courseIndex
{
    //NSString *appDetailsFile = [[NSBundle mainBundle] pathForResource:@"MKStoreKitConfigs" ofType:@"plist"];
    //NSDictionary *dic  = [NSDictionary dictionaryWithContentsOfFile:appDetailsFile];
    //NSArray *arr = [dic objectForKey:@"Others"];
    NSString *productID = [mProductIds objectAtIndex:courseIndex];
    return [[mCoursesPurchases objectForKey:productID] boolValue];
}
-(NSString *)IAPProductTitle:(int)productIdx
{
    NSArray *products = [MKStoreKit sharedKit].availableProducts;
    if(products && [products count] > productIdx)
    {
        NSString *currentcourseProductId = [self productID:productIdx];
        for (int i = 0; i < [products count]; i++) {
            SKProduct *product = [products objectAtIndex:i];
            if([product.productIdentifier isEqualToString:currentcourseProductId])
            {
                return product.localizedTitle;
            }
        DLog(@"IAPProductTitle with index %d = %@",i, product.localizedTitle);
        }
        return @"";
    }
    else
        return @"";
    /*
    if(products && [products count] > productIdx)
    {
        SKProduct *product = [products objectAtIndex:productIdx];
        return product.localizedTitle;
    }
    else
        return @"";
     */
}
-(NSString *)IAPProductDesc:(int)productIdx
{
    NSArray *products = [MKStoreKit sharedKit].availableProducts;
    if(products && [products count] > productIdx)
    {
        NSString *currentcourseProductId = [self productID:productIdx];
        for (int i = 0; i < [products count]; i++) {
            SKProduct *product = [products objectAtIndex:i];
            if([product.productIdentifier isEqualToString:currentcourseProductId])
            {
                return product.localizedDescription;
            }
        }
        return @"";
    }
    else
        return @"";
    /*
    if(products && [products count] > productIdx)
    {
        SKProduct *product = [products objectAtIndex:productIdx];
        return product.localizedDescription;
    }
    else
        return @"";
     */
}
-(NSString *)IAPProductPrice:(int)productIdx
{
    NSArray *products = [MKStoreKit sharedKit].availableProducts;
    if(products && [products count] > productIdx)
    {
        NSString *currentcourseProductId = [self productID:productIdx];
        for (int i = 0; i < [products count]; i++) {
            SKProduct *product = [products objectAtIndex:i];
            if([product.productIdentifier isEqualToString:currentcourseProductId])
            {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                [numberFormatter setLocale:product.priceLocale];
                NSString *formattedString = [numberFormatter stringFromNumber:product.price];
                numberFormatter = nil;
                
                NSString *priceString = [NSString stringWithFormat:@"%@", formattedString];
                return priceString;
            }
        }
        return @"";
    }
    else
        return @"";
    /*
    if(products && [products count] > productIdx)
    {
        SKProduct *product = [products objectAtIndex:productIdx];
    //return [NSString stringWithFormat:@"%@",product.price];
    
    
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedString = [numberFormatter stringFromNumber:product.price];
        numberFormatter = nil;
    
        NSString *priceString = [NSString stringWithFormat:@"%@", formattedString];
        return priceString;
    }
    else
        return @"";
     */
}
-(NSString *)productID:(int)courseIndex
{
    //NSString *appDetailsFile = [[NSBundle mainBundle] pathForResource:@"MKStoreKitConfigs" ofType:@"plist"];
    //NSDictionary *dic  = [NSDictionary dictionaryWithContentsOfFile:appDetailsFile];
    //NSArray *arr = [dic objectForKey:@"Others"];
    if(mProductIds && [mProductIds count] > courseIndex)
        return [mProductIds objectAtIndex:courseIndex];
    else
        return @"";
}

-(void)productPurchased:(NSString *)productID
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:mCoursesPurchases];
    [dic setObject:[NSNumber numberWithBool:YES] forKey:productID];
    mCoursesPurchases = nil;
    mCoursesPurchases = dic;
    NSString *cachePath = [MiscFunc getCacheDirPath];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"CoursesPurchased.plist"];
    [mCoursesPurchases writeToFile:filePath atomically:YES];
}
-(BOOL)isThisCoursePurchased:(int)courseIDIdx
{
    //NSString *appDetailsFile = [[NSBundle mainBundle] pathForResource:@"MKStoreKitConfigs" ofType:@"plist"];
    //NSDictionary *dic  = [NSDictionary dictionaryWithContentsOfFile:appDetailsFile];
    //NSArray *arr = [dic objectForKey:@"Others"];
    NSString *productID = [mProductIds objectAtIndex:courseIDIdx];
    
    return [[mCoursesPurchases objectForKey:productID] boolValue];
}
-(void)restorePressed
{
    [[MKStoreKit sharedKit] restorePurchases];
}
@end
