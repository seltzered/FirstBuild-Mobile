//
//  Constants.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 10/15/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#ifndef FirstBuildMobile_Constants_h
#define FirstBuildMobile_Constants_h


#define _CHILLHUB

#ifdef CHILLHUB
    #define WIFI
#endif

FOUNDATION_EXPORT NSString *const FirebaseUrl;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]

#ifndef DEBUG
#   define NSLog(...);
#endif

#ifdef DEBUG
#   define EXPERIMENTAL_PRODUCTS
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

extern NSString * const FSTMenuItemSelectedNotification;
extern NSString * const FSTMenuItemHome ;

#endif

