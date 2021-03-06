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
    [self CodeGenerate:self.selection Type:0];
    self.panel.stackView = [(NSObject *)_document valueForKeyPath:@"inspectorController.currentController.stackView"];
    [self.panel reloadData];
}

- (void)viewControllerCodeGenerate:(NSArray *)selection {
    self.selection = [selection valueForKey:@"layers"];         // To get NSArray from MSLayersArray
    [self CodeGenerate:self.selection Type: 1];
    self.panel.stackView = [(NSObject *)_document valueForKeyPath:@"inspectorController.currentController.stackView"];
    [self.panel reloadData];
}

- (void)viewCodeGenerate:(NSArray *)selection {
    self.selection = [selection valueForKey:@"layers"];         // To get NSArray from MSLayersArray
    [self CodeGenerate:self.selection Type: 2];
    self.panel.stackView = [(NSObject *)_document valueForKeyPath:@"inspectorController.currentController.stackView"];
    [self.panel reloadData];
}

- (void)tableViewCellCodeGenerate:(NSArray *)selection {
    self.selection = [selection valueForKey:@"layers"];         // To get NSArray from MSLayersArray
    [self CodeGenerate:self.selection Type: 3];
    self.panel.stackView = [(NSObject *)_document valueForKeyPath:@"inspectorController.currentController.stackView"];
    [self.panel reloadData];
}

-(void)CodeGenerate:(NSArray *)layers Type: (NSInteger)typeInt {
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
    switch (typeInt) {
            
        case 0: // 单个控件
            lines = lines;
            break;
        case 1: // vc
            lines = [self ViewControllerInitCode:objects varString:lines];
            break;
        case 2: // view
            lines = [self ViewInitCode:objects varString:lines];
            break;
        case 3: // tableviewcell
            lines = [self TableViewCellInitCode:objects varString:lines];
            break;
        default:
            break;
    }
    
    NSPasteboard *past = [NSPasteboard generalPasteboard];
    [past clearContents];
    [past writeObjects:@[lines]];
    
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

-(NSString*)ViewInitCode:(NSArray<SObject*>*)objects varString:(NSString*)vars {
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
    @"class <#UIView#>: UIView {\n"
    @"\n"
    @"    convenience init() {\n"
    @"        self.init(frame: .zero)\n"
    @"    }\n"
    @"\n"
    @"    override init(frame: CGRect) {\n"
    @"        super.init(frame: frame)\n"
    @"        SetupUI()\n"
    @"    }\n"
    @"    required init?(coder aDecoder: NSCoder) {\n"
    @"        super.init(coder: aDecoder)\n"
    @"        SetupUI()\n"
    @"    }\n"
    @"\n"
    @"    func SetupUI() {\n"
    @"        backgroundColor = UIColor.backgroudGray\n"
    @"        sv(\n";
    
    NSString *initCode2 =@""
    @"        )\n"
    @"\n"
    @"        layout(\n"
    @"\n"
    @"        )\n"
    @"    }\n";
    
    NSString *initCode3 =@"}\n";
    
    return [NSString stringWithFormat:@"%@%@%@%@%@",initCode1,lines,initCode2,vars,initCode3];
}

-(NSString*)TableViewCellInitCode:(NSArray<SObject*>*)objects varString:(NSString*)vars {
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
    @"class <#TableViewCell#>: UITableViewCell, Cell {\n"
    @"\n"
    @"    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {\n"
    @"        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)\n"
    @"        SetupUI()\n"
    @"    }\n"
    @"    required init?(coder aDecoder: NSCoder) {\n"
    @"        super.init(coder: aDecoder)\n"
    @"        SetupUI()\n"
    @"    }\n"
    @"\n"
    @"    func configure(row: Row) {\n"
    @"        guard let model = row.dataModel as? <#ModelType#> else { return }\n"
    @"\n"
    @"    }\n"
    @"    func SetupUI() {\n"
    @"        selectionStyle = .none\n"
    @"        sv(\n";
    
    NSString *initCode2 =@""
    @"        )\n"
    @"\n"
    @"        layout(\n"
    @"\n"
    @"        )\n"
    @"    }\n";
    
    NSString *initCode3 =@"}\n";
    
    return [NSString stringWithFormat:@"%@%@%@%@%@",initCode1,lines,initCode2,vars,initCode3];
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
    if ([classname isEqual:@"MSLayerGroup"] || [classname isEqual:@"MSSymbolMaster"]) {
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

@end
