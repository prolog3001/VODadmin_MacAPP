//
//  selectLessonScreen.h
//  PrologVodOnline
//
//  Created by Gilad Kedmi on 10/08/2016.
//  Copyright © 2016 Gphone. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol selectLessonScreenDelegate;

@interface selectLessonScreen : NSView
{
    IBOutlet NSScrollView *mScrollView;
    IBOutlet NSTextField *mTitle;
    IBOutlet NSTextField *mBottomLabel;
    NSMutableArray *mScrollerItems;
    int mCurrentSelectedLesson;
}
@property (nonatomic, assign) id <selectLessonScreenDelegate> delegate;
-(void)viewWillLayout;
-(void)viewDidAppear;
@end
@protocol selectLessonScreenDelegate <NSObject>
@optional
-(void)lessonSelected:(int)lessonIndex;
-(void)lessonActivated:(int)lessonIndex;
@end