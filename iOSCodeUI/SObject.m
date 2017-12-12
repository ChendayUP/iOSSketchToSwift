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

- (instancetype)initWith:(id)layer
{
    self = [super init];
    if (self) {
        self.name = [layer valueForKeyPath:@"nodeName"];
        self.classname = [layer className];
        self.text = [layer valueForKeyPath:@"stringValue"];
        self.textAlignment = [self textAlignmentString:[layer valueForKeyPath:@"textAlignment"]];
        self.fontSize = [[layer valueForKeyPath:@"fontSize"] integerValue];
        self.color = [self colorString:[layer valueForKeyPath:@"textColor"]];
        self.isBold = [self boldString:[layer valueForKeyPath:@"fontPostscriptName"]];
        self.width = [[layer valueForKeyPath:@"frame.width"] integerValue];
        self.height = [[layer valueForKeyPath:@"frame.height"] integerValue];
    }
    return self;
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

@end
