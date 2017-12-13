//
//  STextFieldObject.m
//  iOSCodeUI
//
//  Created by mac on 2017/12/13.
//  Copyright © 2017年 iOSCode. All rights reserved.
//

#import "STextFieldObject.h"

@implementation STextFieldObject

-(instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        id textLayer = [self getTextLayer:layer];
        [self setTextwithLayer:textLayer];
    }
    return self;
}
-(NSString*)code {
    // 按钮应该是根据项目,把所有的按钮样式先罗列出来,封装好直接调用,然后根据名称直接生成
    if ([self.name hasSuffix:@"cTextField"]) {
        return [NSString stringWithFormat:@"    lazy var %@: profileTextField = {\n        let view = profileTextField.instance(dx: 20)\n        view.placeholder = \"%@\"\n        view.height(%ld)\n        return view\n    }()\n",self.name, self.text, (long)self.height];
    }
    return @"";
}


@end
