//
//  Node.m
//  OutlineDemo
//
//  Created by Paul Malone on 12/19/20.
//  Copyright © 2020 Paul Malone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"
#import "NSFileManager+AppSupport.h"

@implementation Node

static Node *rootItem = nil;
static NSMutableArray *leafNode = nil;

- (instancetype)init {
    self = [super init];
    if (self) {
        leafNode = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithPath:(NSString *)path parent:(Node *)parentItem {
    self = [super  init];
    if (self) {
        _relativePath = path;
        _parent = parentItem;
        _children = [self setupChildren];
    }
    return self;
}

- (id)initWithRootItem:(NSString *)rootPath {
    self = [super init];
    if (self) {
        rootItem = self;
        _relativePath = rootPath;
        _parent = nil;
        _children = [self setupChildren];
    }
    return self;
}

- (NSMutableArray *)setupChildren {
    if (_children == nil) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *fullPath = [self fullPath];
        BOOL isDir, valid;
        
        // Check if the child is valid and if it is a directory
        valid = [fm fileExistsAtPath:fullPath isDirectory:&isDir];
        if (valid && isDir) {
            NSArray *contents = [fm visibleContentsOfDirAtPath:fullPath error:nil];
            NSUInteger numChildren = 0;
            _children = [[NSMutableArray alloc] initWithCapacity:contents.count];
            for (NSString *item in contents) {
                numChildren++;
                Node *newChild = [[Node alloc] initWithPath:item parent:self];
                [_children addObject:newChild];
            }
        } else {
            _children = leafNode;
        }
    }
    
    // Sort children...
    if (_children != nil) {
        NSSortDescriptor *order = [NSSortDescriptor sortDescriptorWithKey:@"relativePath" ascending:YES];
        [_children sortUsingDescriptors:[NSArray arrayWithObject:order]];
    }
    
    return _children;
}

- (NSArray *)children {
    return _children;
}

- (NSString *)relativePath {
    return _relativePath;
}

- (NSString *)fullPath {
    // If no parent, return own relative path
    if (_parent == nil) {
        return _relativePath;
    }
    
    // Recursively move up heirarchy prepending parent paths
    return [[_parent fullPath] stringByAppendingPathComponent:_relativePath];
}

- (Node *)childAtIndex:(NSInteger)index {
    return [[self children] objectAtIndex:index];
}

- (NSInteger)numberOfChildren {
    return (_children == nil) ? 0 : [[self children] count];
}

@end
