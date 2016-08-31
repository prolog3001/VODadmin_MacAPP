//
//  WebService.h
//  
//
//  Created by  on 12/14/11.
//  Copyright (c) 2011 Tomer Lavi (Assist). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SFData.h"
#import <dispatch/dispatch.h>


#define WS_SERVER_URL @"http://prologdigital.com/api/PrologApi/"

//13 ספרדית בסיסית
//http://prologdigital.com/api/PrologApi/

@class SFData;


@interface WebService : NSObject

+ (WebService *) SharedWebService;
- (void) CallWebService:(NSString *)sServiceID WithGet:(NSString*)sGet Post:(NSDictionary*)aPost success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
- (NSString*) GetDefaultPostPayload;

@end
