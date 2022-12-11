//
//  DMYDateFormatter.swift
//  PosterKit
//
//  Created by Павел Барташов on 10.12.2022.
//

import Foundation

public protocol DMYDateFormatterProtocol  {
    func format(date: Date) -> String
}

public struct DMYDateFormatter: DMYDateFormatterProtocol {

    // MARK: - Properties

    private var dayMonthDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"

        return formatter
    }

    private var dayMonthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"

        return formatter
    }

    // MARK: - LifeCicle

    public init() { }

    // MARK: - Metods

    public func format(date: Date) -> String {
        date.year == Date.now.year
        ? dayMonthDateFormatter.string(from: date)
        : dayMonthYearFormatter.string(from: date)
    }
}

fileprivate extension Date {
    var year: Int? {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year
    }
}
