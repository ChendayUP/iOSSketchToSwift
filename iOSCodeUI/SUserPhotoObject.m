//
//  SUserPhotoObject.m
//  iOSCodeUI
//
//  Created by mac on 2017/12/13.
//  Copyright © 2017年 iOSCode. All rights reserved.
//

#import "SUserPhotoObject.h"

@implementation SUserPhotoObject

-(instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
  
    }
    return self;
}

-(NSString*)code {
    return [NSString stringWithFormat:@"    lazy var %@: UserPhotoImageView = {\n        let view = UserPhotoImageView(frame: CGRect(x: 0, y: 0, width: %ld, height: %ld))\n        view.size(%ld)\n        return view\n    }()\n",self.name,(long)self.width,(long)self.height,(long)self.width];
}

@end
