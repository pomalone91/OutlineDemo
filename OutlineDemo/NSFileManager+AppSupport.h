//
//  NSFileManager+NSFileManager_AppSupport.h
//  OutlineDemo
//
//  Created by Paul Malone on 12/19/20.
//  Copyright © 2020 Paul Malone. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (AppSupport)
- (NSString *)applicationSupportDirectory;
- (NSMutableArray *)visibleContentsOfDirAtPath:(NSString *) path error:(NSError * _Nullable) error;
@end

NS_ASSUME_NONNULL_END
