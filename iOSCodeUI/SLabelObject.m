//
//  SLabelObject.m
//  iOSCodeUI
//
//  Created by mac on 2017/12/13.
//  Copyright © 2017年 iOSCode. All rights reserved.
//

#import "SLabelObject.h"

@implementation SLabelObject

-(instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        
    }
    return self;
}

-(NSString*)code {
    return [NSString stringWithFormat:@"    lazy var %@: UILabel = {\n        let view = UILabel.normalLabel(text: \"%@\", fontSize: %ld, color: %@, textAlignment: %@, isBold: %@)\n        return view\n    }()\n",self.name,self.text,(long)self.fontSize,self.color,self.textAlignment,self.isBold];
}

@end
