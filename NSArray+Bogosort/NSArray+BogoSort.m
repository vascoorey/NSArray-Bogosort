//
//  NSArray+BogoSort.m
//  NSArray+Bogosort
//
//  Created by Vasco d'Orey on 03/03/14.
//  Copyright (c) 2014 DeltaDog. All rights reserved.
//

#import "NSArray+BogoSort.h"

@interface NSArray (BogoSort_Private)

/**
 *  Shuffles the contents of the array using the Knuth Shuffle
 */
- (NSArray *) DOG_shuffle;

/**
 *  Check if the array is sorted.
 */
@property (nonatomic, readonly) BOOL DOG_isSorted;

@end

@implementation NSArray (BogoSort)

- (NSArray *) DOG_bogoSort
{
  /**
   *  So, bogosort randomly sorts an array and checks if it is sorted. If not it should try again.
   *  It should only return when the array is sorted.
   */
  NSArray *bogoSortedArray = self;
  while (!bogoSortedArray.DOG_isSorted)
  {
    // Keep dancing the Knuth Shuffle, yo
    bogoSortedArray = [bogoSortedArray DOG_shuffle];
  }
  return bogoSortedArray;
}

@end

@implementation NSArray (BogoSort_Private)

- (NSArray *) DOG_shuffle
{
  /**
   *  To shuffle an array a of n elements (indices 0..n-1):
   *
   *  for i from n − 1 downto 1 do
   *    j ← random integer with 0 ≤ j ≤ i
   *    exchange a[j] and a[i]
   */
  NSMutableArray *mutable = [self mutableCopy];
  NSUInteger count = mutable.count;
  for(NSUInteger i = count - 1; i > 0; i --)
  {
    [mutable exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(i + 1)];
  }
  
  // Return an immutable array
  return [mutable copy];
}

- (BOOL) DOG_isSorted
{
  // First we need to make sure all objects are of the same class and answer to compare:
  // Then we compare them. If 1 or more is out of order we return NO.
  NSEnumerator *enumerator = self.objectEnumerator;
  id currentObject = [enumerator nextObject];
  while(currentObject)
  {
    id nextObject = [enumerator nextObject];
    if(nextObject)
    {
      if([currentObject isKindOfClass:[nextObject class]] &&
         [currentObject respondsToSelector:@selector(compare:)] &&
         [nextObject respondsToSelector:@selector(compare:)])
      {
        // Reject if next is smaller than current
        if([currentObject compare:nextObject] == NSOrderedDescending)
        {
          return NO;
        }
      }
      else
      {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid objects in array" userInfo:nil] raise];
        return NO;
      }
    }
    currentObject = nextObject;
  }
  return YES;
}

@end
