//
//  SImage.h
//  iOSCodeUI
//
//  Created by mac on 2017/12/12.
//  Copyright © 2017年 iOSCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SObject : NSObject

@property (nonatomic, copy) NSString *fullname;
@property (nonatomic, copy) NSString *Imagename;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *textAlignment;
@property (nonatomic, copy) NSString *classname;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *isBold;
@property (nonatomic, copy) NSString *code;

//@property (nonatomic, copy) NSString *;

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger fontSize;
//@property (nonatomic, assign) NSInteger ;

@property (nonatomic, copy) NSString *borderColor;
@property (nonatomic, assign) NSInteger borderWidth;

- (instancetype)initWithLayer:(id)layer;
- (void)setTextwithLayer:(id)layer;
- (id)getTextLayer:(id)layer;
//- (NSString*)generateCode;
@end
