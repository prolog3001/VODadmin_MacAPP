//
//  WebService.m
//  ArtoPay
//
//  Created by  on 12/14/11.
//  Copyright (c) 2011 Tomer Lavi (Assist). All rights reserved.
//

#import "WebService.h"
#include "MiscFunc.h"
#import "AppDelegate.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "MiscFunc.h"
#import "CommonDefs.h"


@implementation WebService



+ (WebService *) SharedWebService {
	static dispatch_once_t once;
	static WebService* sharedWebService;
    dispatch_once(&once, ^{ sharedWebService = [[self alloc] init];});
    return sharedWebService;
}

- (NSString*) GetDefaultPostPayload {
//	NSString *sToken = [MiscFunc GetDefault:@"SPUserToken"];
//	NSString *sRet = [NSString stringWithFormat:@"device_id=%@", [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
//	if ([sToken length]) sRet = [sRet stringByAppendingFormat:@"&token=%@", sToken];
//	return sRet;
	return @"";
}


- (void) CallWebService:(NSString *)sServiceID WithGet:(NSString*)sGet Post:(NSDictionary*)aPost success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    id aPostID = aPost;
    NSString *sRequest = [WS_SERVER_URL stringByAppendingFormat:@"%@/?%@", sServiceID, [self GetDefaultPostPayload]];
    
    if(sGet)
        sRequest = [WS_SERVER_URL stringByAppendingFormat:@"%@/?%@", sServiceID, [self GetDefaultPostPayload]];
    else
        sRequest = [WS_SERVER_URL stringByAppendingFormat:@"%@", sServiceID];
	if (sGet && sGet.length > 0) sRequest = [sRequest stringByAppendingFormat:@"&%@", sGet];
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    /*
     if (aPost)
     {
         if([sServiceID isEqualToString:@"UserUpdateSocialAccountFriends"])
         {
             //NSError *error = nil;
             //NSData *postData = [NSJSONSerialization dataWithJSONObject:aPost options:0 error:&error];
             //aPostID = postData;
             //manager.requestSerializer = [AFJSONRequestSerializer serializer];
             
            //NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:sRequest parameters:aPost error:nil];
     
             //NSURLResponse *response;
             //[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
             //return;
             [self sendRequestWithNSURLConnection:sServiceID Post:aPost];
             return;
         }
     }
    */
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", /*@"text/json", @"text/javascript", */@"text/html", nil];
    /*
	void (^oSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
		dispatch_async([MiscFunc BackgroundQueue], ^{success(responseObject);});
	};
     */
    
    void (^oSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async([MiscFunc BackgroundQueue], ^{
            //NSDictionary *responseObjectNoNull = [((NSDictionary *)responseObject) nestedDictionaryByReplacingNullsWithNil:((NSDictionary *)responseObject)];
            success(responseObject);});
    };
	void (^oFailBlock)(AFHTTPRequestOperation *operation, NSError *error)  = ^(AFHTTPRequestOperation *operation, NSError *error) {
		dispatch_async([MiscFunc BackgroundQueue], ^{failure(error);});
	};

#if DEBUG
	NSLog(@"Loading: %@", sRequest);
#endif
	
	if (aPost)
    {
        
        if([aPost objectForKey:@"Image"]  && ![[aPost objectForKey:@"Image"] isKindOfClass:[NSString class]])
        {
            NSData *imageData = [aPost objectForKey:@"Image"];
            NSMutableDictionary *newApost = [[NSMutableDictionary alloc] initWithDictionary:aPost];
            [newApost removeObjectForKey:@"Image"];
            [manager POST:sRequest parameters:newApost constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //do not put image inside parameters dictionary as I did, but append it!
                [formData appendPartWithFileData:imageData name:@"Image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
            } success:oSuccessBlock failure:oFailBlock];
        }
        else
         
        [manager POST:sRequest parameters:aPost success:oSuccessBlock failure:oFailBlock];
            //[manager POST:sRequest parameters:aPostID success:oSuccessBlock failure:oFailBlock];
    }
	else
		[manager GET:sRequest parameters:nil success:oSuccessBlock failure:oFailBlock];
}

-(void)sendRequestWithNSURLConnection:(NSString *)sServiceID Post:(NSDictionary*)aPost
{
    DLog(@"sendRequestWithNSURLConnection sendRequestWithNSURLConnection");
    //NSString *sRequest = [WS_SERVER_URL stringByAppendingFormat:@"%@/?%@", sServiceID, [self GetDefaultPostPayload]];
    NSString *sRequest = [WS_SERVER_URL stringByAppendingFormat:@"%@", sServiceID];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:aPost options:0 error:&error];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    
    [urlRequest setURL:[NSURL URLWithString:sRequest]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
}

@end
