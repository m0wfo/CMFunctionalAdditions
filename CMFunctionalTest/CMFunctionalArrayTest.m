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
    
    sample = [NSMutableArray array];
    int i;
    for (i = 0; i < 2000; i++) [sample addObject:[NSNumber numberWithInt:i]];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testRemovalAndFiltration
{
    NSNumber* num = [NSNumber numberWithInt:1337];
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

@end
