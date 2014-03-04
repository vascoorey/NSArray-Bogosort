//
//  NSArray+BogoSort.h
//  NSArray+Bogosort
//
//  Created by Vasco d'Orey on 03/03/14.
//  Copyright (c) 2014 DeltaDog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BogoSort)

/**
 *  Sorts the contents of the array using BogoSort.
 *  Will raise an NSInvalidArgumentException if any object in the array doens't implement compare:
 *  Does not guarantee to halt.
 */
- (NSArray *) DOG_bogoSort;

@end
