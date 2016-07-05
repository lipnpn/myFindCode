/*
 * (C) Copyright 2000 Mulle kybernetiK
 *
 * Check out www.mulle-kybernetik.com for licensing details
 *
 * $Id$
 *
 * $Log$
 *
 */
#import "Stopwatch.h"
#include <unistd.h>

@implementation Stopwatch


- (void) dealloc
{
   [logString_ release];
   [super dealloc];
}


+ (void) delay:(unsigned long) milliseconds
{
   struct timeval   wait;

   wait.tv_sec  = milliseconds / 1000;
   wait.tv_usec = (milliseconds % 1000) * 1000;
   select( 0, NULL, NULL, NULL, &wait);  // use select as sleepMs
}


- (void) start
{
   gettimeofday( &start_, NULL);
   running_ = YES;
}


- (void) startAndLog:(NSString *) s
{
   [logString_ release];
   logString_ = [s copy];

   printf( "Starting %s...\n", [s cString]);
   [self start];
}


- (void) stopAndLog
{
   [self stop];

   printf( "Stopped %s %lums elapsed\n", [logString_ cString], [self elapsedMilliseconds]);
}


- (void) calcElapsed
{
   long   us;
   int    carry;
   
   if( ! running_)
      [NSException raise:NSGenericException
                  format:@"Stopwatch %@ ain't running", self];
   gettimeofday( &stop_, NULL);

   if( carry = stop_.tv_usec < start_.tv_usec)
      us = 1000000 - start_.tv_usec + stop_.tv_usec;
   else
      us = stop_.tv_usec - start_.tv_usec;
      
   elapsed_ = (stop_.tv_sec - start_.tv_sec - carry) * 1000 + us / 1000;
}


- (void) stop
{
   [self calcElapsed];
   running_ = NO;
}   


- (unsigned long) elapsedMilliseconds
{
   if( running_)
      [self calcElapsed];
   return( elapsed_);
}


@end
