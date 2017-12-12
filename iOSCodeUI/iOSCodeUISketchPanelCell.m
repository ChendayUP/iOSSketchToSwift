//
//  iOSCodeUISketchPanelCell.m
//  iOSCodeGenerate
//
//  Created by mac on 2017/12/12.
//Copyright © 2017年 iOSCode. All rights reserved.
//

#import "iOSCodeUISketchPanelCell.h"

@interface iOSCodeUISketchPanelCell ()

@end

@implementation iOSCodeUISketchPanelCell

- (NSView *)view {
    return self;
}

+ (instancetype)loadNibNamed:(NSString *)nibName {
    NSNib *nib = [[NSNib alloc] initWithNibNamed:nibName bundle:[NSBundle bundleForClass:[self class]]];
    NSArray *views;
    [nib instantiateWithOwner:nil topLevelObjects:&views];

    NSArray *filtered = [views filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[self class]];
    }]];

    return [filtered firstObject];
}

@end
