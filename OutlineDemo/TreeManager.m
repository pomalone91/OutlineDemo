//
//  TreeManager.m
//  OutlineDemo
//
//  Created by Paul Malone on 12/19/20.
//  Copyright © 2020 Paul Malone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeManager.h"
#import "NSFileManager+AppSupport.h"

@implementation TreeManager

- (id)init {
    self = [super init];
    // Loop through the contents of the directory and create a new root node for each dir in there
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *appSup = [fm applicationSupportDirectory];
    NSArray *contents = [fm visibleContentsOfDirAtPath:appSup error:nil];
    
    _nodes = [NSMutableArray array];
    
    for (NSString *item in contents) {
        NSString *fullDirPath = [appSup stringByAppendingPathComponent:item];
        Node *node = [[Node alloc] initWithPath:fullDirPath parent:nil];
        [_nodes addObject:node];
        
    }
    
    // Sort nodes
    NSSortDescriptor *order = [NSSortDescriptor sortDescriptorWithKey:@"relativePath" ascending:YES];
    [_nodes sortUsingDescriptors:[NSArray arrayWithObject:order]];
    return self;
}

- (Node *)getNodeWithPath:(NSString *)path {
    Node *node;
    for (Node *child in _nodes) {
        node = [self checkNode:child ForPath:path];
        if (node != nil)
            break;
    }
    return node;
}

- (Node *)checkNode:(Node *)node ForPath:(NSString *)path {
    if ([[node fullPath] isEqualToString:path]) {
        return node;
    } else if ([node numberOfChildren] > 0) {
        for (Node *child in [node children]) {
            node = [self checkNode:child ForPath:path];
            if (node != nil) {
                return node;
            }
        }
    }
    return nil;
}

@end
