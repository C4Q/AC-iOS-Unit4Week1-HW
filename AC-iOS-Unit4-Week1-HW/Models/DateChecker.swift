//
//  DateChecker.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class DateChecker{
    private init(){}
    static let manager = DateChecker()
    
    func googleBooksAPIDateCheck(){
        
        let currentDate = Date()
        let secondsInADay = 86400
        let nextDay = currentDate.addingTimeInterval(TimeInterval(secondsInADay))
        
        if currentDate >= nextDay {
            //call GoogleBooks API
            //save GoogleBooks data to phone -> Archiver
            print("Time to call GoogleBooks API!")
        } else if currentDate < nextDay{
            print("call from Google Books data saved in phone")
        }
    }
    
    func NYTBestSellersAPIDateCheck(){
    
        //Date that you stored Data: compare this date to the expiration
        //THIS IS WHAT YOU MANIPULATE TO CHECK
        let DateOfStoredData = Date()
        //Calendar.current.date(byAdding: .day, value: 12, to: Date())!
        //Calendar.current.date(byAdding: .day, value: 5, to: Date())! //date to compare to expiration
        
        //Stored date broken down into components, array, based on the stored date
        var dateComponents = Calendar.current.dateComponents([.year, .weekday, .weekOfYear], from: DateOfStoredData)
        //overwriting the current weekday with the day I want to check against = Friday
        dateComponents.weekday = 6
        
        //Date in which the API will be called again
        var DayOfAPICallDateAsString = Calendar.current.date(from: dateComponents)! //
        //currentDate
        //let currentDate = Date()
        
        //This moves the expiration date to the following Friday
        let APICallDateFromSaturday = Calendar.current.date(byAdding: .day, value: 7, to: DayOfAPICallDateAsString)!
        
        //Check to see if the day is a Friday
        if DateOfStoredData >= DayOfAPICallDateAsString{
            //NYT Call
            print("NYT API call made")
            //make API call
            DayOfAPICallDateAsString = APICallDateFromSaturday //THIS MOVES THE EXPIRATION DATE TO THE FOLLOWING FRIDAY
        } else {
            //Archiver
            print("NYT data pulled from storage")
            //pull from archiver
        }
    }

}

