//
//  BaseMarcos.h
//  WASUtility
//
//  Created by allen.wang on 9/17/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#ifndef sqr
#define sqr(a) ((a) * (a))
#endif

#ifndef min
#define min(a, b) MIN(a, b)
#endif

#ifndef max
#define max(a, b) MAX(a, b)
#endif

#ifndef clamp01 //（0-1）区间
#define clamp01(value) max(0.0f, min(1.0f, value))
#endif


#ifndef __TRIGGER_DEBUGGER
#ifndef FELASOLD_RELEASE_FUNC
#define __TRIGGER_DEBUGGER() { }
#endif
#endif


#ifndef WhereLog
#define WhereLog(value) NSLog(@"function: %s, file: %s, line: %d, msg: %@", __PRETTY_FUNCTION__, __FILE__, __LINE__, value)
#endif
#ifndef WhereLog0
#define WhereLog0() NSLog(@"[%@ %@]", [self class], NSStringFromSelector(_cmd))
#endif
#ifndef WhereLog1
#define WhereLog1(value) NSLog(@"[%@ %@] %@", [self class], NSStringFromSelector(_cmd), value)
#endif
#ifndef WhereLog2
#define WhereLog2(key, value) NSLog(@"[%@ %@] %@: %@", [self class], NSStringFromSelector(_cmd), key, value)
#endif
#ifndef WhereLogN
#define WhereLogN(msg, args...) NSLog([NSString stringWithFormat:@"[%@ %@] %@", [self class], NSStringFromSelector(_cmd), msg], ## args)
#endif


#ifndef __FAIL

// We use usleep() to make sure NSLog buffers are flushed.
// Is there a better way to do this?
#define __FAIL(msg, args...) { \
NSLog(msg, ## args); \
WhereLog(@"failed."); \
__TRIGGER_DEBUGGER(); \
usleep(1000 * 1000); \
exit(-1); \
}

#endif


#ifndef __NOT_IMPLEMENTED
#define __NOT_IMPLEMENTED() [self doesNotRecognizeSelector:_cmd];
#endif


#ifndef deallocProperty
// Use temp local to isolate dealloc loops.
#define deallocProperty(value) { \
if (value != nil) { \
id temp = value; \
value = nil; \
[temp release]; \
} \
}
#endif


#ifndef deallocPtr
#define deallocPtr(ptr) { \
if (ptr != NULL) { \
void* _temp = ptr; \
ptr = NULL; \
free(_temp); \
} \
}
#endif


#ifndef safeMalloc
#define safeMalloc(ptr, size) { ptr = malloc(size); if (ptr == NULL) { __FAIL(@"%@ could not be allocated", @"ptr"); } }
#endif


#ifndef safeCalloc
#define safeCalloc(ptr, size1, size2) { ptr = calloc(size1, size2); if (ptr == NULL) { __FAIL(@"%@ could not be allocated", @"ptr"); } }
#endif
