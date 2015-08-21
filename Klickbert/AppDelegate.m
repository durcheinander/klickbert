//
//  AppDelegate.m
//  Klickbert
//
//  Created by Philipp Stadler on 20.08.15.
//  Copyright (c) 2015 Philipp Stadler. All rights reserved.
//

#import "AppDelegate.h"

const NSTimeInterval minScreenshotTimeDifference = 30.0;

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    lastScreenshotIdx = 0;
    saveDirectory = nil;
    
    dateFormatter = [[ISO8601DateFormatter alloc] init];
    dateFormatter.includeTime = YES;
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setCanCreateDirectories:YES];
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if(result == NSFileHandlingPanelOKButton) {
            NSURL *url = [panel URL];
            saveDirectory = [url path];
        } else {
            [NSApp terminate:nil];
        }
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
        
        NSString *meta = [event characters];
        
        [self screenshotForEventOfType:@"KeyDown" withMetadata:meta];
    }];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:^(NSEvent *event) {
        
        NSPoint location = [event locationInWindow];
        NSString *meta = [NSString stringWithFormat:@"%fx %fy", location.x, location.y];
        
        [self screenshotForEventOfType:@"LeftClick"
                          withMetadata:meta];
    }];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSStatusBarButton *statusButton = statusItem.button;
    statusButton.title = @"Klickbert";
    statusButton.target = self;
    statusButton.action = @selector(handleStatusItemAction:);
    [statusButton sendActionOn:(NSLeftMouseDownMask|NSRightMouseDownMask|NSLeftMouseUpMask|NSRightMouseUpMask)];
}

- (void)handleStatusItemAction:(id)sender {
    
    const NSUInteger buttonMask = [NSEvent pressedMouseButtons];
    BOOL primaryDown = ((buttonMask & (1 << 0)) != 0);
    BOOL secondaryDown = ((buttonMask & (1 << 1)) != 0);
    // Treat a control-click as a secondary click
    if (primaryDown && ([NSEvent modifierFlags] & NSControlKeyMask)) {
        primaryDown = NO;
        secondaryDown = YES;
    }
    
    if (primaryDown) {
        if (statusItemMenu == nil) {
            NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
            [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
            statusItemMenu = menu;
        }
        [statusItem popUpStatusItemMenu:statusItemMenu];
    }
    
}

- (void)screenshotForEventOfType:(NSString *)eventType withMetadata:(NSString *)meta {
    
    NSDate *now = [NSDate date];
    NSTimeInterval lastScreenshotTimeDiff = [now timeIntervalSinceDate:lastScreenDate];
    
    if(lastScreenshotTimeDiff > minScreenshotTimeDifference || !lastScreenDate) {
            ++lastScreenshotIdx;
        
        NSString *formattedNow = [dateFormatter stringFromDate:now];
        
        NSString *screenshotFilename = [NSString stringWithFormat:@"%@ -- %@ -- %@ -- %ld.png", formattedNow, eventType, meta, (long)lastScreenshotIdx];
        screenshotFilename = [screenshotFilename stringByReplacingOccurrencesOfString:@":" withString:@";"];
        
        NSString *screenshotAbsPath = [NSString stringWithFormat:@"%@/%@", saveDirectory, screenshotFilename];
        
        NSBitmapImageRep *screenshot = [self takeScreenshot];
        NSData *data = [screenshot representationUsingType:NSPNGFileType properties:nil];
        [data writeToFile:screenshotAbsPath atomically:NO];
        
        lastScreenDate = now;
    }
}

/**
 * Creates an NSBitmapImageRep from the content of the current screen
 * @see http://stackoverflow.com/questions/1685854/screen-capture-using-objective-c-for-mac
 */
- (NSBitmapImageRep*)takeScreenshot {
    // This just invokes the API as you would if you wanted to grab a screen shot. The equivalent using the UI would be to
    // enable all windows, turn off "Fit Image Tightly", and then select all windows in the list.
    CGImageRef screenShot = CGWindowListCreateImage(CGRectInfinite, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:screenShot];
    
    return bitmapRep;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}

@end
