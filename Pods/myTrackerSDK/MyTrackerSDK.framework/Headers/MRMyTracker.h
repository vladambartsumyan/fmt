//
//  MRMyTracker.h
//  myTrackerSDK 1.6.4
//
//  Created by Timur Voloshin on 17.06.16.
//  Copyright © 2016 Mail.ru Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <myTrackerSDK/MRMyTrackerAttribution.h>

NS_ASSUME_NONNULL_BEGIN

@class MRMyTrackerParams;

@interface MRMyTracker : NSObject

+ (void)setAttributionDelegate:(nullable id <MRMyTrackerAttributionDelegate>)delegate;

+ (void)setAttributionDelegate:(nullable id <MRMyTrackerAttributionDelegate>)delegate delegateQueue:(nullable NSOperationQueue *)queue;

+ (void)setDebugMode:(BOOL)enabled;

+ (BOOL)isDebugMode;

+ (void)setEnabled:(BOOL)enabled;

+ (BOOL)isEnabled;

+ (NSString *)trackerVersion;

+ (nullable MRMyTrackerParams *)trackerParams;

+ (void)createTracker:(NSString *)trackerId;

+ (void)setupTracker;

+ (BOOL)trackEventWithName:(NSString *)name;

+ (BOOL)trackEventWithName:(NSString *)name eventParams:(nullable NSDictionary<NSString *, NSString *> *)eventParams;

+ (BOOL)trackLoginEvent;

+ (BOOL)trackLoginEventWithParams:(nullable NSDictionary<NSString *, NSString *> *)eventParams;

+ (BOOL)trackInviteEvent;

+ (BOOL)trackInviteEventWithParams:(nullable NSDictionary<NSString *, NSString *> *)eventParams;

+ (BOOL)trackRegistrationEvent;

+ (BOOL)trackRegistrationEventWithParams:(nullable NSDictionary<NSString *, NSString *> *)eventParams;

+ (BOOL)trackPurchaseWithProduct:(id)product transaction:(id)transaction;

+ (BOOL)trackPurchaseWithProduct:(id)product transaction:(id)transaction eventParams:(nullable NSDictionary<NSString *, NSString *> *)eventParams;

+ (BOOL)trackLevelAchieved;

+ (BOOL)trackLevelAchievedWithLevel:(nullable NSNumber *)level;

+ (BOOL)trackLevelAchievedWithLevel:(nullable NSNumber *)level eventParams:(nullable NSDictionary<NSString *, NSString *> *)eventParams;

@end

NS_ASSUME_NONNULL_END
