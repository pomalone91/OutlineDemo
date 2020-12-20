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

- (id)initWithDirectory:(NSString*)rootPath {
    self = [super init];
    // Loop through the contents of the directory and create a new root node for each dir in there
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *appSup = [fm applicationSupportDirectory];
    NSArray *contents = [fm visibleContentsOfDirAtPath:appSup error:nil];
    
    _nodes = [NSMutableArray array];
    
    for (NSString *item in contents) {
//        NSLog(@"%@", item);
        NSString *fullDirPath = [appSup stringByAppendingPathComponent:item];
//        NSString *fullDirPath = [appSup stringByAppendingFormat:@"/%@",item];
        Node *node = [[Node alloc] initWithRootItem:fullDirPath];
        [_nodes addObject:node];
        
    }
    
    // Sort nodes
    NSSortDescriptor *order = [NSSortDescriptor sortDescriptorWithKey:@"relativePath" ascending:YES];
    [_nodes sortUsingDescriptors:[NSArray arrayWithObject:order]];
    return self;
}

- (Node *)getNodeWithRelativePath:(NSString *)path {
    // Get path components off string until /Jurn
    NSArray *components = [NSArray array];
    components = [path pathComponents];
    
    NSString *yearFolder = nil;
    NSString *monthFolder = nil;
    NSString *entry = nil;
    
    // Get the components for each layer
    NSInteger i = components.count - 1;
    while (i > 0 && ![components[i] isEqual:@"Jurn"] ) {
        if ([components[i] length] < 4) {
            monthFolder = components[i];
        } else if ([components[i] hasSuffix:@".md"]) {
            entry = components[i];
        } else {
            yearFolder = components[i];
        }
        i--;
    }
    
    // Find yearFolder in top layer of year folders
    Node *yearNode;
    if (yearFolder != nil) {
        for (Node *n in _nodes) {
            if ([n.relativePath hasSuffix:yearFolder]) {
                yearNode = n;
            }
        }
    }
    
    
    // If year node isn't nil, get the month node
    Node *monthNode;
    if (yearNode != nil && monthFolder != nil) {
        for (Node *n in yearNode.children) {
            if ([n.relativePath hasSuffix:monthFolder]) {
                monthNode = n;
            }
        }
    }
    
    // If month folder exists, see if the entry exists
    Node *entryNode;
    if (monthNode != nil && entry != nil) {
        for (Node *n in monthNode.children) {
            if ([n.relativePath hasSuffix:entry]) {
                entryNode = n;
            }
        }
    }
    
    if (entryNode != nil) {
        return entryNode;
    } else if (monthNode != nil) {
        return monthNode;
    } else {
        return yearNode;
    }
    return nil;
}

@end
