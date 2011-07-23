//
//  CMFunctionalArray.h
//  Functional Additions
//
//  Created by Chris Mowforth on 14/07/2011.
//  Copyright 2011 Chris Mowforth. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (CMFunctionalArray)

- (NSArray*)mapWithBlock:(id (^)(id obj))block;
- (NSArray*)mapWithIndexedBlock:(id (^)(NSUInteger idx, id obj))block;
- (NSArray*)filterWithPredicate:(BOOL (^)(id obj))predicate;
- (NSArray*)removeWithPredicate:(BOOL (^)(id obj))predicate;
- (NSArray*)filterWithPredicate:(BOOL (^)(id obj))predicate andStopOnFailure:(BOOL)stop;
- (NSArray*)removeWithPredicate:(BOOL (^)(id obj))predicate andStopOnFailure:(BOOL)stop;
- (NSArray*)takeWhilePredicateHoldsTrue:(BOOL (^)(id obj))predicate;
- (NSArray*)partitionWithBlock:(BOOL (^)(id obj))block;
- (NSArray*)partitionWithSize:(NSUInteger)size;
- (id)reduceWithBlock:(id (^)(id memo, id obj))block andAccumulator:(id)accumulator;
- (NSArray*)uniqueElements;

@end
