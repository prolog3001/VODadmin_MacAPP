//
//  DigitalProductItemList.m
//
//  Created by Gilad Kedmi on 07/12/2015
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import "DigitalProductItemList.h"


NSString *const kDigitalProductItemListItemTypeID = @"ItemTypeID";
NSString *const kDigitalProductItemListDescription = @"Description";
NSString *const kDigitalProductItemListUrlDB = @"Url_DB";
NSString *const kDigitalProductItemListName = @"Name";
NSString *const kDigitalProductItemListVimeoPreviewImage = @"VimeoPreviewImage";
NSString *const kDigitalProductItemListItemID = @"ItemID";
NSString *const kDigitalProductItemListWatched = @"Watched";
NSString *const kDigitalProductItemListProduct = @"Product";
NSString *const kDigitalProductItemListSpokenLanguageID = @"SpokenLanguageID";
NSString *const kDigitalProductItemListProductID = @"ProductID";
NSString *const kDigitalProductItemListUrlCurrent = @"Url_Current";
NSString *const kDigitalProductItemListChapterName = @"ChapterName";
NSString *const kDigitalProductItemListFileType = @"FileType";
NSString *const kDigitalProductItemListIsFree = @"IsFree";
NSString *const kDigitalProductItemListRaitingID = @"RaitingID";
NSString *const kDigitalProductItemListFullFileName = @"FullFileName";


@interface DigitalProductItemList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DigitalProductItemList

@synthesize itemTypeID = _itemTypeID;
@synthesize digitalProductItemListDescription = _digitalProductItemListDescription;
@synthesize urlDB = _urlDB;
@synthesize name = _name;
@synthesize vimeoPreviewImage = _vimeoPreviewImage;
@synthesize itemID = _itemID;
@synthesize watched = _watched;
@synthesize product = _product;
@synthesize spokenLanguageID = _spokenLanguageID;
@synthesize productID = _productID;
@synthesize urlCurrent = _urlCurrent;
@synthesize chapterName = _chapterName;
@synthesize fileType = _fileType;
@synthesize isFree = _isFree;
@synthesize raitingID = _raitingID;
@synthesize fullFileName = _fullFileName;


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
            self.itemTypeID = [[self objectOrNilForKey:kDigitalProductItemListItemTypeID fromDictionary:dict] doubleValue];
            self.digitalProductItemListDescription = [self objectOrNilForKey:kDigitalProductItemListDescription fromDictionary:dict];
            self.urlDB = [self objectOrNilForKey:kDigitalProductItemListUrlDB fromDictionary:dict];
            self.name = [self objectOrNilForKey:kDigitalProductItemListName fromDictionary:dict];
            self.vimeoPreviewImage = [self objectOrNilForKey:kDigitalProductItemListVimeoPreviewImage fromDictionary:dict];
            self.itemID = [[self objectOrNilForKey:kDigitalProductItemListItemID fromDictionary:dict] doubleValue];
            self.watched = [[self objectOrNilForKey:kDigitalProductItemListWatched fromDictionary:dict] boolValue];
            self.product = [self objectOrNilForKey:kDigitalProductItemListProduct fromDictionary:dict];
            self.spokenLanguageID = [[self objectOrNilForKey:kDigitalProductItemListSpokenLanguageID fromDictionary:dict] doubleValue];
            self.productID = [[self objectOrNilForKey:kDigitalProductItemListProductID fromDictionary:dict] doubleValue];
            self.urlCurrent = [self objectOrNilForKey:kDigitalProductItemListUrlCurrent fromDictionary:dict];
            self.chapterName = [self objectOrNilForKey:kDigitalProductItemListChapterName fromDictionary:dict];
            self.fileType = [self objectOrNilForKey:kDigitalProductItemListFileType fromDictionary:dict];
            self.isFree = [[self objectOrNilForKey:kDigitalProductItemListIsFree fromDictionary:dict] boolValue];
            self.raitingID = [[self objectOrNilForKey:kDigitalProductItemListRaitingID fromDictionary:dict] doubleValue];
            self.fullFileName = [self objectOrNilForKey:kDigitalProductItemListFullFileName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.itemTypeID] forKey:kDigitalProductItemListItemTypeID];
    [mutableDict setValue:self.digitalProductItemListDescription forKey:kDigitalProductItemListDescription];
    [mutableDict setValue:self.urlDB forKey:kDigitalProductItemListUrlDB];
    [mutableDict setValue:self.name forKey:kDigitalProductItemListName];
    [mutableDict setValue:self.vimeoPreviewImage forKey:kDigitalProductItemListVimeoPreviewImage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.itemID] forKey:kDigitalProductItemListItemID];
    [mutableDict setValue:[NSNumber numberWithBool:self.watched] forKey:kDigitalProductItemListWatched];
    [mutableDict setValue:self.product forKey:kDigitalProductItemListProduct];
    [mutableDict setValue:[NSNumber numberWithDouble:self.spokenLanguageID] forKey:kDigitalProductItemListSpokenLanguageID];
    [mutableDict setValue:[NSNumber numberWithDouble:self.productID] forKey:kDigitalProductItemListProductID];
    [mutableDict setValue:self.urlCurrent forKey:kDigitalProductItemListUrlCurrent];
    [mutableDict setValue:self.chapterName forKey:kDigitalProductItemListChapterName];
    [mutableDict setValue:self.fileType forKey:kDigitalProductItemListFileType];
    [mutableDict setValue:[NSNumber numberWithBool:self.isFree] forKey:kDigitalProductItemListIsFree];
    [mutableDict setValue:[NSNumber numberWithDouble:self.raitingID] forKey:kDigitalProductItemListRaitingID];
    [mutableDict setValue:self.fullFileName forKey:kDigitalProductItemListFullFileName];

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

    self.itemTypeID = [aDecoder decodeDoubleForKey:kDigitalProductItemListItemTypeID];
    self.digitalProductItemListDescription = [aDecoder decodeObjectForKey:kDigitalProductItemListDescription];
    self.urlDB = [aDecoder decodeObjectForKey:kDigitalProductItemListUrlDB];
    self.name = [aDecoder decodeObjectForKey:kDigitalProductItemListName];
    self.vimeoPreviewImage = [aDecoder decodeObjectForKey:kDigitalProductItemListVimeoPreviewImage];
    self.itemID = [aDecoder decodeDoubleForKey:kDigitalProductItemListItemID];
    self.watched = [aDecoder decodeBoolForKey:kDigitalProductItemListWatched];
    self.product = [aDecoder decodeObjectForKey:kDigitalProductItemListProduct];
    self.spokenLanguageID = [aDecoder decodeDoubleForKey:kDigitalProductItemListSpokenLanguageID];
    self.productID = [aDecoder decodeDoubleForKey:kDigitalProductItemListProductID];
    self.urlCurrent = [aDecoder decodeObjectForKey:kDigitalProductItemListUrlCurrent];
    self.chapterName = [aDecoder decodeObjectForKey:kDigitalProductItemListChapterName];
    self.fileType = [aDecoder decodeObjectForKey:kDigitalProductItemListFileType];
    self.isFree = [aDecoder decodeBoolForKey:kDigitalProductItemListIsFree];
    self.raitingID = [aDecoder decodeDoubleForKey:kDigitalProductItemListRaitingID];
    self.fullFileName = [aDecoder decodeObjectForKey:kDigitalProductItemListFullFileName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_itemTypeID forKey:kDigitalProductItemListItemTypeID];
    [aCoder encodeObject:_digitalProductItemListDescription forKey:kDigitalProductItemListDescription];
    [aCoder encodeObject:_urlDB forKey:kDigitalProductItemListUrlDB];
    [aCoder encodeObject:_name forKey:kDigitalProductItemListName];
    [aCoder encodeObject:_vimeoPreviewImage forKey:kDigitalProductItemListVimeoPreviewImage];
    [aCoder encodeDouble:_itemID forKey:kDigitalProductItemListItemID];
    [aCoder encodeBool:_watched forKey:kDigitalProductItemListWatched];
    [aCoder encodeObject:_product forKey:kDigitalProductItemListProduct];
    [aCoder encodeDouble:_spokenLanguageID forKey:kDigitalProductItemListSpokenLanguageID];
    [aCoder encodeDouble:_productID forKey:kDigitalProductItemListProductID];
    [aCoder encodeObject:_urlCurrent forKey:kDigitalProductItemListUrlCurrent];
    [aCoder encodeObject:_chapterName forKey:kDigitalProductItemListChapterName];
    [aCoder encodeObject:_fileType forKey:kDigitalProductItemListFileType];
    [aCoder encodeBool:_isFree forKey:kDigitalProductItemListIsFree];
    [aCoder encodeDouble:_raitingID forKey:kDigitalProductItemListRaitingID];
    [aCoder encodeObject:_fullFileName forKey:kDigitalProductItemListFullFileName];
}

- (id)copyWithZone:(NSZone *)zone
{
    DigitalProductItemList *copy = [[DigitalProductItemList alloc] init];
    
    if (copy) {

        copy.itemTypeID = self.itemTypeID;
        copy.digitalProductItemListDescription = [self.digitalProductItemListDescription copyWithZone:zone];
        copy.urlDB = [self.urlDB copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.vimeoPreviewImage = [self.vimeoPreviewImage copyWithZone:zone];
        copy.itemID = self.itemID;
        copy.watched = self.watched;
        copy.product = [self.product copyWithZone:zone];
        copy.spokenLanguageID = self.spokenLanguageID;
        copy.productID = self.productID;
        copy.urlCurrent = [self.urlCurrent copyWithZone:zone];
        copy.chapterName = [self.chapterName copyWithZone:zone];
        copy.fileType = [self.fileType copyWithZone:zone];
        copy.isFree = self.isFree;
        copy.raitingID = self.raitingID;
        copy.fullFileName = [self.fullFileName copyWithZone:zone];
    }
    
    return copy;
}


@end
