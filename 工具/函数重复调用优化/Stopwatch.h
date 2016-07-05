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
#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <sys/time.h>


@interface Stopwatch : NSObject
{
   BOOL             running_;
   unsigned long    elapsed_;

   struct timeval   start_;
   struct timeval   stop_;
 
   NSString         *logString_; 
}

- (void) start;
- (void) stop;	  
- (unsigned long) elapsedMilliseconds;
+ (void) delay:(unsigned long) milliseconds;

- (void) startAndLog:(NSString *) s;
- (void) stopAndLog;

@end
