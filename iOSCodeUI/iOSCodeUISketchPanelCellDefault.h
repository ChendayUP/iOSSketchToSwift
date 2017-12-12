//
//  iOSCodeUISketchPanelCellDefault.h
//  iOSCodeGenerate
//
//  Created by mac on 2017/12/12.
//Copyright © 2017年 iOSCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iOSCodeUISketchPanelCell.h"

@interface iOSCodeUISketchPanelCellDefault : iOSCodeUISketchPanelCell

@property (nonatomic, weak) IBOutlet NSTextField *titleLabel;
@property (nonatomic, weak) IBOutlet NSImageView *imageView;

@end
