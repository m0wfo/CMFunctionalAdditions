//
//  CMFunctionalAdditions.m
//  Functional Additions
//
//  Created by Chris Mowforth on 14/07/2011.
//  Copyright 2011 Limpet. All rights reserved.
//

#import "CMFunctionalDictionary.h"


@implementation NSDictionary (CMFunctionalDictionary)

- (id)mapWithBlock:(NSDictionary *(^)(id key, id val))block
{
    NSArray* keys = [self allKeys];
    __block NSMutableDictionary* mapped = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
    dispatch_queue_t result_queue = dispatch_queue_create(NULL, NULL);
    dispatch_apply([keys count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
        id key = [keys objectAtIndex:i];
        dispatch_async(result_queue, ^(void) {
            [mapped addEntriesFromDictionary:block(key, [self valueForKey:key])];
        });
    });
    
    dispatch_release(result_queue);
    
    return mapped;
}

- (id)filterWithPredicate:(BOOL (^)(id key, id val))predicate
{
    NSArray* keys = [self allKeys];
    __block NSMutableDictionary* filtered = [NSMutableDictionary dictionary];
    dispatch_queue_t result_queue = dispatch_queue_create(NULL, NULL);
    
    dispatch_apply([keys count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
        id key = [keys objectAtIndex:i];
        id value = [self valueForKey:key];
        if (predicate(key, value)) {
            dispatch_async(result_queue, ^(void) { [filtered setValue:value forKey:key]; });
        }
    });
    
    dispatch_release(result_queue);
    
    return filtered;
}

@end
