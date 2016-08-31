//
//  MoviePlayerScreen.m
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 09/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import "MoviePlayerScreen.h"
#import "YTVimeoExtractor.h"

@implementation MoviePlayerScreen

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(void)playMovie{
    
    /*
    NSURL* videoURL = [NSURL URLWithString:@"https://16-lvl3-pdl.vimeocdn.com/01/2190/2/60950367/148883665.mp4?expires=1470765718&token=0c9280ffb0889fbe15c2c"];
    mPlayerView.player = [AVPlayer playerWithURL:videoURL];
    [mPlayerView.player play];
    return;
     */
     [self extractVideoURL];
    return;
    // Create the AVPlayer, add rate and status observers
    self.player = [[AVPlayer alloc] init];
    //[self addObserver:self forKeyPath:@"player.rate" options:NSKeyValueObservingOptionNew context:AVSPPlayerRateContext];
    //[self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew context:AVSPPlayerItemStatusContext];
    //[self addObserver:self forKeyPath:@"status" options:0 context:&AVSPPlayerItemStatusContext];
    
    // Create an asset with our URL, asychronously load its tracks and whether it's playable or protected.
    // When that loading is complete, configure a player to play the asset.
    
    AVURLAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:@"https://16-lvl3-pdl.vimeocdn.com/01/2190/2/60950367/148883665.mp4?expires=1470754347&token=0b06efd10e3ac6cffdcd1"]];
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"hasProtectedContent", @"tracks"];
    [asset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:^(void) {
        
        // The asset invokes its completion handler on an arbitrary queue when loading is complete.
        // Because we want to access our AVPlayer in our ensuing set-up, we must dispatch our handler to the main queue.
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [self setUpPlaybackOfAsset:asset withKeys:assetKeysToLoadAndTest];
            [self.player play];
            
        });
        
    }];
}
-(void)pauseMovie
{
    [mPlayerView.player pause];
}
- (void)setUpPlaybackOfAsset:(AVAsset *)asset withKeys:(NSArray *)keys
{
    // This method is called when the AVAsset for our URL has completing the loading of the values of the specified array of keys.
    // We set up playback of the asset here.
    
    // First test whether the values of each of the keys we need have been successfully loaded.
    for (NSString *key in keys)
    {
        NSError *error = nil;
        
        if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed)
        {
            //[self stopLoadingAnimationAndHandleError:error];
            return;
        }
    }
    
    if (![asset isPlayable] || [asset hasProtectedContent])
    {
        // We can't play this asset. Show the "Unplayable Asset" label.
        //[self stopLoadingAnimationAndHandleError:nil];
        //self.unplayableLabel.hidden = NO;
        return;
    }
    
    // We can play this asset.
    // Set up an AVPlayerLayer according to whether the asset contains video.
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0)
    {
        // Create an AVPlayerLayer and add it to the player view if there is video, but hide it until it's ready for display
        AVPlayerLayer *newPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        newPlayerLayer.frame = self.layer.bounds;
        newPlayerLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
        newPlayerLayer.hidden = YES;
        [self.layer addSublayer:newPlayerLayer];
        self.playerLayer = newPlayerLayer;
        //[self addObserver:self forKeyPath:@"playerLayer.readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVSPPlayerLayerReadyForDisplay];
    }
    else
    {
        // This asset has no video tracks. Show the "No Video" label.
        //[self stopLoadingAnimationAndHandleError:nil];
        //self.noVideoLabel.hidden = NO;
    }
    
    // Create a new AVPlayerItem and make it our player's current item.
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    // If needed, configure player item here (example: adding outputs, setting text style rules, selecting media options) before associating it with a player
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    // Use a weak self variable to avoid a retain cycle in the block
    /*
    __weak AVSPDocument *weakSelf = self;
    [self setTimeObserverToken:[[self player] addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakSelf.timeSlider.doubleValue = CMTimeGetSeconds(time);
    }]];
     */
    
}
-(void)setVideoUrl:(NSString *)videoUrl
{
    mVideoUrl = videoUrl;
    NSLog(@"videoURl = %@",videoUrl);
    
}
-(void)extractVideoURL
{
    //@"http://vimeo.com/58600663"
    //@"https://player.vimeo.com/video/135231784"
    [YTVimeoExtractor fetchVideoURLFromURL:mVideoUrl
                                   quality:YTVimeoVideoQualityBestAvailable
                         completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
                             if (error) {
                                 // handle error
                                 NSLog(@"Error Error : %@", [error localizedDescription]);
                                 
                                 
                             } else {
                                 // run player
                                 NSLog(@"Video URL: %@", [videoURL absoluteString]);
                                 mVideoURLAfterExtracting = videoURL ;
                                 dispatch_async(dispatch_get_main_queue(), ^{[self finishExtractingVideo];});
                                 
                             }
                         }];
}
-(void)finishExtractingVideo
{
    
    if(!_mCanStartMovie)
        return;
    //[self PrepareVideo];
    /*
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(movieFinishedCallback)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:moviePlayerController.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:moviePlayerController.moviePlayer];
     
    [moviePlayerController.moviePlayer play];
     */
    @try{
        [mPlayerView.player removeObserver:self forKeyPath:@"status"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
    NSURL* videoURL = mVideoURLAfterExtracting;
    mPlayerView.player = [AVPlayer playerWithURL:videoURL];
    [mPlayerView.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    mPlayerView.showsFullScreenToggleButton = YES;
    [mPlayerView.player play];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == mPlayerView.player && [keyPath isEqualToString:@"status"]) {
        if (mPlayerView.player.status == AVPlayerStatusReadyToPlay) {
            //playButton.enabled = YES;
            if(_delegate && [_delegate respondsToSelector:@selector(movieStartPlaying)])
                [_delegate movieStartPlaying];
        } else if (mPlayerView.player.status == AVPlayerStatusFailed) {
            // something went wrong. player.error should contain some information
        }
    }
}
-(void)stopMovie
{
    @try{
        [mPlayerView.player removeObserver:self forKeyPath:@"status"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
    //[mPlayerView.player removeObserver:self forKeyPath:@"status"];
    if(_delegate && [_delegate respondsToSelector:@selector(movieStopPlaying)])
        [_delegate movieStopPlaying];
    [mPlayerView.player pause];
}
@end
