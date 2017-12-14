//
//  SButtonObject.m
//  iOSCodeUI
//
//  Created by mac on 2017/12/13.
//  Copyright © 2017年 iOSCode. All rights reserved.
//

#import "SButtonObject.h"
#import "SLabelObject.h"

@implementation SButtonObject

-(instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        NSArray *subLayers = [layer valueForKeyPath:@"layers"];
        for (id sub in subLayers) {
            NSString *classname = [sub className];
            if ([classname isEqual:@"MSTextLayer"]) {
                SObject *label = [[SObject alloc]initWithLayer:sub];
                self.text = label.text;
                break;
            }
        }
      
       
    }
    return self;
}

-(NSString*)code {
    // 按钮应该是根据项目,把所有的按钮样式先罗列出来,封装好直接调用,然后根据名称直接生成
    NSString *acode = @"";
    if ([self.name hasSuffix:@"GradientButton"]) {
        return [NSString stringWithFormat:@"    lazy var %@: UIButton = {\n        let view = GradientButton(frame: CGRect(x: 0, y: 0, width: self.view.mm_width, height: %ld))\n        view.setTitle(\"%@\", for: .normal)\n        view.height(%ld)\n        return view\n    }()\n",self.name,(long)self.height,self.text,(long)self.height];
    } else if ([self.name hasSuffix:@"shadowButton"]) {
        return [NSString stringWithFormat:@"    lazy var %@: UIButton = {\n        let view = shadowButton(frame: CGRect(x: 0, y: 0, width: self.view.mm_width, height: %ld))\n        view.setTitle(\"%@\", for: .normal)\n        view.height(%ld)\n        return view\n    }()\n",self.name,(long)self.height,self.text,(long)self.height];
    } else if ([self.name hasSuffix:@"Button"]) {
        acode = [NSString stringWithFormat:@"    lazy var %@: UIButton = {\n        let view = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.mm_width, height: %ld))\n        view.setTitle(\"%@\", for: .normal)\n        view.height(%ld)\n",self.name,(long)self.height,self.text,(long)self.height];
    }
    acode = [NSString stringWithFormat:@"%@%@",acode,[self baseCode]];
    return acode;
}

@end
