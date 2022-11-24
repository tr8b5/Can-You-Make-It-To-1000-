//
//  GADNativeExpressAdViewDelegate.h
//  Google Mobile Ads SDK
//
//  Copyright 2015 Google LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GADRequestError.h>

@class GADNativeExpressAdView;

/// Delegate methods for receiving GADNativeExpressAdView state change messages such as ad request
/// status and ad click lifecycle.
@protocol GADNativeExpressAdViewDelegate <NSObject>

@optional

#pragma mark Ad Request Lifecycle Notifications

/// Tells the delegate that the native express ad view successfully received an ad. The delegate may
/// want to add the native express ad view to the view hierarchy if it hasn't been added yet.
- (void)nativeExpressAdViewDidReceiveAd:(nonnull GADNativeExpressAdView *)nativeExpressAdView;

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)nativeExpressAdView:(nonnull GADNativeExpressAdView *)nativeExpressAdView
    didFailToReceiveAdWithError:(nonnull GADRequestError *)error;

#pragma mark Click-Time Lifecycle Notifications

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)nativeExpressAdViewWillPresentScreen:(nonnull GADNativeExpressAdView *)nativeExpressAdView;

/// Tells the delegate that the full screen view will be dismissed.
- (void)nativeExpressAdViewWillDismissScreen:(nonnull GADNativeExpressAdView *)nativeExpressAdView;

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling adViewWillPresentScreen:.
- (void)nativeExpressAdViewDidDismissScreen:(nonnull GADNativeExpressAdView *)nativeExpressAdView;

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately before this method is called.
- (void)nativeExpressAdViewWillLeaveApplication:
    (nonnull GADNativeExpressAdView *)nativeExpressAdView;

@end
