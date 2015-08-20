//
//  AppDelegate.h
//  Klickbert
//
//  Created by Philipp Stadler on 20.08.15.
//  Copyright (c) 2015 Philipp Stadler. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ISO8601DateFormatter.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSString *saveDirectory;
    NSInteger lastScreenshotIdx;
    ISO8601DateFormatter *dateFormatter;
}

- (void)screenshotForEventOfType:(NSString *)eventType at:(NSPoint)location;
- (NSBitmapImageRep*)takeScreenshot;

@end

