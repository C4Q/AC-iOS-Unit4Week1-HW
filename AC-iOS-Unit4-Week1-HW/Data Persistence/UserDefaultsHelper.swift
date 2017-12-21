//
//  UserDefaultsHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

// this will help with saving and retrieving user data from settings view controller

//save information from the settings page
//save the date for Google and NYTimes API calls

//
//struct UserDefaultsHelper {
//
//    //Singleton
//    static let manager = UserDefaultsHelper()
//    private init(){}
//
//    private let indexKey = "index"
//    private let dateKey = "date"
//    private let ranAtLeastOnceKey = "ranAtLeastOnce"
//
//
//    func getPickerIndex() -> Int? {
//        return Int(UserDefaults.standard.string(forKey: indexKey) ?? "0")
//    }
//    func getTomorrowDate() -> Date? {
//        return UserDefaults.standard.value(forKey: dateKey) as? Date
//    }
//    func didItRunAtLeastOnce() -> Bool? {
//        return UserDefaults.standard.bool(forKey: ranAtLeastOnceKey)
//    }
//
//    func setPickerIndex(to newIndex: String) {
//        UserDefaults.standard.setValue(newIndex, forKey: indexKey)
//    }
//
//    func setTomorrowDate(to newDate: Date) {
//        UserDefaults.standard.setValue(newDate, forKey: dateKey)
//    }
//
//    func setRanAtLeastOnce(to newBool: Bool) {
//        UserDefaults.standard.setValue(newBool, forKey: ranAtLeastOnceKey)
//    }
//}


//struct ContactsUserDefaultsHelper {
//
//    //userDefaults for storing Categories
//    private init(){}
//    static let manager = ContactsUserDefaultsHelper()
//    static let categoryKey = "categoryKey"
//
//    func setCategoriesInSettingsPage(to preferredCategories: String) {
//        UserDefaults.standard.setValue(preferredCategories, forKey: UserDefaultsHelper.categoryKey)
//    }
////    var savedCategory: String? {
////        if let cat = UserDefaults.standard.value(forKey: UserDefaultsHelper.categoryKey) as? String {
////            return cat
////        }
////        return nil
////    }
//}

//After setting and storing, head to the appropriate VS to retrieve user defaults
struct DatesUserDefaultsHelper {
    
    //userDefaults for storing Dates of Google and NYT API Calls
    private init(){}
    static let manager = DatesUserDefaultsHelper()
    
    //set keys
    private var apiCallCheckKey = "apiCallCheck"
    private var googleBooksDateKey = "googleBooks"
    private var nytDateKey = "nytimes"
    
    
    
    //MARK: -API calls- Getting and storing the APICall if the first APICall has not happened yet
    //get
    func getDidFirstAPICallHappenYet() -> Bool {
        //used .string becaused a bool returns
        return UserDefaults.standard.bool(forKey: apiCallCheckKey)
    }
    //set
    func setDidAPICallHappenYet(to trueOrFalse: Bool){
        UserDefaults.standard.setValue(trueOrFalse, forKey: apiCallCheckKey)
    }
    
    
    

    //MARK: -Google API calls- Getting and storing the next days date for the calls
    //get
    func getNextDaysDateForGoogleAPICall() -> Date? {
        return UserDefaults.standard.value(forKey: googleBooksDateKey) as? Date
    }
    //set
    func setNextDaysDateForGoogleAPICall(to newGoogleDate: String){
        UserDefaults.standard.setValue(newGoogleDate, forKey: googleBooksDateKey)
    }
    
    
    
    
    //MARK: -NYTimes BestSeller API calls- Getting and storing the next Friday's date for weekly calls
    //get
    func getNextFridaysDateForNYTAPICall() -> Date? {
        return UserDefaults.standard.value(forKey: nytDateKey) as? Date
    }
    //set
    func setNextFridaysDateForNYTAPICall(to newNYTDate: String){
        UserDefaults.standard.setValue(newNYTDate, forKey: nytDateKey)
    }

}


