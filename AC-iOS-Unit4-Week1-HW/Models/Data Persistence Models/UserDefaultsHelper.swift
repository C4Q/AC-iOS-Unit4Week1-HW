//
//  UserDefaultsHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    
    // Singleton design pattern
    private init() {}
    static let manager = UserDefaultsHelper()
    
    private let defaults = UserDefaults.standard
    
    private let key = "myDefaults"
    
    // Object to hold default values instead of making key-values for everything
    struct MyDefaults: Codable {
        let pickerPosition: Int
        let title: String
    }
    
    // Function to create a default setting
    func createDefaultSetting(value: MyDefaults) {
        do {
            let data = try PropertyListEncoder().encode(value)
            defaults.set(data, forKey: key)
            print("Successfully saved \(value.title) as starting category.")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Returns defaults if there are any
    func getValue() -> MyDefaults? {
        guard let data = defaults.data(forKey: "myDefaults") else { return nil }
        do {
            let myDefaults = try PropertyListDecoder().decode(MyDefaults.self, from: data)
            return myDefaults
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
