//
//  iOSCodeUISketchPanel.h
//  iOSCodeGenerate
//
//  Created by mac on 2017/12/12.
//Copyright © 2017年 iOSCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSCodeUISketchPanelDataSource.h"
#import "iOSCodeUIMSInspectorStackView.h"

@class iOSCodeUISketchPanelCell;

@interface iOSCodeUISketchPanel : NSObject

@property (nonatomic, strong, readonly) NSArray *views;
@property (nonatomic, weak) id <iOSCodeUIMSInspectorStackView> stackView;
@property (nonatomic, weak) id <iOSCodeUISketchPanelDataSource> datasource;

- (instancetype)initWithStackView:(id <iOSCodeUIMSInspectorStackView>)stackView;
- (void)reloadData;
- (iOSCodeUISketchPanelCell *)dequeueReusableCellForReuseIdentifier:(NSString *)identifier;

@end
