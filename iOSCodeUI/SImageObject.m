//
//  SImageObject.m
//  iOSCodeUI
//
//  Created by mac on 2017/12/13.
//  Copyright © 2017年 iOSCode. All rights reserved.
//

#import "SImageObject.h"

@implementation SImageObject

-(instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {

    }
    return self;
}

-(NSString*)code {
    return [NSString stringWithFormat:@"    lazy var %@: UIImageView = {\n        let view = UIImageView(image: R.image.%@())\n        view.width(%ld).height(%ld)\n        return view\n    }()\n",self.name,self.Imagename,(long)self.width,(long)self.height];
}
@end
