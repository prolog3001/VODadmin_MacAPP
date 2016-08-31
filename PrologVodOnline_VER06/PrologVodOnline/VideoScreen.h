//
//  VideoScreen.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 09/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MoviePlayerScreen.h"

@interface VideoScreen : NSView <MoviePlayerScreenDelegate>
{
    IBOutlet MoviePlayerScreen *mMoviePlayerScreen;
    IBOutlet NSImageView *mVimeoPreviewImage;
    IBOutlet NSButton *mPlayButton;
    IBOutlet NSImageView *mOnAirImage;
}
-(void)canPlayMovie;
-(void)stopMovie;
-(void)pauseMovie;
-(void)setVideoUrl:(NSString *)videoUrl;
-(void)setPreviewImage:(NSString *)imageLink;
-(void)setPlayButtonAppearence:(BOOL)canWatch;
@end
