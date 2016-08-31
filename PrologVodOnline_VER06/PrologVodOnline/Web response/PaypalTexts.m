//
//  PaypalTexts.m
//
//  Created by Gilad Kedmi on 07/12/2015
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import "PaypalTexts.h"


NSString *const kPaypalTextsPrice = @"Price";
NSString *const kPaypalTextsNote = @"Note";
NSString *const kPaypalTextsCancelBtn = @"CancelBtn";
NSString *const kPaypalTextsTitle = @"Title";
NSString *const kPaypalTextsPurchasBtn = @"PurchasBtn";
NSString *const kPaypalTextsPicNote = @"PicNote";


@interface PaypalTexts ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PaypalTexts

@synthesize price = _price;
@synthesize note = _note;
@synthesize cancelBtn = _cancelBtn;
@synthesize title = _title;
@synthesize purchasBtn = _purchasBtn;
@synthesize picNote = _picNote;


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
            self.price = [self objectOrNilForKey:kPaypalTextsPrice fromDictionary:dict];
            self.note = [self objectOrNilForKey:kPaypalTextsNote fromDictionary:dict];
            self.cancelBtn = [self objectOrNilForKey:kPaypalTextsCancelBtn fromDictionary:dict];
            self.title = [self objectOrNilForKey:kPaypalTextsTitle fromDictionary:dict];
            self.purchasBtn = [self objectOrNilForKey:kPaypalTextsPurchasBtn fromDictionary:dict];
            self.picNote = [self objectOrNilForKey:kPaypalTextsPicNote fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.price forKey:kPaypalTextsPrice];
    [mutableDict setValue:self.note forKey:kPaypalTextsNote];
    [mutableDict setValue:self.cancelBtn forKey:kPaypalTextsCancelBtn];
    [mutableDict setValue:self.title forKey:kPaypalTextsTitle];
    [mutableDict setValue:self.purchasBtn forKey:kPaypalTextsPurchasBtn];
    [mutableDict setValue:self.picNote forKey:kPaypalTextsPicNote];

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

    self.price = [aDecoder decodeObjectForKey:kPaypalTextsPrice];
    self.note = [aDecoder decodeObjectForKey:kPaypalTextsNote];
    self.cancelBtn = [aDecoder decodeObjectForKey:kPaypalTextsCancelBtn];
    self.title = [aDecoder decodeObjectForKey:kPaypalTextsTitle];
    self.purchasBtn = [aDecoder decodeObjectForKey:kPaypalTextsPurchasBtn];
    self.picNote = [aDecoder decodeObjectForKey:kPaypalTextsPicNote];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_price forKey:kPaypalTextsPrice];
    [aCoder encodeObject:_note forKey:kPaypalTextsNote];
    [aCoder encodeObject:_cancelBtn forKey:kPaypalTextsCancelBtn];
    [aCoder encodeObject:_title forKey:kPaypalTextsTitle];
    [aCoder encodeObject:_purchasBtn forKey:kPaypalTextsPurchasBtn];
    [aCoder encodeObject:_picNote forKey:kPaypalTextsPicNote];
}

- (id)copyWithZone:(NSZone *)zone
{
    PaypalTexts *copy = [[PaypalTexts alloc] init];
    
    if (copy) {

        copy.price = [self.price copyWithZone:zone];
        copy.note = [self.note copyWithZone:zone];
        copy.cancelBtn = [self.cancelBtn copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.purchasBtn = [self.purchasBtn copyWithZone:zone];
        copy.picNote = [self.picNote copyWithZone:zone];
    }
    
    return copy;
}


@end
