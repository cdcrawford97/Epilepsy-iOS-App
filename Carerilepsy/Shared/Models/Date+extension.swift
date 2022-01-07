//
//  Date+extension.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 02/08/2021.
//

import Foundation

extension Date {

    
    func customDate() -> String {
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("d MMM, EEEE")
        
        return dateFormatter.string(from: self)
    }
    
    func seizureListCustomDate() -> String {
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("d MMM, h:mm a")
        
        return dateFormatter.string(from: self)
    }
    
    func shortDayDate() -> String {
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
        
        return dateFormatter.string(from: self)
    }
    
    func DayNumber() -> String {
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd")
        
        return dateFormatter.string(from: self)
    }
    
    func monthShort() -> String {
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
        
        return dateFormatter.string(from: self)
    }
    
    func yearFull() -> String {
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        
        return dateFormatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    func startOf30Days() -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: -31), to: Date().endOfDay())!
    }
    
    func startOf60Days() -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: -61), to: Date().endOfDay())!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func startOfWeek() -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: -7), to: Date().endOfDay())!
    }
    
    func startOfDay() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
    
    func endOfDay() -> Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
    }
    
    func daysOfWeek() -> [String] {
        var dates = [String]()
        let date = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
        for num in 0..<7 {
            dates.append((Calendar.current.date(byAdding: .day, value: num, to: date)!).shortDayDate())
        }
        return dates
    }
    
    func last30DaysFirst15() -> [String] {
        var dates = [String]()
        let date = Calendar.current.date(byAdding: DateComponents(day: -29), to: Date())!
        for num in 0..<15 {
            dates.append((Calendar.current.date(byAdding: .day, value: num, to: date)!).DayNumber())
        }
        return dates
    }
    
    func last30DaysSecond15() -> [String] {
        var dates = [String]()
        let date = Calendar.current.date(byAdding: DateComponents(day: -14), to: Date())!
        for num in 0..<15 {
            dates.append((Calendar.current.date(byAdding: .day, value: num, to: date)!).DayNumber())
        }
        return dates
    }
    
    func startOfYear() -> Date {
        let year = Calendar.current.component(.year, from: Date())
        // Get the first day of current year
        return Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!
    }
    
    func EndOfYear() -> Date {
        
        let year = Calendar.current.component(.year, from: Date())
        let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1))
        return Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear!)!
    }
    
    func getWeekdayInt(dayOfWeek: String) -> Int {
        switch dayOfWeek {
        case "Mon":
            return 2
        case "Tue":
            return 3
        case "Wed":
            return 4
        case "Thu":
            return 5
        case "Fri":
            return 6
        case "Sat":
            return 7
        case "Sun":
            return 1
        default:
            print("dayOfWeek doesn't match any valid cases")
            return 0
        }
    }
    
}
