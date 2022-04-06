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
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
//    guard error == nil else {
//        if let error = error {
//            print("failed to sign in with Google")
//        }
//        return
//        }
//        guard let authen = user.authentication else {return }
//        let cred = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//    }
    
    func application(
                _ app: UIApplication,
                open url: URL,
                options: [UIApplication.OpenURLOptionsKey : Any] = [:]
            ) -> Bool {

            let urlString = url.absoluteString
            if urlString.contains("fb"){
                ApplicationDelegate.shared.application(
                    app,
                    open: url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                )
            }
            else{

            }
                return GIDSignIn.sharedInstance.handle(url)
            }
    
}



