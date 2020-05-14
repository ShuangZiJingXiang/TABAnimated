//
//  TABAnimatedProduction.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/1.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedProduction.h"
#import "TABAnimated.h"
#import "TABAnimatedCacheManager.h"
#import "TABComponentLayer.h"

#import "TABAnimatedProductHelper.h"

@implementation TABAnimatedProduction

+ (instancetype)productWithState:(TABAnimatedProductionState)state {
    TABAnimatedProduction *production = [[TABAnimatedProduction alloc] initWithState:state];
    return production;
}

- (instancetype)initWithState:(TABAnimatedProductionState)state {
    if (self = [super init]) {
        _state = state;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _layers = @[].mutableCopy;
    }
    return self;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.backgroundLayer forKey:@"backgroundLayer"];
    [aCoder encodeObject:self.layers forKey:@"layers"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.version forKey:@"version"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.backgroundLayer = [aDecoder decodeObjectForKey:@"backgroundLayer"];
        self.layers = [aDecoder decodeObjectForKey:@"layers"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.version = [aDecoder decodeObjectForKey:@"version"];
        self.state = TABAnimatedProductionProcess;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TABAnimatedProduction *production = [[[self class] allocWithZone:zone] init];
    production.backgroundLayer = self.backgroundLayer.copy;
    production.layers = @[].mutableCopy;
    for (TABComponentLayer *layer in self.layers) {
        [production.layers addObject:layer.copy];
    }
    production.fileName = self.fileName;
    production.version = self.version;
    production.state = TABAnimatedProductionProcess;
    return production;
}

#pragma mark - Getter / Setter

- (BOOL)needUpdate {
    if (_version && _version.length > 0 &&
        [TABAnimatedCacheManager shareManager].currentSystemVersion &&
        [TABAnimatedCacheManager shareManager].currentSystemVersion.length > 0) {
        if ([_version isEqualToString:[TABAnimatedCacheManager shareManager].currentSystemVersion]) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (TABWeakDelegateManager *)syncDelegateManager {
    if (!_syncDelegateManager) {
        _syncDelegateManager = [[TABWeakDelegateManager alloc] init];
    }
    return _syncDelegateManager;
}

@end