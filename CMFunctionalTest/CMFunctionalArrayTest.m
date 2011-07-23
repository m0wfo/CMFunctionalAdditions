//
//  CMFunctionalTest.m
//  CMFunctionalTest
//
//  Created by Chris Mowforth on 22/07/2011.
//  Copyright 2011 Chris Mowforth. All rights reserved.
//

#import "CMFunctionalArrayTest.h"

@implementation CMFunctionalArrayTest

- (void)setUp
{
    [super setUp];
    
    num = [NSNumber numberWithInt:3];

    sample = [NSMutableArray array];
    int i;
    for (i = 0; i < 10; i++) [sample addObject:[NSNumber numberWithInt:i]]; // 2001 just to be an odd number
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testRemovalAndFiltration
{
    BOOL (^predicate)(NSNumber* obj) = ^(NSNumber* obj) { return [obj isEqualToNumber:num]; };

    NSArray* removed = [sample removeWithPredicate:predicate];
    NSArray* filtered = [sample filterWithPredicate:predicate];

    STAssertEquals([removed count], [sample count] - 1, @"One object should have been removed");
    STAssertEquals([filtered count], (NSUInteger)1, @"One object should have been filtered");
    
//    Filter and remove are duals of each other:
    NSArray* combined = [removed arrayByAddingObjectsFromArray:filtered];

    STAssertEquals([combined count], [sample count], @"Combination of filtration and removal should yield original array");
}

- (void)testMapping
{
    NSString* (^applied_fun)(id obj) = ^(id obj) { return [NSString stringWithFormat:@"<->%@<->", obj]; };
    
    NSArray* mapped = [sample mapWithBlock:applied_fun];
    
    STAssertEquals([mapped count], [sample count], @"Mapped array should be same length as original");
    STAssertEqualObjects([mapped lastObject], applied_fun([sample lastObject]), @"Object mappings should be returned in order");
}

- (void)testReduction
{
    id reduced = [sample reduceWithBlock:^id(id memo, id obj) {
        return [NSNumber numberWithInt:([memo intValue] + [obj intValue])];
    } andAccumulator:[NSNumber numberWithInt:0]];
    
    STAssertNotNil(reduced, @"Reduction should return something");
    STAssertEqualObjects(reduced, [NSNumber numberWithInt:45], @"Reduction should return correct value");
    STAssertTrue([reduced isKindOfClass:[NSNumber class]], @"Reduction should return same type yielded by block");
}

- (void)testPartitioningBySize
{
    NSArray* partitioned = [sample partitionWithSize:3];
    NSUInteger number_sub_arrays = ([sample count] / 3) + ([sample count] % 3);
    STAssertEquals([partitioned count], number_sub_arrays, @"Partitioning by size should return correct number of sub-arrays");
}

- (void)testUnique
{
    NSArray* duplicates = [NSArray arrayWithObjects:@"foo", @"foo", @"bar", nil];
    NSArray* unique = [NSArray arrayWithObjects:@"foo", @"bar", nil];
    
    STAssertEqualObjects([duplicates uniqueElements], unique, @"UniqueElements should remove objects with duplicate value");
}

- (void)testTakeWhile
{
    NSArray* taken = [sample takeWhilePredicateHoldsTrue:^BOOL(id obj) {
        return YES;
    }];
}

@end
