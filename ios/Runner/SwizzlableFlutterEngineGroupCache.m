#import "SwizzlableFlutterEngineGroupCache.h"

@implementation SwizzlableFlutterEngineGroupCache

+ (instancetype)sharedInstance {
    static SwizzlableFlutterEngineGroupCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.engineGroups = [NSMutableDictionary dictionary];
    });
    return instance;
}

- (FlutterEngineGroup *)get:(NSString *)key {
    return self.engineGroups[key];
}

- (void)put:(NSString *)key engineGroup:(FlutterEngineGroup *)engineGroup {
    self.engineGroups[key] = engineGroup;
}

@end