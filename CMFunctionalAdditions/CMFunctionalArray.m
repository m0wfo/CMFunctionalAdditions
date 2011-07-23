//
//  CMFunctionalArray.m
//  Functional Additions
//
//  Created by Chris Mowforth on 14/07/2011.
//  Copyright 2011 Chris Mowforth. All rights reserved.
//

#import "CMFunctionalArray.h"


@implementation NSArray (CMFunctionalArray)

- (NSArray *)mapWithBlock:(id (^)(id obj))block
{
    return [self mapWithIndexedBlock:^id(NSUInteger idx, id mappedObj) {
        return block(mappedObj);
    }];
}

- (NSArray*)mapWithIndexedBlock:(id (^)(NSUInteger idx, id obj))block
{
    __block NSMutableArray* mapped = [NSMutableArray arrayWithCapacity:[self count]];
    dispatch_queue_t result_queue = dispatch_queue_create(NULL, NULL);
    
    dispatch_apply([self count], result_queue, ^(size_t i) {
        [mapped addObject:block(i, [self objectAtIndex:i])];
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
        return predicate(obj) == NO;
    }];
}

- (NSArray*)partitionWithBlock:(BOOL (^)(id))block
{    
    NSArray* matching = [self filterWithPredicate:block];
    NSArray* rest = [self removeWithPredicate:block];
    
    return [NSArray arrayWithObjects:matching, rest, nil];
}

- (NSArray*)partitionWithSize:(NSUInteger)size
{
    __block NSMutableArray* sub;
    NSUInteger count = [self count];
    NSUInteger remainder = count % size;
    NSUInteger total = (count / size) + remainder;
    
    sub = [NSMutableArray arrayWithCapacity:total];
    
    dispatch_queue_t result_queue = dispatch_queue_create(NULL, NULL);
    
    dispatch_apply(total, result_queue, ^(size_t i) {
        NSUInteger step = i * size;
        NSUInteger upper_bound = size;
        if (step + upper_bound > [self count]) upper_bound = remainder;
        NSRange range = NSMakeRange(step, upper_bound);
        NSArray* sub_array = [self subarrayWithRange:range];
        
        [sub insertObject:sub_array atIndex:i];
    });
    
    dispatch_release(result_queue);
    
    return sub;
}

- (id)reduceWithBlock:(id (^)(id memo, id obj))block andAccumulator:(id)accumulator
{
    if ([self count] == 1) return [self objectAtIndex:0];
    
    id acc = [[accumulator copy] autorelease];
    
    for (id obj in self) { acc = block(acc, obj); }
    
    return acc;
}

- (NSArray*)uniqueElements
{
    __block NSMutableArray* unique = [NSMutableArray array];
    dispatch_queue_t result_queue = dispatch_queue_create(NULL, NULL);
    
    dispatch_apply([self count], result_queue, ^(size_t i) {
        id obj = [self objectAtIndex:i];
        if (![unique containsObject:obj]) [unique addObject:obj];
    });
    
    dispatch_release(result_queue);
    
    return unique;
}

@end
