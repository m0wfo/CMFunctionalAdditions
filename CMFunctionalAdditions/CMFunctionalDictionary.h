//
//  CMFunctionalAdditions.h
//  Functional Additions
//
//  Created by Chris Mowforth on 14/07/2011.
//  Copyright 2011 Limpet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (CMFunctionalDictionary)

- mapWithBlock:(NSDictionary* (^)(id key, id val))block;
- filterWithPredicate:(BOOL (^)(id key, id val))predicate;

@end
