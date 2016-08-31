//
//  RaitingList.m
//
//  Created by Gilad Kedmi on 07/12/2015
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import "RaitingList.h"


NSString *const kRaitingListID = @"ID";
NSString *const kRaitingListName = @"Name";
NSString *const kRaitingListChecked = @"Checked";


@interface RaitingList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RaitingList

@synthesize iDProperty = _iDProperty;
@synthesize name = _name;
@synthesize checked = _checked;


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
            self.iDProperty = [[self objectOrNilForKey:kRaitingListID fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kRaitingListName fromDictionary:dict];
            self.checked = [[self objectOrNilForKey:kRaitingListChecked fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.iDProperty] forKey:kRaitingListID];
    [mutableDict setValue:self.name forKey:kRaitingListName];
    [mutableDict setValue:[NSNumber numberWithBool:self.checked] forKey:kRaitingListChecked];

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

    self.iDProperty = [aDecoder decodeDoubleForKey:kRaitingListID];
    self.name = [aDecoder decodeObjectForKey:kRaitingListName];
    self.checked = [aDecoder decodeBoolForKey:kRaitingListChecked];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_iDProperty forKey:kRaitingListID];
    [aCoder encodeObject:_name forKey:kRaitingListName];
    [aCoder encodeBool:_checked forKey:kRaitingListChecked];
}

- (id)copyWithZone:(NSZone *)zone
{
    RaitingList *copy = [[RaitingList alloc] init];
    
    if (copy) {

        copy.iDProperty = self.iDProperty;
        copy.name = [self.name copyWithZone:zone];
        copy.checked = self.checked;
    }
    
    return copy;
}


@end
