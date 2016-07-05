#import <Foundation/Foundation.h>
#include <objc/objc-class.h>
#include <objc/objc-runtime.h>
#include "Stopwatch.h"

// for amber http://developer.apple.com/hardware/ve/g5.html#simulator
#if defined( __GNUC__ )
#include <ppc_intrinsics.h>
#endif


#define LOOPS                10000
#define OBJECTS              10000
#define BREAK_FOR_AMBER      0
#define USE_CORE_FOUNDATION  1 


@interface Dummy1 : NSObject
{
}
@end


@implementation Dummy1

- (void) operate 
{
}

- (void) annihilate
{
}

@end



@interface Dummy2 : Dummy1
{
}
@end


@implementation Dummy2

- (void) operate 
{
}

- (void) annihilate
{
}

@end


@interface Dummy3 : NSObject
{
}
@end



@implementation Dummy3

- (void) operate 
{
}

- (void) annihilate
{
}

@end




@interface PowerContainer : NSMutableArray
{
   NSMutableArray   *_array;
}

- (void) operateAnnihilateNaive;
- (void) operateAnnihilateNaiveCore;
- (void) operateAnnihilate;
- (void) operateAnnihilateFast;
- (void) operateAnnihilateFastest;

@end


extern IMP   class_lookupMethod( Class cls, SEL sel);


@implementation PowerContainer

- (id) init
{
   _array = [[NSMutableArray alloc] init];
   return( self);
}

- (void) addObject:(id) p
{ 
   [_array addObject:p];
}


- (unsigned int) count
{
   return( [_array count]);
}


static inline Class   _isa( NSObject *obj)
{
   return( ((struct { @defs( NSObject) } *) obj)->isa);
}



- (void) warmup  // different name for shark same as naive
{
   int  n;
   int  i;
   id   p;
  
   n   = [_array count];
   for( i = 0; i < n; i++)
   {
      p = [_array objectAtIndex:i]; 
      [p operate];
      [p annihilate];
   }
}


- (void) operateAnnihilateNaive
{
   int  n;
   int  i;
   id   p;
  
   n   = [_array count];
   for( i = 0; i < n; i++)
   {
      p = [_array objectAtIndex:i]; 
      [p operate];
      [p annihilate];
   }
}

- (void) operateAnnihilateNaiveCore
{
   int  n;
   int  i;
   id   p;
  
   n   = [_array count];
   for( i = 0; i < n; i++)
   {
      p = CFArrayGetValueAtIndex( (CFArrayRef) _array, (CFIndex) i); 
      [p operate];
      [p annihilate];
   }
}


#if USE_CORE_FOUNDATION 

- (void) operateAnnihilate
{
   void	 *(*f)();
   int  n;
   int  i;
   id   p;
  
   f   =  (void *) CFArrayGetValueAtIndex;
   n   = [_array count];
   for( i = 0; i < n; i++)
   {
      p = (f)( _array, i);
      [p operate];
      [p annihilate];
   }
}

#else

- (void) operateAnnihilate
{
   SEL  sel;
   IMP  f;
   int  n;
   int  i;
   id   p;
  
   sel = @selector( objectAtIndex:);
   f   = [_array methodForSelector:sel];
   n   = [_array count];
   for( i = 0; i < n; i++)
   {
      p = (f)( _array, sel, i);
      [p operate];
      [p annihilate];
   }
}

#endif


#if USE_CORE_FOUNDATION 

- (void) operateAnnihilateFast // :(id (*)( id, SEL, ...)) objc_call
{
   SEL   operateSel;
   SEL   annihilateSel;
   void	 *(*f)();
   int   n;
   int   i;
   id    p;
   id    (*objc_call)( id, SEL, ...);   
  
   objc_call = objc_msgSend;
 
   f   =  (void *) CFArrayGetValueAtIndex;
   n   = [_array count];
   
//   operateSel     = @selector( operate);
//   annihilateSel  = @selector( annihilate);
  
   // trigger amber 
   for( i = 0; i < n; i++)
   {
      p = (f)( _array, i);
#if BREAK_FOR_AMBER
      if( i == 0 || i == 100)
         __mfspr( 1023);
#endif
      (*objc_call)( p, @selector( operate));
      (*objc_call)( p, @selector( annihilate));
   }
}

#else

- (void) operateAnnihilateFast // :(id (*)( id, SEL, ...)) objc_call
{
   SEL   operateSel;
   SEL   annihilateSel;
   SEL   sel;
   IMP   f;
   int   n;
   int   i;
   id    p;
   id    (*objc_call)( id, SEL, ...);   
  
   objc_call = objc_msgSend;
 
   sel = @selector( objectAtIndex:);
   f   = [_array methodForSelector:sel];
   n   = [_array count];
   
//   operateSel     = @selector( operate);
//   annihilateSel  = @selector( annihilate);
  
   // trigger amber 
   for( i = 0; i < n; i++)
   {
      p = (f)( _array, sel, i);
#if BREAK_FOR_AMBER
      if( i == 0 || i == 100)
         __mfspr( 1023);
#endif
      (*objc_call)( p, @selector( operate));
      (*objc_call)( p, @selector( annihilate));
   }
}

#endif


#if USE_CORE_FOUNDATION

- (void) operateAnnihilateFastest
{
   IMP            lastOpIMP[ 8];
   IMP            lastAnIMP[ 8];
   Class          lastIsa[ 8];
   Class          thisIsa;
   unsigned int   index;
   void	          *(*f)();
   int            n;
   int            i;
   id             p;
   IMP            (*p_class_lookupMethod)( Class, SEL);

   p_class_lookupMethod = class_lookupMethod;

   f   =  (void *) CFArrayGetValueAtIndex;
   n   = [_array count];

   for( i = 0; i < n; i++)
   {
      p = (f)( _array, i);
      
      thisIsa = _isa( p);
      index   = ((unsigned long) thisIsa >> 4) & 7; 

      if( lastIsa[ index] != thisIsa)
      {
         if( ! (lastOpIMP[ index] = (*p_class_lookupMethod)( thisIsa, @selector( operate))))
            [NSException raise:NSGenericException
                        format:@"No operate method on class %s", 
               ((struct objc_class *) thisIsa)->name];
         if( ! (lastAnIMP[ index] = (*p_class_lookupMethod)( thisIsa, @selector( annihilate))))
            [NSException raise:NSGenericException
                        format:@"No annihilate method on class %s", 
               ((struct objc_class *) thisIsa)->name];
         lastIsa[ index] = thisIsa;
      }
      (*lastOpIMP[ index])( p, @selector( operate));
      (*lastAnIMP[ index])( p, @selector( annihilate));
   }
}

#else


- (void) operateAnnihilateFastest
{
   IMP            lastOpIMP[ 8];
   IMP            lastAnIMP[ 8];
   Class          lastIsa[ 8];
   Class          thisIsa;
   unsigned int   index;
   SEL            sel;
   IMP            f;
   int            n;
   int            i;
   id             p;
   IMP            (*p_class_lookupMethod)( Class, SEL);

   sel = @selector( objectAtIndex:);
   f   = [_array methodForSelector:sel];
   n   = [_array count];

   for( i = 0; i < n; i++)
   {
      p = (f)( _array, sel, i);
      
      thisIsa = _isa( p);
      index   = ((unsigned long) thisIsa >> 4) & 7; 

      if( lastIsa[ index] != thisIsa)
      {
         if( ! (lastOpIMP[ index] = (*p_class_lookupMethod)( thisIsa, @selector( operate))))
            [NSException raise:NSGenericException
                        format:@"No operate method on class %s", 
               ((struct objc_class *) thisIsa)->name];
         if( ! (lastAnIMP[ index] = (*p_class_lookupMethod)( thisIsa, @selector( annihilate))))
            [NSException raise:NSGenericException
                        format:@"No annihilate method on class %s", 
               ((struct objc_class *) thisIsa)->name];
         lastIsa[ index] = thisIsa;
      }
      (*lastOpIMP[ index])( p, @selector( operate));
      (*lastAnIMP[ index])( p, @selector( annihilate));
   }
}


#endif



#if USE_CORE_FOUNDATION

- (void) operateAnnihilateFastestWorstCase
{
   IMP            lastOpIMP[ 8];
   IMP            lastAnIMP[ 8];
   Class          lastIsa[ 8];
   Class          thisIsa;
   unsigned int   index;
   void	          *(*f)();
   int            n;
   int            i;
   id             p;

   f   =  (void *) CFArrayGetValueAtIndex;
   n   = [_array count];

   for( i = 0; i < n; i++)
   {
      p = (f)( _array, i);
      
      thisIsa = _isa( p);
      index   = ((unsigned long) thisIsa >> 4) & 7; 

      if( lastIsa[ index] != thisIsa)
      {
      }
      if( ! (lastOpIMP[ index] = class_lookupMethod( thisIsa, @selector( operate))))
         [NSException raise:NSGenericException
                     format:@"No operate method on class %s", 
            ((struct objc_class *) thisIsa)->name];
      if( ! (lastAnIMP[ index] = class_lookupMethod( thisIsa, @selector( annihilate))))
         [NSException raise:NSGenericException
                     format:@"No annihilate method on class %s", 
            ((struct objc_class *) thisIsa)->name];
      lastIsa[ index] = thisIsa;
      (*lastOpIMP[ index])( p, @selector( operate));
      (*lastAnIMP[ index])( p, @selector( annihilate));
   }
}

#else


- (void) operateAnnihilateFastestWorstCase
{
   IMP            lastOpIMP[ 8];
   IMP            lastAnIMP[ 8];
   Class          lastIsa[ 8];
   Class          thisIsa;
   unsigned int   index;
   SEL            sel;
   IMP            f;
   int            n;
   int            i;
   id             p;

   sel = @selector( objectAtIndex:);
   f   = [_array methodForSelector:sel];
   n   = [_array count];

   for( i = 0; i < n; i++)
   {
      p = (f)( _array, sel, i);
      
      thisIsa = _isa( p);
      index   = ((unsigned long) thisIsa >> 4) & 7; 

      if( lastIsa[ index] != thisIsa)
      {
      }
      if( ! (lastOpIMP[ index] = class_lookupMethod( thisIsa, @selector( operate))))
         [NSException raise:NSGenericException
                     format:@"No operate method on class %s", 
            ((struct objc_class *) thisIsa)->name];
      if( ! (lastAnIMP[ index] = class_lookupMethod( thisIsa, @selector( annihilate))))
         [NSException raise:NSGenericException
                     format:@"No annihilate method on class %s", 
            ((struct objc_class *) thisIsa)->name];
      lastIsa[ index] = thisIsa;
      (*lastOpIMP[ index])( p, @selector( operate));
      (*lastAnIMP[ index])( p, @selector( annihilate));
   }
}


#endif


@end


int main (int argc, const char * argv[]) 
{
   NSAutoreleasePool   *pool;
   PowerContainer      *container;
   unsigned int        i;
   id                  p;
   unsigned int        count1, count2, count3;
   Stopwatch           *watch;
   BOOL                sleep_flag;

   sleep_flag = NO;
   if( argc > 1)
      sleep_flag = YES;
   
pool = [[NSAutoreleasePool alloc] init];

   watch = [[Stopwatch alloc] init];
 
   NSLog( @"Preparing");
   container = [[PowerContainer alloc] init];
   p         = nil;  // keep compiler happy
   
   count1 = count2 = count3 = 0;
   
   // fill container with objects
   // container with references... 
   for( i = 0; i < OBJECTS; i++)
   {
      switch( rand() % 3)
      {
      case 0 : p = [[Dummy1 alloc] init]; count1++; break;
      case 1 : p = [[Dummy2 alloc] init]; count2++; break;
      case 2 : p = [[Dummy3 alloc] init]; count3++;break;
      }
      [container addObject:p];
      [p release]; // pedantic
   }
   NSLog( @"Objects added %u + %u + %d = %u", count1, count2, count3, i);


   if( sleep_flag) 
   {
      sleep( 9);
      NSLog( @"Starts in one second"); 
   }
   // warm up caches 
   for( i = 0; i < 2; i++) // twice == VOODOO!!
      [container warmup];

  if( sleep_flag)
     sleep( 1);

#if 1 
   [watch startAndLog:@"operateAnnhilateNaive"]; 
   for( i = 0; i < LOOPS; i++)
      [container operateAnnihilateNaive];
   [watch stopAndLog];
#endif
 
#if 1 
   [watch startAndLog:@"operateAnnhilateNaiveCore"]; 
   for( i = 0; i < LOOPS; i++)
      [container operateAnnihilateNaiveCore];
   [watch stopAndLog];
#endif 

#if 1 
   [watch startAndLog:@"operateAnnihilate"]; 
   for( i = 0; i < LOOPS; i++)
      [container operateAnnihilate];
   [watch stopAndLog];
#endif 

#if 1 
   [watch startAndLog:@"operateAnnihilateFast"]; 
   for( i = 0; i < LOOPS; i++)
      [container operateAnnihilateFast]; // :objc_msgSend];
   [watch stopAndLog];
#endif

#if 1 
   [watch startAndLog:@"operateAnnihilateFastest"]; 
   for( i = 0; i < LOOPS; i++)
      [container operateAnnihilateFastest];
   [watch stopAndLog]; 
#endif

#if 1 
   [watch startAndLog:@"operateAnnihilateFastestWorstCase"]; 
   for( i = 0; i < LOOPS; i++)
      [container operateAnnihilateFastestWorstCase];
   [watch stopAndLog]; 
#endif

   if( sleep_flag)
      sleep( 10);

   [pool release];
   return 0;
}
