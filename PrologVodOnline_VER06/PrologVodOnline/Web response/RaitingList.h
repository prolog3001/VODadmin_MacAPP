//
//  RaitingList.h
//
//  Created by Gilad Kedmi on 07/12/2015
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RaitingList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double iDProperty;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL checked;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
