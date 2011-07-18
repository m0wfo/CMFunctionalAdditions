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
    
    dispatch_apply([self count], result_queue, ^(size_t i) {
        [mapped addObject:block([self objectAtIndex:i])];
    });
    
    dispatch_release(result_queue);
    
    return mapped;
}

- (NSArray*)filterWithPredicate:(BOOL (^)(id obj))predicate
{
    __block NSMutableArray* filtered = [NSMutableArray array];
    dispatch_queue_t result_queue = dispatch_queue_create(NULL, NULL);
    
    dispatch_apply([self count], result_queue, ^(size_t i) {
        id obj = [self objectAtIndex:i];
        if (predicate(obj)) [filtered addObject:obj];
    });
    
    dispatch_release(result_queue);
    
    return filtered;    
}

- (NSArray*)removeWithPredicate:(BOOL (^)(id obj))predicate
{
    return [self filterWithPredicate:^BOOL(id obj) {
        return predicate(obj) == FALSE;
    }];
}

- (NSArray*)partitionWithBlock:(BOOL (^)(id))block
{    
    NSArray* matching = [self filterWithPredicate:block];
    NSArray* rest = [self removeWithPredicate:block];
    
    return [NSArray arrayWithObjects:matching, rest, nil];
}

- (id)reduceWithBlock:(id (^)(id memo, id obj))block andAccumulator:(id)accumulator
{
    if ([self count] == 1) return [self objectAtIndex:0];
    
    id acc = [[accumulator copy] autorelease];
    
    for (id obj in self) { acc = block(acc, obj); }
    
    return acc;
}

@end
