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
 *  Will raise an NSInvalidArgumentException if any object in the array doesn't implement compare:
 *  Does not guarantee to halt.
 */
- (NSArray *) DOG_bogoSort;

/**
 *  When this one works it works. Probability of working is 1 / n! (for a list of n elements)
 *  Will raise an NSInvalidArgumentException if any object in the array doesn't implement compare:
 *  Does not guarantee to halt.
 */
- (NSArray *) DOG_bogoBogoSort;

@end
