//
//  PaypalTexts.h
//
//  Created by Gilad Kedmi on 07/12/2015
//  Copyright (c) 2015 Gphone. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PaypalTexts : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *cancelBtn;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *purchasBtn;
@property (nonatomic, strong) NSString *picNote;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
