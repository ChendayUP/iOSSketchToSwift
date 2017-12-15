//
//  iOSCodeUI.m
//  iOSCodeGenerate
//
//  Created by mac on 2017/12/12.
//Copyright © 2017年 iOSCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSCodeUI.h"
#import <CocoaScript/COScript.h>
#import "iOSCodeUISketchPanelController.h"
@import JavaScriptCore;
#import <Mocha/Mocha.h>
#import <Mocha/MOClosure.h>
#import <Mocha/MOJavaScriptObject.h>
#import <Mocha/MochaRuntime_Private.h>


@interface iOSCodeUI : NSObject

@property (nonatomic, strong) iOSCodeUISketchPanelController *panelController;
@property (nonatomic, strong) id <iOSCodeUIMSDocument> document;
@property (nonatomic, copy) NSString *panelControllerClassName;

+ (instancetype)onSelectionChanged:(id)context;
+ (instancetype)onVCCodeGenerated:(id)context;
- (void)onSelectionChange:(NSArray *)selection;
- (void)VCCodeGenerated:(NSArray *)selection;
+ (void)setSharedCommand:(id)command;

@end



@implementation iOSCodeUI

static id _command;

+ (void)setSharedCommand:(id)command {
    _command = command;
}

+ (id)sharedCommand {
    return _command;
}

+ (instancetype)onVCCodeGenerated:(id)context {
    //    COScript *coscript = [COScript currentCOScript];
    
    id <iOSCodeUIMSDocument> document = [context valueForKeyPath:@"actionContext.document"];
    if ( ! [document isKindOfClass:NSClassFromString(@"MSDocument")]) {
        document = nil;  // be safe
        return nil;
    }
    
    if ( ! [self sharedCommand]) {
        [self setSharedCommand:[context valueForKeyPath:@"command"]]; // MSPluginCommand
    }
    
    NSString *key = [NSString stringWithFormat:@"%@-iOSCodeUI", [document description]];
    __block iOSCodeUI *instance = [[Mocha sharedRuntime] valueForKey:key];
    
    if ( ! instance) {
        //        [coscript setShouldKeepAround:YES];
        instance = [[self alloc] initWithDocument:document];
        [[Mocha sharedRuntime] setValue:instance forKey:key];
    }
    
    NSArray *selection = [context valueForKeyPath:@"actionContext.document.selectedLayers"];
    //    NSLog(@"selection %p %@ %@", instance, key, selection);
    [instance onSelectionChange:selection];
    return instance;
}

+ (instancetype)onSelectionChanged:(id)context {

//    COScript *coscript = [COScript currentCOScript];

    id <iOSCodeUIMSDocument> document = [context valueForKeyPath:@"actionContext.document"];
    if ( ! [document isKindOfClass:NSClassFromString(@"MSDocument")]) {
        document = nil;  // be safe
        return nil;
    }

    if ( ! [self sharedCommand]) {
        [self setSharedCommand:[context valueForKeyPath:@"command"]]; // MSPluginCommand
    }

    NSString *key = [NSString stringWithFormat:@"%@-iOSCodeUI", [document description]];
    __block iOSCodeUI *instance = [[Mocha sharedRuntime] valueForKey:key];

    if ( ! instance) {
//        [coscript setShouldKeepAround:YES];
        instance = [[self alloc] initWithDocument:document];
        [[Mocha sharedRuntime] setValue:instance forKey:key];
    }

    NSArray *selection = [context valueForKeyPath:@"actionContext.document.selectedLayers"];
//    NSLog(@"selection %p %@ %@", instance, key, selection);
    [instance onSelectionChange:selection];
    return instance;
}

- (instancetype)initWithDocument:(id <iOSCodeUIMSDocument>)document {
    if (self = [super init]) {
        _document = document;
        _panelController = [[iOSCodeUISketchPanelController alloc] initWithDocument:_document];
    }
    return self;
}

- (void)VCCodeGenerated:(NSArray *)selection {
    
}

- (void)onSelectionChange:(NSArray *)selection {
    [_panelController selectionDidChange:selection];
}

@end
