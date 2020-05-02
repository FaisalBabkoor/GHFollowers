//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 4/30/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import Foundation

extension Date {
    func convertToMonthYearFormate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
