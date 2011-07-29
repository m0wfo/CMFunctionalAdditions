//
//  main.m
//  CMFunctionalDemo
//
//  Created by Chris Mowforth on 29/07/2011.
//  Copyright 2011 Chris Mowforth. All rights reserved.
//
//  Feel free to stick a breakpoint or NSLog() in after any of
//  the following method calls to inspect the results.
//

#import <Foundation/Foundation.h>
#import "CMFunctionalArray.h"

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    //  We're using this array to play with:
    NSArray* sample = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", @"teapot", nil];

    
    //  Shall we map them so f(x) -> "SOMETHING#{x}"?
    NSArray* mapped = [sample mapWithBlock:^id(id obj) {
        return [NSString stringWithFormat:@"SOMETHING%@", obj];
    }];


    // Let's map x with its index
    NSArray* mappedIndex = [sample mapWithIndexedBlock:^id(NSUInteger idx, id obj) {
        return [NSString stringWithFormat:@"SOMETHING%@ AT INDEX %lu", obj, idx];
    }];


    //  How about reducing it?
    id reduced = [sample reduceWithBlock:^id(id memo, id obj) {
        return [NSString stringWithFormat:@"%@-%@", memo, obj];
    } andAccumulator:@""];


    //  But we don't like teapots; let's remove them
    BOOL (^discriminator)(id obj) = ^(id obj) { return [obj isEqual:@"teapot"]; };
    
    NSArray* teapotFree = [sample removeWithPredicate:discriminator];


    //  Even better, let's segregate them
    NSArray* segregated = [sample partitionWithBlock:discriminator];


    //  Now let's break *sample up into an array of 2-element NSArrays
    NSArray* chunked = [sample splitWithSize:2];

    [pool drain];
    return 0;
}

