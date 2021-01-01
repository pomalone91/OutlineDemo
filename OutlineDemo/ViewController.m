//
//  ViewController.m
//  OutlineDemo
//
//  Created by Paul Malone on 12/19/20.
//  Copyright © 2020 Paul Malone. All rights reserved.
//

#import "ViewController.h"
#import "Node.h"
#import "TreeManager.h"
#import "NSFileManager+AppSupport.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_outlineVIew setDelegate:self];
    [_outlineVIew setDataSource:self];
    
    [self writeFilesInAppSupport];
    
    _treeManager = [[TreeManager alloc] init];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - DataSource implementations
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        if (_treeManager == nil) {
            _treeManager = [[TreeManager alloc] init];
        }
        return _treeManager.nodes.count;
    }
    Node *node = (Node *)item;
    return [node numberOfChildren];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (item == nil) {
        return YES;
    } else {
        return [item numberOfChildren] > 0;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return (item == nil) ? _treeManager.nodes[index] : [(Node *) item childAtIndex:index];
}

#pragma mark - Delegate implementations
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSString *itemText = [[item relativePath] lastPathComponent];
    NSTableCellView *cell = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    cell.textField.stringValue = itemText;
    NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:[item fullPath]]; // Get default icons for file type at path
    cell.imageView.image = img;
    
    return cell;
}

#pragma mark - Directory writer
/**
 Will be called in viewDidLoad to write some dirs and files.
 */
- (void)writeFilesInAppSupport {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *appSupportPath = [fm applicationSupportDirectory];
    
    // Folder names
    NSString *folder1 = [appSupportPath stringByAppendingPathComponent:@"Folder1"];
    NSString *folder2 = [appSupportPath stringByAppendingPathComponent:@"Folder2"];
    NSString *folder3 = [appSupportPath stringByAppendingPathComponent:@"Folder3"];
    
    
    // Write some folders
    [fm createDirectoryAtPath:folder1 withIntermediateDirectories:NO attributes:nil error:nil];
    [fm createDirectoryAtPath:folder2 withIntermediateDirectories:NO attributes:nil error:nil];
    [fm createDirectoryAtPath:folder3 withIntermediateDirectories:NO attributes:nil error:nil];
    
    // File names
    NSString *file1 = [folder1 stringByAppendingPathComponent:@"file1.txt"];
    NSString *file2 = [folder2 stringByAppendingPathComponent:@"file2.txt"];
    NSString *file3 = [folder3 stringByAppendingPathComponent:@"file3.txt"];
    
    // Write some files
    [fm createFileAtPath:file1 contents:nil attributes:nil];
    [fm createFileAtPath:file2 contents:nil attributes:nil];
    [fm createFileAtPath:file3 contents:nil attributes:nil];
}

@end
