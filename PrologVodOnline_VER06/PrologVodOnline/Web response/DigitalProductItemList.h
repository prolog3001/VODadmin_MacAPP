//
//  DigitalProductItemList.h
//
//  Created by Gilad Kedmi on 07/12/2015
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DigitalProductItemList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double itemTypeID;
@property (nonatomic, strong) NSString *digitalProductItemListDescription;
@property (nonatomic, strong) NSString *urlDB;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) id vimeoPreviewImage;
@property (nonatomic, assign) double itemID;
@property (nonatomic, assign) BOOL watched;
@property (nonatomic, assign) id product;
@property (nonatomic, assign) double spokenLanguageID;
@property (nonatomic, assign) double productID;
@property (nonatomic, strong) NSString *urlCurrent;
@property (nonatomic, strong) NSString *chapterName;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, assign) double raitingID;
@property (nonatomic, strong) NSString *fullFileName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
