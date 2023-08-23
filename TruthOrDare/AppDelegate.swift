//
//  AppDelegate.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "TruthOrDare")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var transactionObserver = TransactionObserver()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.checkForSavedSettings()
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

    private func checkForSavedSettings() {
        if UserDefaults.standard.value(forKey: "settings") == nil {
           
            print("Trying to set settings.")
            
            do {
                let settings = Settings()
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: settings, requiringSecureCoding: true)
                UserDefaults.standard.set(encodedData, forKey: "settings")
                print("Settings set successfully.")
            } catch {
                print(error)
                NSLog("Cannot set initial settings. Archiving data failed.")
                UserDefaults.standard.removeObject(forKey: "settings")
            }
        } else {
            print("Retrieved settings.")
            
            if let settings = Settings.retrieveSettings(), !TransactionManager.shared.isPremium  {
                settings.isChatGPTTruthEnabled = false
                settings.isChatGPTDareEnabled = false

                Settings.updateSettings(using: settings)
            }
        }
    }
}

