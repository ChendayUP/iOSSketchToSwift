//
//  iOSCodeUISketchPanelController.m
//  iOSCodeGenerate
//
//  Created by mac on 2017/12/12.
//Copyright © 2017年 iOSCode. All rights reserved.
//

#import "iOSCodeUISketchPanelController.h"
#import "iOSCodeUISketchPanelCell.h"
#import "iOSCodeUISketchPanelCellHeader.h"
#import "iOSCodeUISketchPanelCellDefault.h"
#import "iOSCodeUISketchPanel.h"
#import "iOSCodeUISketchPanelDataSource.h"


@interface iOSCodeUISketchPanelController ()

@property (nonatomic, strong) id <iOSCodeUIMSInspectorStackView> stackView; // MSInspectorStackView
@property (nonatomic, strong) id <iOSCodeUIMSDocument> document;
@property (nonatomic, strong) iOSCodeUISketchPanel *panel;
@property (nonatomic, copy) NSArray *selection;

@end

@implementation iOSCodeUISketchPanelController

- (instancetype)initWithDocument:(id <iOSCodeUIMSDocument>)document {
    if (self = [super init]) {
        _document = document;
        _panel = [[iOSCodeUISketchPanel alloc] initWithStackView:nil];
        _panel.datasource = self;
    }
    return self;
}

- (void)selectionDidChange:(NSArray *)selection {
    self.selection = [selection valueForKey:@"layers"];         // To get NSArray from MSLayersArray

    self.panel.stackView = [(NSObject *)_document valueForKeyPath:@"inspectorController.currentController.stackView"];
    [self.panel reloadData];
}

#pragma mark - iOSCodeUISketchPanelDataSource

- (iOSCodeUISketchPanelCell *)headerForiOSCodeUISketchPanel:(iOSCodeUISketchPanel *)panel {
    iOSCodeUISketchPanelCellHeader *cell = (iOSCodeUISketchPanelCellHeader *)[panel dequeueReusableCellForReuseIdentifier:@"header"];
    if ( ! cell) {
        cell = [iOSCodeUISketchPanelCellHeader loadNibNamed:@"iOSCodeUISketchPanelCellHeader"];
        cell.reuseIdentifier = @"header";
    }
    cell.titleLabel.stringValue = @"iOSCodeUI";
    return cell;
}

- (NSUInteger)numberOfRowsForiOSCodeUISketchPanel:(iOSCodeUISketchPanel *)panel {
    return self.selection.count;    // Using self.selection as number of rows in the panel
}

- (iOSCodeUISketchPanelCell *)iOSCodeUISketchPanel:(iOSCodeUISketchPanel *)panel itemForRowAtIndex:(NSUInteger)index {
    iOSCodeUISketchPanelCellDefault *cell = (iOSCodeUISketchPanelCellDefault *)[panel dequeueReusableCellForReuseIdentifier:@"cell"];
    if ( ! cell) {
        cell = [iOSCodeUISketchPanelCellDefault loadNibNamed:@"iOSCodeUISketchPanelCellDefault"];
        cell.reuseIdentifier = @"cell";
    }

    id layer = self.selection[index];
    //    cell.titleLabel.stringValue = [layer name];
    //    id mColor = [layer valueForKeyPath:@"textColor"];
    NSString *hexColor = [self hexStringFromColor:[layer valueForKeyPath:@"textColor"]];
    cell.titleLabel.stringValue = [NSString stringWithFormat:@"%@-%@",[layer valueForKeyPath:@"fontSize"],hexColor];
    cell.imageView.image = [layer valueForKeyPath:@"previewImages.LayerListPreviewUnfocusedImage"];

    return cell;
}

- (NSString *)hexStringFromColor:(id)color {
    
    NSNumber *r = [color valueForKeyPath:@"red"];
    NSNumber *g = [color valueForKeyPath:@"green"];
    NSNumber *b = [color valueForKeyPath:@"blue"];
    NSNumber *a = [color valueForKeyPath:@"alpha"];
    return [NSString stringWithFormat:@"0x%02lX%02lX%02lX%02lX",
            lroundf([r floatValue]  * 255),
            lroundf([g floatValue] * 255),
            lroundf([b floatValue] * 255),
            lroundf([a floatValue] * 255)];
}

@end
