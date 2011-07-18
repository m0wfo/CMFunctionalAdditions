//
//  CMFunctionalArray.h
//  Functional Additions
//
//  Created by Chris Mowforth on 14/07/2011.
//  Copyright 2011 Limpet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (CMFunctionalArray)

- (NSArray*)mapWithBlock:(NSDictionary* (^)(id obj))block;
- (NSArray*)filterWithPredicate:(BOOL (^)(id obj))predicate;
- (NSArray*)removeWithPredicate:(BOOL (^)(id obj))predicate;
- (NSArray*)partitionWithBlock:(BOOL (^)(id obj))block;
- (id)reduceWithBlock:(id (^)(id memo, id obj))block andAccumulator:(id)accumulator;

@end
