//
//  AppDelegate.swift
//  Sp22_Message_App
//
//  Created by Trey Meares on 4/4/22.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        ) 
//            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//                if error != nil || user == nil {
//                  // Show the app's signed-out state.
//                } else {
//                  // Show the app's signed-in state.
//                }
//            }
//
        
        return true
    }

    func application(
                _ app: UIApplication,
                open url: URL,
                options: [UIApplication.OpenURLOptionsKey : Any] = [:]
            ) -> Bool {
                let isHandledByGoogleSignInSDK = GIDSignIn.sharedInstance.handle(url)

                  let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
                  let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
                  let isHandledByFacebookSignInSDK = ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
                  
                  return isHandledByGoogleSignInSDK ||  isHandledByFacebookSignInSDK
                }


}
