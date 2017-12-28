//
//  iOSCodeUISketchPanelController.h
//  iOSCodeGenerate
//
//  Created by mac on 2017/12/12.
//Copyright © 2017年 iOSCode. All rights reserved.
//

@import Cocoa;
#import <Foundation/Foundation.h>
#import "iOSCodeUIMSDocument.h"
#import "iOSCodeUIMSInspectorStackView.h"
#import "iOSCodeUISketchPanelDataSource.h"
@class iOSCodeUISketchPanel;

@interface iOSCodeUISketchPanelController : NSObject <iOSCodeUISketchPanelDataSource>

@property (nonatomic, strong, readonly) id <iOSCodeUIMSInspectorStackView> stackView; // MSInspectorStackView
@property (nonatomic, strong, readonly) id <iOSCodeUIMSDocument> document;
@property (nonatomic, strong, readonly) iOSCodeUISketchPanel *panel;

- (instancetype)initWithDocument:(id <iOSCodeUIMSDocument>)document;
- (void)selectionDidChange:(NSArray *)selection;
- (void)viewCodeGenerate:(NSArray *)selection ;
- (void)tableViewCellCodeGenerate:(NSArray *)selection ;

@end
