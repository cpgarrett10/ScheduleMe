//
//  LocationUtils.swift
//  ScheduleMe
//
//  Created by Dan Morain on 4/1/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}