//
//  IAPManager.h
//  VODUniversal
//
//  Created by Gilad Kedmi on 17/12/2015.
//  Copyright © 2015 Gphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPManager : NSObject
{
    NSDictionary *mCoursesPurchases;
    NSArray *mProductIds;
}

+ (id)iapManager;
-(BOOL)isThisCoursedPurchased:(int)courseIndex;
-(NSString *)IAPProductTitle:(int)productIdx;
-(NSString *)IAPProductDesc:(int)productIdx;
-(NSString *)IAPProductPrice:(int)productIdx;
-(NSString *)productID:(int)courseIndex;
-(void)productPurchased:(NSString *)productID;
-(BOOL)isThisCoursePurchased:(int)courseIDIdx;
-(void)restorePressed;
@end
