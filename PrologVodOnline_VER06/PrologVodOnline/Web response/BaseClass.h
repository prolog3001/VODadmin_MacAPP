//
//  BaseClass.h
//
//  Created by Gilad Kedmi on 07/12/2015
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PaypalTexts;

@interface BaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) double freeItems;
@property (nonatomic, strong) NSString *btnDetailsText;
@property (nonatomic, assign) double productsOrder;
@property (nonatomic, assign) id parent;
@property (nonatomic, strong) NSString *btnPurchasedText;
@property (nonatomic, assign) BOOL isPurchased;
@property (nonatomic, assign) double learnedLanguagesID;
@property (nonatomic, assign) double productToUserID;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *productImageDataURL;
@property (nonatomic, strong) NSString *productMobileIcon;
@property (nonatomic, strong) PaypalTexts *paypalTexts;
@property (nonatomic, strong) NSString *makat;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSString *currencySign;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) double spokenLanguagesID;
@property (nonatomic, strong) NSString *freeItemText;
@property (nonatomic, assign) BOOL isOutOfStok;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSArray *raitingList;
@property (nonatomic, assign) BOOL isInterested;
@property (nonatomic, strong) NSString *txtPurchasedText;
@property (nonatomic, assign) double productID;
@property (nonatomic, assign) double publishedID;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSArray *digitalProductItemList;
@property (nonatomic, strong) NSMutableArray *mDigitalVimeoProductItemList;
@property (nonatomic, strong) NSMutableArray *mDigitalPdfProductItemList;
@property (nonatomic, assign) double publishedProductID;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
