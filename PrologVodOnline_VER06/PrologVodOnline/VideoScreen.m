//
//  VideoScreen.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 09/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "VideoScreen.h"
#import "NSImageView+WebCache.h"

@implementation VideoScreen

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    
    // Drawing code here.
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    //mAlreadyinit = NO;
    mOnAirImage.alphaValue = 0.0;
    mMoviePlayerScreen.hidden = YES;
    mMoviePlayerScreen.delegate = self;
}
-(void)canPlay
{
    [mMoviePlayerScreen setVideoUrl:@"https://player.vimeo.com/video/60950367"];
    //[mMoviePlayerScreen play];
}
-(void)stopMovie
{
    
    mMoviePlayerScreen.mCanStartMovie = NO;
    [self stopOnAirAnimation];
    mVimeoPreviewImage.hidden = NO;
    mMoviePlayerScreen.hidden = YES;
    mPlayButton.hidden = NO;
    [mMoviePlayerScreen stopMovie];
    
}
-(void)pauseMovie
{
    [mMoviePlayerScreen pauseMovie];
}
-(void)setPlayButtonAppearence:(BOOL)canWatch
{
    if(canWatch)
    {
        mMoviePlayerScreen.mCanStartMovie = YES;
        //[mPlayButton setBackgroundImage:[UIImage imageNamed:@"PLAY_icon.png"] forState:UIControlStateNormal];
        [mPlayButton setImage:[NSImage imageNamed:@"PLAY_icon.png"]];
    }
    else
    {
        mMoviePlayerScreen.mCanStartMovie = NO;
        //[mPlayButton setBackgroundImage:[UIImage imageNamed:@"Basket_icon"] forState:UIControlStateNormal];
        [mPlayButton setImage:[NSImage imageNamed:@"Basket_icon"]];
    }
}
-(void)setVideoUrl:(NSString *)videoUrl
{
    [mMoviePlayerScreen setVideoUrl:videoUrl];
}
-(void)canPlayMovie
{
    [self stopMovie];
    mMoviePlayerScreen.mCanStartMovie = YES;
    mPlayButton.hidden = YES;
    [self startOnAirAnimation];
    [mMoviePlayerScreen playMovie];
}
-(void)setPreviewImage:(NSString *)imageLink
{
    [mVimeoPreviewImage setImageURL:[NSURL URLWithString:imageLink]];
}
-(void)startOnAirAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setToValue:[NSNumber numberWithFloat:1.0]];
    [animation setDuration:0.3];
    [animation setRepeatCount:HUGE_VALF];
    [animation setAutoreverses:YES];
    [[mOnAirImage layer]addAnimation:animation forKey:@"opacity"];
}
-(void)stopOnAirAnimation
{
    [mOnAirImage.layer removeAnimationForKey:@"opacity"];
    //mOnAirImage.alpha = 0.0;
    mOnAirImage.alphaValue = 0.0;
}
#pragma mark  MoviePlayerScreenDelegate methods
-(void)movieStartPlaying
{
    [self stopOnAirAnimation];
    mMoviePlayerScreen.hidden = NO;
    mVimeoPreviewImage.hidden = YES;
    mPlayButton.hidden = YES;
}
-(void)movieStopPlaying
{
    mVimeoPreviewImage.hidden = NO;
    mMoviePlayerScreen.hidden = YES;
    mPlayButton.hidden = NO;
}
@end
