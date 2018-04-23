//
//  SImage.m
//  iOSCodeUI
//
//  Created by mac on 2017/12/12.
//  Copyright © 2017年 iOSCode. All rights reserved.
//

#import "SObject.h"
@interface SObject()

@property (nonatomic, copy) NSDictionary<NSString*,NSString*> *colorDic;

@end



@implementation SObject
@synthesize code;
@synthesize borderWidth;

- (instancetype)initWithLayer:(id)layer
{
    self = [super init];
    if (self) {
        self.fullname = [layer valueForKeyPath:@"nodeName"];
        [self operatName:self.fullname];
        self.classname = [layer className];
        self.text = [layer valueForKeyPath:@"stringValue"];
        self.textAlignment = [self textAlignmentString:[layer valueForKeyPath:@"textAlignment"]];
        self.fontSize = [[layer valueForKeyPath:@"fontSize"] integerValue];
      
        self.isBold = [self boldString:[layer valueForKeyPath:@"fontPostscriptName"]];
        self.width = [[layer valueForKeyPath:@"frame.width"] integerValue];
        self.height = [[layer valueForKeyPath:@"frame.height"] integerValue];
        
        self.color = [self colorString:[layer valueForKeyPath:@"textColor"]];
        id style = [self getStyle:layer];
        if (style != nil) {
            id border = [[style valueForKeyPath:@"borders"] firstObject];
            id fill = [[style valueForKeyPath:@"fills"] firstObject];
            [self setupBorderWidth:[[border valueForKeyPath:@"thickness"] floatValue]];
            self.borderColor = [self colorString:[border valueForKeyPath:@"color"]];
            self.backgroundColor = [self colorString:[fill valueForKeyPath:@"color"]];
        }
    
        id shapeLayer = [self getCorRadiusStyleLayer:layer];
        [self setupRadius:[[shapeLayer valueForKey:@"fixedRadius"] floatValue]];
        
        self.code = @"";
    }
    return self;
}

-(NSString*)baseCode {
    NSString *acode = @"";
    if (self.borderWidth > 0 || self.radius > 0) {
        acode = [NSString stringWithFormat:@"%@        view.layer.masksToBounds = true\n        view.layer.cornerRadius = %.0f\n        view.layer.borderColor = %@\n        view.layer.borderWidth = %.0f\n",acode,self.radius,self.borderColor, self.borderWidth];
    }
    if (self.backgroundColor.length > 0) {
        acode = [NSString stringWithFormat:@"%@        view.backgroundColor = %@\n",acode,self.backgroundColor];
    }
    acode = [NSString stringWithFormat:@"%@        return view\n    }()\n",acode];
    return acode;
}

- (void)operatName:(NSString*)name {
    NSArray *names = [name componentsSeparatedByString:@"-"];
    if (names.count == 2) {
        self.Imagename = names[0];
        self.name = names[1];
    } else { // Label
        self.Imagename = name;
        self.name = name;
    }
}

-(void)setupRadius:(float)number {
    if (number > (self.height*0.5)) {
        self.radius = self.height *0.5;
    }else {
        self.radius = number;
    }
}

-(void)setupBorderWidth:(float)number {
    self.borderWidth = number < 1.0 ? 1.0 : number;
}

-(id)getStyle:(id)layer {
    id style = [layer valueForKeyPath:@"style"];
    id border = [[style valueForKeyPath:@"borders"] firstObject];
    if (border == nil) {
        style = [self getShapeGroupStyleLayer:layer];
    }
    return style;
}

// ShapeGroup保存了borders, fill属性
-(id)getShapeGroupStyleLayer:(id)layer {
    NSArray *subLayers = [layer valueForKeyPath:@"layers"];
    for (id sub in subLayers) {
        NSString *classname = [sub className];
        if ([classname isEqual:@"MSShapeGroup"]) {
            return [sub valueForKey:@"style"];
        } else if ([classname isEqual:@"MSLayerGroup"]) {
            return [self getShapeGroupStyleLayer:sub];
        }
    }
    return nil;
}

// 获取radius
-(id)getCorRadiusStyleLayer:(id)layer {
    NSArray *subLayers = [layer valueForKeyPath:@"layers"];
    for (id sub in subLayers) {
        NSString *classname = [sub className];
        if ([classname isEqual:@"MSShapeGroup"]) {
            return [self getCorRadiusStyleLayer:sub];
        }else if ([classname isEqual:@"MSLayerGroup"]) {
            return [self getCorRadiusStyleLayer:sub];
        }
        if ([classname isEqual:@"MSRectangleShape"]) {
            return sub;
        }
    }
    return nil;
}

- (id)getTextLayer:(id)layer {
    NSArray *subLayers = [layer valueForKeyPath:@"layers"];
    for (id sub in subLayers) {
        NSString *classname = [sub className];
        if ([classname isEqual:@"MSLayerGroup"]) {
            return [self getTextLayer:sub];
        }
        if ([classname isEqual:@"MSTextLayer"]) {
            return sub;
        }
    }
    return nil;
}

-(void)setTextwithLayer:(id)layer {
    NSString *cname = [layer className];
    if ([cname isEqual:@"MSTextLayer"]) {
        SObject *label = [[SObject alloc]initWithLayer:layer];
        self.text = label.text;
    }
}

- (NSString*)textAlignmentString:(id)number {
    NSInteger value = [number integerValue];
    // 对齐属性对应的值 0 左对齐 2 居中 1 右对齐 3 两边对齐
    if (value == 0) {
        return @".left";
    } else if (value == 2) {
        return @".center";
    } else if (value == 1) {
        return @".right";
    } else {
        return @".left";
    }
}

- (NSString*)colorString:(id)color {
    NSString *hexColor = [self hexStringFromColor:color];
    float a = [[color valueForKeyPath:@"alpha"] floatValue];
    if (a == 1.0) {
        // 可以遍历处所有的颜色
        NSString *string = self.colorDic[hexColor];
        if (string == nil) {
            return [NSString stringWithFormat: @"UIColor(hex: %@)", hexColor];
        } else {
            return string;
        }
    } else {
        return [NSString stringWithFormat: @"UIColor(hex: %@, alpha: %.2f)", hexColor, a];
    }
}

- (NSString *)hexStringFromColor:(id)color {
    
    NSNumber *r = [color valueForKeyPath:@"red"];
    NSNumber *g = [color valueForKeyPath:@"green"];
    NSNumber *b = [color valueForKeyPath:@"blue"];
 
    return [NSString stringWithFormat:@"0x%02lX%02lX%02lX",
            lroundf([r floatValue]  * 255),
            lroundf([g floatValue] * 255),
            lroundf([b floatValue] * 255)];
}

-(NSString*)boldString:(NSString*)fontName {
    NSArray *array = [fontName componentsSeparatedByString:@"-"];
    if (array.count == 2) {
        if ([array[1] isEqual:@"Semibold"]) {
            return @"true";
        }
    }
    return @"false";
}

- (NSDictionary*)colorDic {
    if (!_colorDic) {
        _colorDic = @{@"0x666666" : @"UIColor.wordLightBlack",
                      @"0x000000": @"UIColor.wordBlack",
                      @"0xFFFFFF": @"UIColor.white"
                      };
    }
    return _colorDic;
    
}

//
//- (void)setText:(NSString *)text {
//    _text = text;
//    self.code = [self generateCode];
//}

@end
