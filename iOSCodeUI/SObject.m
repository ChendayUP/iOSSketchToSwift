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
        id style = [layer valueForKeyPath:@"style"];
        if (style != nil) {
            id border = [[style valueForKeyPath:@"borders"] firstObject];
            id fill = [[style valueForKeyPath:@"fills"] firstObject];
            self.borderWidth = [[border valueForKeyPath:@"thickness"] integerValue];
            self.borderColor = [self colorString:[border valueForKeyPath:@"color"]];
            self.backgroundColor = [self colorString:[fill valueForKeyPath:@"color"]];
        }
        self.code = @"";
    }
    return self;
}

- (void)operatName:(NSString*)name {
    NSArray *names = [name componentsSeparatedByString:@"-"];
    if (names.count == 2) {
        self.Imagename = names[0];
        self.name = names[1];
    }
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
    // 可以遍历处所有的颜色
    NSString *string = self.colorDic[hexColor];
    if (string == nil) {
        return [NSString stringWithFormat: @"UIColor(hex: %@)", hexColor];
    } else {
        return string;
    }
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
                      @"0x333333": @"UIColor.wordBlack"
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
