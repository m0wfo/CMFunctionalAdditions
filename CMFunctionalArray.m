//
//  CMFunctionalArray.m
//  Functional Additions
//
//  Created by Chris Mowforth on 14/07/2011.
//  Copyright 2011 Limpet. All rights reserved.
//

#import "CMFunctionalArray.h"


@implementation NSArray (CMFunctionalArray)

- (NSArray*)mapWithBlock:(NSDictionary *(^)(id obj))block
{
    __block NSMutableArray* mapped = [NSMutableArray arrayWithCapacity:[self count]];
    dispatch_queue_t result_queue = dispatch_queue_create(NULL, NULL);
    dispatch_apply([self count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
        dispatch_async(result_queue, ^(void) { [mapped addObject:block([self objectAtIndex:i])]; });
    });
    
    dispatch_release(result_queue);
    
    return mapped;
}

- (NSArray*)filterWithPredicate:(BOOL (^)(id))predicate
{
    __block NSMutableArray* filtered = [NSMutableArray array];
    dispatch_queue_t result_queue = dispatch_queue_create(NULL, NULL);
    
    dispatch_apply([self count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
        id obj = [self objectAtIndex:i];
        if (predicate(obj)) {
            dispatch_async(result_queue, ^(void) { [filtered addObject:obj]; });
        }
    });
    
    dispatch_release(result_queue);
    
    return filtered;    
}

- (id)reduceWithBlock:(id (^)(id memo, id obj))block andAccumulator:(id)accumulator
{
    if ([self count] == 1) return [self objectAtIndex:0];
    
    id acc = [[accumulator copy] autorelease];
    
    for (id obj in self) { acc = block(acc, obj); }
    
    return acc;
}

@end
