//
//  TimePeriod.swift
//  Registration
//
//  Created by Bulat Khabirov on 09.04.17.
//  Copyright © 2017 Bulat Khabirov. All rights reserved.
//

import UIKit
import RealmSwift

class TimePeriod: Object, Comparable {
    dynamic var value: String = "" {
        didSet {
            guard value.range(of: "\\d{2}:\\d{2}-\\d{2}:\\d{2}", options: .regularExpression) != nil else {
                value = ""
                return
            }
        }
    }
    
    convenience init?(stringValue: String) {
        guard stringValue.range(of: "\\d{2}:\\d{2}-\\d{2}:\\d{2}", options: .regularExpression) != nil else {
            return nil
        }
        
        self.init()
        value = stringValue
    }

    public static func <(lhs: TimePeriod, rhs: TimePeriod) -> Bool {
        return !(lhs >= rhs)
    }

    public static func <=(lhs: TimePeriod, rhs: TimePeriod) -> Bool {
        return lhs < rhs || lhs == rhs
    }

    public static func >=(lhs: TimePeriod, rhs: TimePeriod) -> Bool {
        return lhs == rhs || lhs > rhs
    }

    public static func >(lhs: TimePeriod, rhs: TimePeriod) -> Bool {
        guard !lhs.value.isEmpty, !rhs.value.isEmpty else {
            return lhs.value.characters.count > rhs.value.characters.count
        }

        let value1 = lhs.value.substring(to: lhs.value.index(lhs.value.startIndex, offsetBy: 5))
        let value2 = rhs.value.substring(to: rhs.value.index(rhs.value.startIndex, offsetBy: 5))

        guard let hours1 = Int(value1.substring(to: value1.index(value1.startIndex, offsetBy: 2))),
                let hours2 = Int(value2.substring(to: value2.index(value2.startIndex, offsetBy: 2))) else {
            return false
        }

        // Exception for making that 23:00 is less than 00:00
        if hours1 < 10 && hours2 > 10 {
            return true
        }
        
        if hours2 != hours1 {
            return hours1 > hours2
        } else {
            guard let minutes1 = Int(value1.substring(from: value1.index(value1.endIndex, offsetBy: -2))),
                  let minutes2 = Int(value2.substring(from: value2.index(value2.endIndex, offsetBy: -2))) else {
                return false
            }

            return minutes1 > minutes2
        }
    }

    public static func ==(lhs: TimePeriod, rhs: TimePeriod) -> Bool {
        return lhs.value == rhs.value
    }

}
