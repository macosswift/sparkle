//
//  SUApplicationInfo.m
//  Sparkle
//
//  Created by Mayur Pawashe on 2/28/16.
//  Copyright © 2016 Sparkle Project. All rights reserved.
//

#import "SUApplicationInfo.h"
#import "SUBundleIcon.h"
#import "SUHost.h"

@implementation SUApplicationInfo

+ (BOOL)isBackgroundApplication:(NSApplication *)application
{
    return (application.activationPolicy == NSApplicationActivationPolicyAccessory);
}

+ (NSImage *)bestIconForHost:(SUHost *)host
{
    NSImage *icon = nil;
    if (@available(macOS 26.0, *)) {
        if ([[host objectForInfoDictionaryKey:@"CFBundlePackageType"] isEqual:@"APPL"]) {
            icon = [[NSWorkspace sharedWorkspace] iconForFile:host.bundlePath];
        }
    }
    if (!icon) {
        NSURL *iconURL = [SUBundleIcon iconURLForHost:host];
        icon = (iconURL == nil) ? nil : [[NSImage alloc] initWithContentsOfURL:iconURL];
    }
    // Use a default icon if none is defined.
    if (!icon) {
        // this asumption may not be correct (eg. even though we're not the main bundle, it could be still be a regular app)
        // but still better than nothing if no icon was included
        BOOL isMainBundle = [host.bundle isEqualTo:[NSBundle mainBundle]];
        
        NSString *fileType = isMainBundle ? (__bridge NSString *)kUTTypeApplication : (__bridge NSString *)kUTTypeBundle;
        icon = [[NSWorkspace sharedWorkspace] iconForFileType:fileType];
    }
    return icon;
}

@end
