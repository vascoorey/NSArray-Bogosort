//
//  NSArray+BogoSort.m
//  NSArray+Bogosort
//
//  Created by Vasco d'Orey on 03/03/14.
//  Copyright (c) 2014 DeltaDog. All rights reserved.
//

#import "NSArray+BogoSort.h"

@interface NSMutableArray (BogoSortMutable_Private)

/**
 *  Shuffles the contents of the array using the Knuth Shuffle
 */
- (void) DOG_shuffle;

@end

@interface NSArray (BogoSort_Private)

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
  unsigned long count = 0;
  NSMutableArray *bogoSortedArray = [self mutableCopy];
  while (!bogoSortedArray.DOG_isSorted)
  {
    NSLog(@"%lu", count);
    count ++;
    // Keep dancing the Knuth Shuffle, yo
    [bogoSortedArray DOG_shuffle];
  }
  return bogoSortedArray;
}

- (NSArray *) DOG_bogoBogoSort
{
  NSMutableArray *bogoBogoSortedArray = [NSMutableArray array];
  NSMutableArray *mutableSelf = [self mutableCopy];
  
  unsigned long count = 0;
  while (mutableSelf.count)
  {
    NSLog(@"%lu", count);
    count ++;
    if(!bogoBogoSortedArray.count)
    {
      // Need to pick 2 at random
      id first = [mutableSelf objectAtIndex:arc4random_uniform((uint32_t)mutableSelf.count)];
      [mutableSelf removeObject:first];
      id second = [mutableSelf objectAtIndex:arc4random_uniform((uint32_t)mutableSelf.count)];
      [mutableSelf removeObject:second];
      
      if([first isKindOfClass:[second class]] &&
         [first respondsToSelector:@selector(compare:)] &&
         [second respondsToSelector:@selector(compare:)])
      {
        if([first compare:second] != NSOrderedDescending)
        {
          [bogoBogoSortedArray addObjectsFromArray:@[ first, second ]];
        }
        else
        {
          // Restart
          bogoBogoSortedArray = [NSMutableArray array];
          mutableSelf = [self mutableCopy];
        }
      }
      else
      {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid objects in array" userInfo:nil] raise];
        return nil;
      }
    }
    else
    {
      id random = [mutableSelf objectAtIndex:arc4random_uniform((uint32_t)mutableSelf.count)];
      [mutableSelf removeObject:random];
      if([random isKindOfClass:[bogoBogoSortedArray.lastObject class]] &&
         [bogoBogoSortedArray.lastObject respondsToSelector:@selector(compare:)])
      {
        if([bogoBogoSortedArray.lastObject compare:random] != NSOrderedDescending)
        {
          [bogoBogoSortedArray addObject:random];
        }
        else
        {
          // Restart
          bogoBogoSortedArray = [NSMutableArray array];
          mutableSelf = [self mutableCopy];
        }
      }
      else
      {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid objects in array" userInfo:nil] raise];
        return nil;
      }
    }
  }
  
  return bogoBogoSortedArray;
}

@end

@implementation NSMutableArray (BogoSortMutable_Private)

- (void) DOG_shuffle
{
  /**
   *  To shuffle an array a of n elements (indices 0..n-1):
   *
   *  for i from n − 1 downto 1 do
   *    j ← random integer with 0 ≤ j ≤ i
   *    exchange a[j] and a[i]
   */
  NSUInteger count = self.count;
  for(NSUInteger i = count - 1; i > 0; i --)
  {
    [self exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((uint32_t)(i + 1))];
  }
}

@end

@implementation NSArray (BogoSort_Private)

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
