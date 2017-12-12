//
//  iOSCodeUISketchPanelCell.h
//  iOSCodeGenerate
//
//  Created by mac on 2017/12/12.
//Copyright © 2017年 iOSCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class iOSCodeUISketchPanelCell;

@interface iOSCodeUISketchPanelCell : NSView

@property (nonatomic, copy) NSString *reuseIdentifier;

+ (instancetype)loadNibNamed:(NSString *)nibName;

@end
