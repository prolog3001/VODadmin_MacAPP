//
//  TextManager.m
//  VODUniversal
//
//  Created by Gilad Kedmi on 31/12/2015.
//  Copyright © 2015 Gphone. All rights reserved.
//

#import "TextManager.h"

static  TextManager* instance = nil;

@implementation TextManager

+ (id)textmanager
{
    if (!instance)
    {
        instance = [[TextManager alloc] init];
    }
    return  instance;
}
-(id)init
{
    NSString *appDetailsFile = [[NSBundle mainBundle] pathForResource:@"Texts" ofType:@"plist"];
    NSDictionary *dic  = [NSDictionary dictionaryWithContentsOfFile:appDetailsFile];
    [self setTexts:dic];
    return self;
}
-(void)setTexts:(NSDictionary *)dic
{
    _getThisApp = [dic objectForKey:@"get this app"];
    _wouldLikeGetThisApp =  [dic objectForKey:@"would like get this app"];
    _moreAppsTitle =  [dic objectForKey:@"more apps title"];
    _decideToUpgrade =  [dic objectForKey:@"decide to upgrade"];
    _upgradeNow =  [dic objectForKey:@"upgrade now"];
    _notNow =  [dic objectForKey:@"not now"];
    _restore =  [dic objectForKey:@"restore"];
    _selectALesson =  [dic objectForKey:@"select a lesson"];
    _clickLesson =  [dic objectForKey:@"click lesson"];
    _itemNotAvailable =  [dic objectForKey:@"item not available"];
    _downloadingCourse =  [dic objectForKey:@"downloading course"];
    _noInternet =  [dic objectForKey:@"no internet"];
    _noInternetOK =  [dic objectForKey:@"no internet ok"];
    _upgradeFor =  [dic objectForKey:@"would like to upgarde for"];
    //
}
@end
