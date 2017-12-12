//
//  iOSCodeUIMSInspectorStackView.h
//  iOSCodeGenerate
//
//  Created by mac on 2017/12/12.
//Copyright © 2017年 iOSCode. All rights reserved.
//

#ifndef iOSCodeUIMSInspectorStackView_h
#define iOSCodeUIMSInspectorStackView_h

@protocol iOSCodeUIMSInspectorStackView <NSObject>

@property (nonatomic, strong) NSArray *sectionViewControllers;
- (void)reloadWithViewControllers:(NSArray *)controllers;

@end

#endif /* iOSCodeUIMSInspectorStackView_h */
