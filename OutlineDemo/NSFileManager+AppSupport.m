//
//  NSFileManager+NSFileManager_AppSupport.m
//  OutlineDemo
//
//  Created by Paul Malone on 12/19/20.
//  Copyright © 2020 Paul Malone. All rights reserved.
//

#import "NSFileManager+AppSupport.h"

#import <AppKit/AppKit.h>


@implementation NSFileManager (AppSupport)
- (NSString *)applicationSupportDirectory {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSError *error;
    NSString *result = [self findOrCreateDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appendPathComponent:appName error:&error];
    
    if (error) {
        NSLog(@"Unable to find or create Application Support directory: %@\n", error);
    }
    return result;
}

- (NSString *)findOrCreateDirectory:(NSSearchPathDirectory)searchPathDirectory
                           inDomain:(NSSearchPathDomainMask)domainMask
                appendPathComponent:(NSString *)appendComponent
                              error:(NSError **)errorOut {
    // Search for path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory, domainMask, YES);
    if (paths.count == 0) {
        // Return an error
        return nil;
    }
    
    // First path is probably what we want
    NSString *resolvedPath = [paths objectAtIndex:0];
    
    // Append component if it was provided to function
    if (appendComponent) {
        resolvedPath = [resolvedPath stringByAppendingPathComponent:appendComponent];
    }
    
    // Create path if it does not exist
    NSError *error;
    BOOL success = [self createDirectoryAtPath:resolvedPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!success) {
        if (errorOut) {
            *errorOut = error;
        }
        return nil;
    }
    
    // Success...?
    if (errorOut) {
        *errorOut = nil;
    }
//    NSLog(@"%@", resolvedPath);
    return resolvedPath;
}

// Returns a mutable array of the visible contents (no .DS_Stores) of a directory
- (NSMutableArray *)visibleContentsOfDirAtPath:(NSString *)path error:(NSError * _Nullable *)error {
    NSArray *allContents = [self contentsOfDirectoryAtPath:path error:error];
    NSMutableArray *visibleContents = [NSMutableArray array];
    
    for (NSString *item in allContents) {
        if (![item hasPrefix:@"."]) {
            [visibleContents addObject:item];
        }
    }
    return visibleContents;
}

@end
