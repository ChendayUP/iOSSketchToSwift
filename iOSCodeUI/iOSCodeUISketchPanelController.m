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
#import "SObject.h"
#import "SImageObject.h"
#import "SUserPhotoObject.h"
#import "SLabelObject.h"
#import "SButtonObject.h"
#import "STextFieldObject.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0);

@interface iOSCodeUISketchPanelController ()

@property (nonatomic, strong) id <iOSCodeUIMSInspectorStackView> stackView; // MSInspectorStackView
@property (nonatomic, strong) id <iOSCodeUIMSDocument> document;
@property (nonatomic, strong) iOSCodeUISketchPanel *panel;
@property (nonatomic, copy) NSArray *selection;
//@property (nonatomic, copy) NSDictionary<NSString*,NSString*> *colorDic;
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
    [self CodeGenerate:self.selection];
    self.panel.stackView = [(NSObject *)_document valueForKeyPath:@"inspectorController.currentController.stackView"];
    [self.panel reloadData];
}

-(void)CodeGenerate:(NSArray *)layers {
    NSMutableArray<SObject*> *objects = [[NSMutableArray alloc]init];
    for (id layer in layers) {
        SObject *model;
        NSString *text;
        id copyLayer = layer;
        NSString *classname = [copyLayer className];
        if ([classname isEqual:@"MSSymbolInstance"]) {
            text = [self symbolOverriderText:copyLayer];
            copyLayer = [layer valueForKeyPath:@"symbolMaster"];
        }
        NSString *name = [copyLayer valueForKeyPath:@"nodeName"];
        if ([classname isEqual:@"MSTextLayer"]) {
            model = [self LabelCode:copyLayer];
        } else if ([name hasSuffix:@"Image"]){
            model = [self ImageCode:copyLayer];
        }else if ([name hasSuffix:@"Button"]){
            model = [self ButtonCode:copyLayer];
        } else if ([name hasSuffix:@"TextField"]){
            model = [self TextField:copyLayer];
        } else {
            NSLog(@"无法识别的控件: %@",name);
        }
        
        if (model != nil) {
            if (text != nil) model.text = text;
            [objects addObject:model];
        }
    }
    
    NSString *lines = @"";
    for (SObject *model in objects) {
        NSString *code = model.code;
        if (code.length > 0) {
            lines = [NSString stringWithFormat:@"%@\n%@", lines ,code];
        }
    }
    
    lines = [self ViewControllerInitCode:objects varString:lines];
    
    NSLog(@"%@", lines);
    NSLog(@"%@", @"完成");
    
}

-(NSString*)ViewControllerInitCode:(NSArray<SObject*>*)objects varString:(NSString*)vars {
    NSString *lines = @"";
    for (SObject *model in objects) {
        NSString *code = model.name;
        if (code.length > 0) {
            lines = [NSString stringWithFormat:@"%@            %@,\n", lines ,code];
        }
    }
    lines = [lines substringToIndex:lines.length - 2];
    lines = [NSString stringWithFormat:@"%@\n", lines];
    
    NSString *initCode1 =@""
    @"import UIKit\n"
    @"import SnapKit\n"
    @"class <#ViewController#>: BaseViewController {\n"
    @"\n"
    @"    let aView = ScrollContentView()\n"
    @"    override func loadView() { view = aView }\n"
    @"\n"
    @"    override func viewDidLoad() {\n"
    @"        super.viewDidLoad()\n"
    @"        title = <#title#>\n"
    @"        SetupUI()\n"
    @"    }\n"
    @"\n"
    @"    func SetupUI() {\n"
    @"\n"
    @"        aView.contentView.sv(\n";
    
    NSString *initCode2 =@""
    @"        )\n"
    @"\n"
    @"        aView.layout(\n"
    @"\n"
    @"        )\n"
    @"    }\n";
    
    NSString *initCode3 =@"}\n";
    
    return [NSString stringWithFormat:@"%@%@%@%@%@",initCode1,lines,initCode2,vars,initCode3];
}

-(NSString*)TableViewCellInitCode {
    return @"";
}

-(NSString*)symbolOverriderText:(id)layer {
    id tdocument = self.document;
    id documentData = [tdocument valueForKeyPath:@"documentData"];
    NSDictionary *overs = [layer valueForKeyPath:@"overrides"];
    for (NSString *obID in overs.allKeys) {
        id sublayer;
        do {
            _Pragma("clang diagnostic push")
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
            SEL method = NSSelectorFromString(@"layerWithID:");
            sublayer = [documentData performSelector:method withObject:obID];
            _Pragma("clang diagnostic pop")
        } while (0);
//        SuppressPerformSelectorLeakWarning(
//           SEL method = NSSelectorFromString(@"layerWithID");
//           sublayer = [documentData performSelector:method withObject:obID];
//        );
        if ([[sublayer className] isEqual:@"MSTextLayer"]) {
            return overs[obID];
        }
    }
    return nil;
}

-(SObject*)TextField:(id)layer {
    NSString *classname = [layer className];
    if ([classname isEqual:@"MSLayerGroup"] || [classname isEqual:@"MSSymbolMaster"]) {
        STextFieldObject *model = [[STextFieldObject alloc] initWithLayer:layer];
        return model;
    }
    return nil;
}

- (SButtonObject*)ButtonCode:(id)layer {
    NSString *classname = [layer className];
    if ([classname isEqual:@"MSLayerGroup"]) {
        SButtonObject *model = [[SButtonObject alloc] initWithLayer:layer];
        return model;
    }
    return nil;
}

-(SObject*)ImageCode:(id)layer {
    NSString *classname = [layer className];
    if ([classname isEqual:@"MSLayerGroup"]) {
        SImageObject *model = [[SImageObject alloc] initWithLayer:layer];
        return model;
    } else if ([classname isEqual:@"MSShapeGroup"]) {
        id ovalShape = [[layer valueForKeyPath:@"layers"] firstObject];

        if ([[ovalShape className] isEqual:@"MSOvalShape"]) {
            SUserPhotoObject *model = [[SUserPhotoObject alloc] initWithLayer:layer];
            return model;
        } else {
            SImageObject *model = [[SImageObject alloc] initWithLayer:layer];
            return model;
        }
    }
    return nil;
}

-(SObject*)LabelCode:(id)layer {
    return [[SLabelObject alloc]initWithLayer:layer];
}

//- (NSString*)colorString:(id)color {
//    NSString *hexColor = [self hexStringFromColor:color];
//    // 可以遍历处所有的颜色
//    NSString *string = self.colorDic[hexColor];
//    if (string == nil) {
//        return [NSString stringWithFormat: @"UIColor(hex: %@)", hexColor];
//    } else {
//        return string;
//    }
//}
//
//- (NSString*)textAlignmentString:(id)number {
//    NSInteger value = [number integerValue];
//    // 对齐属性对应的值 0 左对齐 2 居中 1 右对齐 3 两边对齐
//    if (value == 0) {
//        return @".left";
//    } else if (value == 2) {
//        return @".center";
//    } else if (value == 1) {
//        return @".right";
//    } else {
//        return @".left";
//    }
//}
//
//-(NSString*)boldString:(NSString*)fontName {
//    NSArray *array = [fontName componentsSeparatedByString:@"-"];
//    if (array.count == 2) {
//        if ([array[1] isEqual:@"Semibold"]) {
//            return @"true";
//        }
//    }
//    return @"false";
//}



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
    return 1;//self.selection.count;    // Using self.selection as number of rows in the panel
}

- (iOSCodeUISketchPanelCell *)iOSCodeUISketchPanel:(iOSCodeUISketchPanel *)panel itemForRowAtIndex:(NSUInteger)index {
    iOSCodeUISketchPanelCellDefault *cell = (iOSCodeUISketchPanelCellDefault *)[panel dequeueReusableCellForReuseIdentifier:@"cell"];
    if ( ! cell) {
        cell = [iOSCodeUISketchPanelCellDefault loadNibNamed:@"iOSCodeUISketchPanelCellDefault"];
        cell.reuseIdentifier = @"cell";
    }

//    id layer = self.selection[index];
//    NSString *name = [layer valueForKeyPath:@"nodeName"];
//    NSString *objectID = [layer valueForKeyPath:@"objectID"];
//    NSString *hexColor = [self hexStringFromColor:[layer valueForKeyPath:@"textColor"]];
    
    //    cell.titleLabel.stringValue = [layer name];
    //    id mColor = [layer valueForKeyPath:@"textColor"];
//    cell.titleLabel.stringValue = [NSString stringWithFormat:@"%@-%@",[layer valueForKeyPath:@"fontSize"],hexColor];
//    cell.imageView.image = [layer valueForKeyPath:@"previewImages.LayerListPreviewUnfocusedImage"];

    return cell;
}

//- (NSString *)hexStringFromColor:(id)color {
//
//    NSNumber *r = [color valueForKeyPath:@"red"];
//    NSNumber *g = [color valueForKeyPath:@"green"];
//    NSNumber *b = [color valueForKeyPath:@"blue"];
//    NSNumber *a = [color valueForKeyPath:@"alpha"];
//    return [NSString stringWithFormat:@"0x%02lX%02lX%02lX%02lX",
//            lroundf([r floatValue]  * 255),
//            lroundf([g floatValue] * 255),
//            lroundf([b floatValue] * 255),
//            lroundf([a floatValue] * 255)];
//}
//
//- (NSDictionary*)colorDic {
//    if (!_colorDic) {
//        _colorDic = @{@"0x666666" : @"UIColor.wordLightBlack",
//                      @"0x333333": @"UIColor.wordBlack"
//                      };
//    }
//    return _colorDic;
//
//}

@end
