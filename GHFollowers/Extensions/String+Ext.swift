//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 4/30/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "ar")
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
    
    var convertToDisplayFormate: String {
        guard let date = convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormate()
    }
}
