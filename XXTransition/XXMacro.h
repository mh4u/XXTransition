
//
//  XXMacro.h
//  XXNavigation
//
//  Created by 许洵 on 16/10/3.
//  Copyright © 2016年 许洵. All rights reserved.
//

#ifndef XXMacro_h
#define XXMacro_h

#ifdef DEBUG
#   define XXLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define XXLog(...)
#endif

#define weakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define strongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#endif /* XXMacro_h */
