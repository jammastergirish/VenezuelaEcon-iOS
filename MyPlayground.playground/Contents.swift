//: Playground - noun: a place where people can play

import UIKit

let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

dateFormatter.date(from: "2015-03-02")

dateFormatter.date(from: "1992-05-01")

dateFormatter.date(from: "1992-05-02")

dateFormatter.date(from: "1992-05-03")

dateFormatter.date(from: "1992-05-04")

dateFormatter.date(from: "1992-05-05")


dateFormatter.locale = Locale(identifier: "en_US_POSIX")


dateFormatter.date(from: "2015-03-02")

dateFormatter.date(from: "1992-05-01")

dateFormatter.date(from: "1992-05-02")

dateFormatter.date(from: "1992-05-03")

dateFormatter.date(from: "1992-05-04")

dateFormatter.date(from: "1992-05-05")