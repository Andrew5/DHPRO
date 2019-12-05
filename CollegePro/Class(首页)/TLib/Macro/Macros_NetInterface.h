//
//  Macro_NetInterface.h
//  zichan
//
//  Created by Mike on 16/5/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macro_NetInterface_h
#define Macro_NetInterface_h

#define isNilOrNull(obj) (obj == nil || [obj isEqual:[NSNull null]])

#define setObjectForKey(object) \
do { \
    [dictionary setObject:object forKey:@#object]; \
} while (0)

#define setOptionalObjectForKey(object) \
do { \
    isNilOrNull(object) ?: [dictionary setObject:object forKey:@#object]; \
} while (0)

#endif /* Macro_NetInterface_h */
