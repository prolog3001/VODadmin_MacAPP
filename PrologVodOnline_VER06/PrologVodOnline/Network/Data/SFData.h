//
//  SFData.h
//
//  Created by  on 2/23/12.
//  Copyright (c) 2012 Tomer Lavi (Assist). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebService.h"




@protocol DataDownloaderDelegate
- (void) onDownloadSuccess:(NSString *)ServiceID;
@optional
- (void) onDownloadFailed:(NSString *)ServiceID;
@end

@interface SFData : NSObject


@property (nonatomic, readonly) NSObject<DataDownloaderDelegate> *Delegate;
@property (nonatomic, readonly) NSString* ServiceParams;
@property (nonatomic, retain) NSString* ServiceID;
@property (nonatomic, retain) NSMutableDictionary *Data;
@property (nonatomic, readonly) NSMutableArray *Result;
@property (nonatomic, readonly) BOOL IsMandatory;
@property (nonatomic, retain) NSArray* AllowErrors;

- (void) LoadDataFromServer:(NSString*)sGet Post:(NSDictionary*)aPost success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//- (void)requestFinished:(id)response;
//- (void)requestError:(NSError*)error;

+ (id)sfdataSharedObject;

@end
