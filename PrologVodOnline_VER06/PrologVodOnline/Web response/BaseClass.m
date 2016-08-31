//
//  BaseClass.m
//
//  Created by Gilad Kedmi on 07/12/2015
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import "BaseClass.h"
#import "PaypalTexts.h"
#import "RaitingList.h"
#import "DigitalProductItemList.h"


NSString *const kBaseClassIsShow = @"IsShow";
NSString *const kBaseClassFreeItems = @"FreeItems";
NSString *const kBaseClassBtnDetailsText = @"btnDetailsText";
NSString *const kBaseClassProductsOrder = @"ProductsOrder";
NSString *const kBaseClassParent = @"Parent";
NSString *const kBaseClassBtnPurchasedText = @"btnPurchasedText";
NSString *const kBaseClassIsPurchased = @"IsPurchased";
NSString *const kBaseClassLearnedLanguagesID = @"LearnedLanguagesID";
NSString *const kBaseClassProductToUserID = @"ProductToUserID";
NSString *const kBaseClassDomain = @"Domain";
NSString *const kBaseClassProductImageDataURL = @"ProductImageDataURL";
NSString *const kBaseClassProductMobileIcon = @"ProductMobileIcon";
NSString *const kBaseClassPaypalTexts = @"PaypalTexts";
NSString *const kBaseClassMakat = @"Makat";
NSString *const kBaseClassProductDescription = @"ProductDescription";
NSString *const kBaseClassCurrencySign = @"CurrencySign";
NSString *const kBaseClassProductName = @"ProductName";
NSString *const kBaseClassSpokenLanguagesID = @"SpokenLanguagesID";
NSString *const kBaseClassFreeItemText = @"FreeItemText";
NSString *const kBaseClassIsOutOfStok = @"IsOutOfStok";
NSString *const kBaseClassCurrency = @"Currency";
NSString *const kBaseClassRaitingList = @"RaitingList";
NSString *const kBaseClassIsInterested = @"IsInterested";
NSString *const kBaseClassTxtPurchasedText = @"txtPurchasedText";
NSString *const kBaseClassProductID = @"ProductID";
NSString *const kBaseClassPublishedID = @"PublishedID";
NSString *const kBaseClassPrice = @"Price";
NSString *const kBaseClassDigitalProductItemList = @"DigitalProductItemList";
NSString *const kBaseClassPublishedProductID = @"PublishedProductID";


@interface BaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BaseClass

@synthesize isShow = _isShow;
@synthesize freeItems = _freeItems;
@synthesize btnDetailsText = _btnDetailsText;
@synthesize productsOrder = _productsOrder;
@synthesize parent = _parent;
@synthesize btnPurchasedText = _btnPurchasedText;
@synthesize isPurchased = _isPurchased;
@synthesize learnedLanguagesID = _learnedLanguagesID;
@synthesize productToUserID = _productToUserID;
@synthesize domain = _domain;
@synthesize productImageDataURL = _productImageDataURL;
@synthesize productMobileIcon = _productMobileIcon;
@synthesize paypalTexts = _paypalTexts;
@synthesize makat = _makat;
@synthesize productDescription = _productDescription;
@synthesize currencySign = _currencySign;
@synthesize productName = _productName;
@synthesize spokenLanguagesID = _spokenLanguagesID;
@synthesize freeItemText = _freeItemText;
@synthesize isOutOfStok = _isOutOfStok;
@synthesize currency = _currency;
@synthesize raitingList = _raitingList;
@synthesize isInterested = _isInterested;
@synthesize txtPurchasedText = _txtPurchasedText;
@synthesize productID = _productID;
@synthesize publishedID = _publishedID;
@synthesize price = _price;
@synthesize digitalProductItemList = _digitalProductItemList;
@synthesize publishedProductID = _publishedProductID;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.isShow = [[self objectOrNilForKey:kBaseClassIsShow fromDictionary:dict] boolValue];
            self.freeItems = [[self objectOrNilForKey:kBaseClassFreeItems fromDictionary:dict] doubleValue];
            self.btnDetailsText = [self objectOrNilForKey:kBaseClassBtnDetailsText fromDictionary:dict];
            self.productsOrder = [[self objectOrNilForKey:kBaseClassProductsOrder fromDictionary:dict] doubleValue];
            self.parent = [self objectOrNilForKey:kBaseClassParent fromDictionary:dict];
            self.btnPurchasedText = [self objectOrNilForKey:kBaseClassBtnPurchasedText fromDictionary:dict];
            self.isPurchased = [[self objectOrNilForKey:kBaseClassIsPurchased fromDictionary:dict] boolValue];
            self.learnedLanguagesID = [[self objectOrNilForKey:kBaseClassLearnedLanguagesID fromDictionary:dict] doubleValue];
            self.productToUserID = [[self objectOrNilForKey:kBaseClassProductToUserID fromDictionary:dict] doubleValue];
            self.domain = [self objectOrNilForKey:kBaseClassDomain fromDictionary:dict];
            self.productImageDataURL = [self objectOrNilForKey:kBaseClassProductImageDataURL fromDictionary:dict];
            self.productMobileIcon = [self objectOrNilForKey:kBaseClassProductMobileIcon fromDictionary:dict];
            self.paypalTexts = [PaypalTexts modelObjectWithDictionary:[dict objectForKey:kBaseClassPaypalTexts]];
            self.makat = [self objectOrNilForKey:kBaseClassMakat fromDictionary:dict];
            self.productDescription = [self objectOrNilForKey:kBaseClassProductDescription fromDictionary:dict];
            self.currencySign = [self objectOrNilForKey:kBaseClassCurrencySign fromDictionary:dict];
            self.productName = [self objectOrNilForKey:kBaseClassProductName fromDictionary:dict];
            self.spokenLanguagesID = [[self objectOrNilForKey:kBaseClassSpokenLanguagesID fromDictionary:dict] doubleValue];
            self.freeItemText = [self objectOrNilForKey:kBaseClassFreeItemText fromDictionary:dict];
            self.isOutOfStok = [[self objectOrNilForKey:kBaseClassIsOutOfStok fromDictionary:dict] boolValue];
            self.currency = [self objectOrNilForKey:kBaseClassCurrency fromDictionary:dict];
    NSObject *receivedRaitingList = [dict objectForKey:kBaseClassRaitingList];
    NSMutableArray *parsedRaitingList = [NSMutableArray array];
    if ([receivedRaitingList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedRaitingList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedRaitingList addObject:[RaitingList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedRaitingList isKindOfClass:[NSDictionary class]]) {
       [parsedRaitingList addObject:[RaitingList modelObjectWithDictionary:(NSDictionary *)receivedRaitingList]];
    }

    self.raitingList = [NSArray arrayWithArray:parsedRaitingList];
            self.isInterested = [[self objectOrNilForKey:kBaseClassIsInterested fromDictionary:dict] boolValue];
            self.txtPurchasedText = [self objectOrNilForKey:kBaseClassTxtPurchasedText fromDictionary:dict];
            self.productID = [[self objectOrNilForKey:kBaseClassProductID fromDictionary:dict] doubleValue];
            self.publishedID = [[self objectOrNilForKey:kBaseClassPublishedID fromDictionary:dict] doubleValue];
            self.price = [[self objectOrNilForKey:kBaseClassPrice fromDictionary:dict] doubleValue];
    NSObject *receivedDigitalProductItemList = [dict objectForKey:kBaseClassDigitalProductItemList];
    NSMutableArray *parsedDigitalProductItemList = [NSMutableArray array];
    if ([receivedDigitalProductItemList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedDigitalProductItemList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedDigitalProductItemList addObject:[DigitalProductItemList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedDigitalProductItemList isKindOfClass:[NSDictionary class]]) {
       [parsedDigitalProductItemList addObject:[DigitalProductItemList modelObjectWithDictionary:(NSDictionary *)receivedDigitalProductItemList]];
    }

    self.digitalProductItemList = [NSArray arrayWithArray:parsedDigitalProductItemList];
            self.publishedProductID = [[self objectOrNilForKey:kBaseClassPublishedProductID fromDictionary:dict] doubleValue];

    }
    [self devideArrays];
    return self;
    
}
-(void)devideArrays
{
    if(self.mDigitalVimeoProductItemList)
    {
        self.mDigitalVimeoProductItemList = nil;
    }
    if(self.mDigitalPdfProductItemList)
    {
        self.mDigitalPdfProductItemList = nil;
    }
    self.mDigitalVimeoProductItemList = [[NSMutableArray alloc] init];
    self.mDigitalPdfProductItemList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.digitalProductItemList count]; ++i) {
        DigitalProductItemList *item = [self.digitalProductItemList objectAtIndex:i];
        if([item.fileType isEqualToString:@"vimeo"])
        {
            [self.mDigitalVimeoProductItemList addObject:item];
        }
        else
        {
            if([item.fileType isEqualToString:@"pdf"])
            {
                [self.mDigitalPdfProductItemList addObject:item];
            }
        }
    }
}
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.isShow] forKey:kBaseClassIsShow];
    [mutableDict setValue:[NSNumber numberWithDouble:self.freeItems] forKey:kBaseClassFreeItems];
    [mutableDict setValue:self.btnDetailsText forKey:kBaseClassBtnDetailsText];
    [mutableDict setValue:[NSNumber numberWithDouble:self.productsOrder] forKey:kBaseClassProductsOrder];
    [mutableDict setValue:self.parent forKey:kBaseClassParent];
    [mutableDict setValue:self.btnPurchasedText forKey:kBaseClassBtnPurchasedText];
    [mutableDict setValue:[NSNumber numberWithBool:self.isPurchased] forKey:kBaseClassIsPurchased];
    [mutableDict setValue:[NSNumber numberWithDouble:self.learnedLanguagesID] forKey:kBaseClassLearnedLanguagesID];
    [mutableDict setValue:[NSNumber numberWithDouble:self.productToUserID] forKey:kBaseClassProductToUserID];
    [mutableDict setValue:self.domain forKey:kBaseClassDomain];
    [mutableDict setValue:self.productImageDataURL forKey:kBaseClassProductImageDataURL];
    [mutableDict setValue:self.productMobileIcon forKey:kBaseClassProductMobileIcon];
    [mutableDict setValue:[self.paypalTexts dictionaryRepresentation] forKey:kBaseClassPaypalTexts];
    [mutableDict setValue:self.makat forKey:kBaseClassMakat];
    [mutableDict setValue:self.productDescription forKey:kBaseClassProductDescription];
    [mutableDict setValue:self.currencySign forKey:kBaseClassCurrencySign];
    [mutableDict setValue:self.productName forKey:kBaseClassProductName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.spokenLanguagesID] forKey:kBaseClassSpokenLanguagesID];
    [mutableDict setValue:self.freeItemText forKey:kBaseClassFreeItemText];
    [mutableDict setValue:[NSNumber numberWithBool:self.isOutOfStok] forKey:kBaseClassIsOutOfStok];
    [mutableDict setValue:self.currency forKey:kBaseClassCurrency];
    NSMutableArray *tempArrayForRaitingList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.raitingList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForRaitingList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForRaitingList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForRaitingList] forKey:kBaseClassRaitingList];
    [mutableDict setValue:[NSNumber numberWithBool:self.isInterested] forKey:kBaseClassIsInterested];
    [mutableDict setValue:self.txtPurchasedText forKey:kBaseClassTxtPurchasedText];
    [mutableDict setValue:[NSNumber numberWithDouble:self.productID] forKey:kBaseClassProductID];
    [mutableDict setValue:[NSNumber numberWithDouble:self.publishedID] forKey:kBaseClassPublishedID];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kBaseClassPrice];
    NSMutableArray *tempArrayForDigitalProductItemList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.digitalProductItemList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForDigitalProductItemList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForDigitalProductItemList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDigitalProductItemList] forKey:kBaseClassDigitalProductItemList];
    [mutableDict setValue:[NSNumber numberWithDouble:self.publishedProductID] forKey:kBaseClassPublishedProductID];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.isShow = [aDecoder decodeBoolForKey:kBaseClassIsShow];
    self.freeItems = [aDecoder decodeDoubleForKey:kBaseClassFreeItems];
    self.btnDetailsText = [aDecoder decodeObjectForKey:kBaseClassBtnDetailsText];
    self.productsOrder = [aDecoder decodeDoubleForKey:kBaseClassProductsOrder];
    self.parent = [aDecoder decodeObjectForKey:kBaseClassParent];
    self.btnPurchasedText = [aDecoder decodeObjectForKey:kBaseClassBtnPurchasedText];
    self.isPurchased = [aDecoder decodeBoolForKey:kBaseClassIsPurchased];
    self.learnedLanguagesID = [aDecoder decodeDoubleForKey:kBaseClassLearnedLanguagesID];
    self.productToUserID = [aDecoder decodeDoubleForKey:kBaseClassProductToUserID];
    self.domain = [aDecoder decodeObjectForKey:kBaseClassDomain];
    self.productImageDataURL = [aDecoder decodeObjectForKey:kBaseClassProductImageDataURL];
    self.productMobileIcon = [aDecoder decodeObjectForKey:kBaseClassProductMobileIcon];
    self.paypalTexts = [aDecoder decodeObjectForKey:kBaseClassPaypalTexts];
    self.makat = [aDecoder decodeObjectForKey:kBaseClassMakat];
    self.productDescription = [aDecoder decodeObjectForKey:kBaseClassProductDescription];
    self.currencySign = [aDecoder decodeObjectForKey:kBaseClassCurrencySign];
    self.productName = [aDecoder decodeObjectForKey:kBaseClassProductName];
    self.spokenLanguagesID = [aDecoder decodeDoubleForKey:kBaseClassSpokenLanguagesID];
    self.freeItemText = [aDecoder decodeObjectForKey:kBaseClassFreeItemText];
    self.isOutOfStok = [aDecoder decodeBoolForKey:kBaseClassIsOutOfStok];
    self.currency = [aDecoder decodeObjectForKey:kBaseClassCurrency];
    self.raitingList = [aDecoder decodeObjectForKey:kBaseClassRaitingList];
    self.isInterested = [aDecoder decodeBoolForKey:kBaseClassIsInterested];
    self.txtPurchasedText = [aDecoder decodeObjectForKey:kBaseClassTxtPurchasedText];
    self.productID = [aDecoder decodeDoubleForKey:kBaseClassProductID];
    self.publishedID = [aDecoder decodeDoubleForKey:kBaseClassPublishedID];
    self.price = [aDecoder decodeDoubleForKey:kBaseClassPrice];
    self.digitalProductItemList = [aDecoder decodeObjectForKey:kBaseClassDigitalProductItemList];
    self.publishedProductID = [aDecoder decodeDoubleForKey:kBaseClassPublishedProductID];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_isShow forKey:kBaseClassIsShow];
    [aCoder encodeDouble:_freeItems forKey:kBaseClassFreeItems];
    [aCoder encodeObject:_btnDetailsText forKey:kBaseClassBtnDetailsText];
    [aCoder encodeDouble:_productsOrder forKey:kBaseClassProductsOrder];
    [aCoder encodeObject:_parent forKey:kBaseClassParent];
    [aCoder encodeObject:_btnPurchasedText forKey:kBaseClassBtnPurchasedText];
    [aCoder encodeBool:_isPurchased forKey:kBaseClassIsPurchased];
    [aCoder encodeDouble:_learnedLanguagesID forKey:kBaseClassLearnedLanguagesID];
    [aCoder encodeDouble:_productToUserID forKey:kBaseClassProductToUserID];
    [aCoder encodeObject:_domain forKey:kBaseClassDomain];
    [aCoder encodeObject:_productImageDataURL forKey:kBaseClassProductImageDataURL];
    [aCoder encodeObject:_productMobileIcon forKey:kBaseClassProductMobileIcon];
    [aCoder encodeObject:_paypalTexts forKey:kBaseClassPaypalTexts];
    [aCoder encodeObject:_makat forKey:kBaseClassMakat];
    [aCoder encodeObject:_productDescription forKey:kBaseClassProductDescription];
    [aCoder encodeObject:_currencySign forKey:kBaseClassCurrencySign];
    [aCoder encodeObject:_productName forKey:kBaseClassProductName];
    [aCoder encodeDouble:_spokenLanguagesID forKey:kBaseClassSpokenLanguagesID];
    [aCoder encodeObject:_freeItemText forKey:kBaseClassFreeItemText];
    [aCoder encodeBool:_isOutOfStok forKey:kBaseClassIsOutOfStok];
    [aCoder encodeObject:_currency forKey:kBaseClassCurrency];
    [aCoder encodeObject:_raitingList forKey:kBaseClassRaitingList];
    [aCoder encodeBool:_isInterested forKey:kBaseClassIsInterested];
    [aCoder encodeObject:_txtPurchasedText forKey:kBaseClassTxtPurchasedText];
    [aCoder encodeDouble:_productID forKey:kBaseClassProductID];
    [aCoder encodeDouble:_publishedID forKey:kBaseClassPublishedID];
    [aCoder encodeDouble:_price forKey:kBaseClassPrice];
    [aCoder encodeObject:_digitalProductItemList forKey:kBaseClassDigitalProductItemList];
    [aCoder encodeDouble:_publishedProductID forKey:kBaseClassPublishedProductID];
}

- (id)copyWithZone:(NSZone *)zone
{
    BaseClass *copy = [[BaseClass alloc] init];
    
    if (copy) {

        copy.isShow = self.isShow;
        copy.freeItems = self.freeItems;
        copy.btnDetailsText = [self.btnDetailsText copyWithZone:zone];
        copy.productsOrder = self.productsOrder;
        copy.parent = [self.parent copyWithZone:zone];
        copy.btnPurchasedText = [self.btnPurchasedText copyWithZone:zone];
        copy.isPurchased = self.isPurchased;
        copy.learnedLanguagesID = self.learnedLanguagesID;
        copy.productToUserID = self.productToUserID;
        copy.domain = [self.domain copyWithZone:zone];
        copy.productImageDataURL = [self.productImageDataURL copyWithZone:zone];
        copy.productMobileIcon = [self.productMobileIcon copyWithZone:zone];
        copy.paypalTexts = [self.paypalTexts copyWithZone:zone];
        copy.makat = [self.makat copyWithZone:zone];
        copy.productDescription = [self.productDescription copyWithZone:zone];
        copy.currencySign = [self.currencySign copyWithZone:zone];
        copy.productName = [self.productName copyWithZone:zone];
        copy.spokenLanguagesID = self.spokenLanguagesID;
        copy.freeItemText = [self.freeItemText copyWithZone:zone];
        copy.isOutOfStok = self.isOutOfStok;
        copy.currency = [self.currency copyWithZone:zone];
        copy.raitingList = [self.raitingList copyWithZone:zone];
        copy.isInterested = self.isInterested;
        copy.txtPurchasedText = [self.txtPurchasedText copyWithZone:zone];
        copy.productID = self.productID;
        copy.publishedID = self.publishedID;
        copy.price = self.price;
        copy.digitalProductItemList = [self.digitalProductItemList copyWithZone:zone];
        copy.publishedProductID = self.publishedProductID;
    }
    
    return copy;
}


@end
