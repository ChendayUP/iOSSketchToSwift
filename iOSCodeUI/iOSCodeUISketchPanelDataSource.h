//
//  iOSCodeUISketchPanelDataSource.h
//  iOSCodeGenerate
//
//  Created by mac on 2017/12/12.
//Copyright © 2017年 iOSCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@class iOSCodeUISketchPanel;
@class iOSCodeUISketchPanelCell;

@protocol iOSCodeUISketchPanelDataSource <NSObject>

- (NSUInteger)numberOfRowsForiOSCodeUISketchPanel:(iOSCodeUISketchPanel *)panel;
- (iOSCodeUISketchPanelCell *)iOSCodeUISketchPanel:(iOSCodeUISketchPanel *)panel itemForRowAtIndex:(NSUInteger)index;
- (iOSCodeUISketchPanelCell *)headerForiOSCodeUISketchPanel:(iOSCodeUISketchPanel *)panel;

@end
