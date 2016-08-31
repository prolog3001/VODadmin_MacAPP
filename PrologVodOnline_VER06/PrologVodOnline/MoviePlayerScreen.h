//
//  MoviePlayerScreen.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 09/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@protocol MoviePlayerScreenDelegate;

@interface MoviePlayerScreen : NSView
{
    IBOutlet AVPlayerView *mPlayerView;
    NSString *mVideoUrl;
    NSURL *mVideoURLAfterExtracting;
}
@property (nonatomic, assign) id <MoviePlayerScreenDelegate> delegate;
@property (nonatomic, assign) BOOL mCanStartMovie;
-(void)playMovie;
-(void)stopMovie;
-(void)pauseMovie;
-(void)setVideoUrl:(NSString *)videoUrl;
@property (strong) AVPlayer *player;
@property (strong) AVPlayerLayer *playerLayer;
@end
@protocol MoviePlayerScreenDelegate <NSObject>
@optional
-(void)movieStartPlaying;
-(void)movieStopPlaying;
@end