//
//  AppDelegate.swift
//  Can You Make It To 1000?
//
//  Created by William Miller on 2/12/20.
//  Copyright © 2020 William Miller. All rights reserved.
//

import UIKit
import GoogleMobileAds
import ReplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var interstitialAd: GADInterstitial?
    var rewardedAd: GADRewardedAd?
    var rpPreviewViewControler: RPPreviewViewController!
    
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func createInterstitialAd() {
        let ad = GADInterstitial(adUnitID: Constants.interstitialAdId)
        ad.load(GADRequest())
        interstitialAd = ad
    }
    
    func createRewardedAds() {
        rewardedAd = GADRewardedAd(adUnitID: Constants.rewardAdId)
        rewardedAd?.load(GADRequest())
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // To show the dialog box permission
        startRecording()
        
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(4, forKey: "gamesTillAd")
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        checkNotificationPermission()
        
        createInterstitialAd()
        createRewardedAds()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func checkNotificationPermission() {
        // Request Notification Settings
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                // Permissions for local notification
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                    
                    if error == nil && success {
                        self.createLocalNotification()
                    } else {
                        print("something went wrong or we don't have permission")
                    }
                }
            case .authorized:
                self.createLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                self.createLocalNotification()

            case .ephemeral:
                break
            @unknown default:
                break
            }
        }
    }
    
    func createLocalNotification() {
        let defaults = UserDefaults.standard
        var identifier = ""
        if let previousIdentifier = defaults.value(forKey: "notification_identifier") as? String {
            identifier = previousIdentifier
        } else {
            identifier = UUID().uuidString
            defaults.set(identifier, forKey: "notification_identifier")
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Make it to $1000 before the prize pool runs out."
        content.sound = UNNotificationSound(named: UNNotificationSoundName("Dook.mp3"))
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        dateComponents.minute = 1
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        // Create the request
        let request = UNNotificationRequest(identifier: identifier,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }

    // This is just for showing the permission dialog box. Actual recording ll take place in game view
    func startRecording() {
        let recorder = RPScreenRecorder.shared()
        
        recorder.startRecording{ [weak self] (error) in
            self?.stopRecording()
        }
    }
    
    func stopRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.stopRecording { preview, error in }
    }
}

