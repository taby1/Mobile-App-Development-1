import Foundation

func isLeap(year:Int) -> Bool{
	return year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? true : false) : true) : false
}

let monthRef = [1:31, 2:28, 3:31, 4:30, 5:31, 6:30, 7:31, 8:31, 9:30, 10:31, 11:30]

func julianDate(year: Int, month:Int, day:Int) -> Int{
	let monthDays = (1..<month).reduce(0){($1==2 && isLeap(year)) ? $0 + 29 : $0 + monthRef[$1]!}
	let yearDays = (1900..<year).reduce(0){isLeap($1) ? $0 + 366: $0 + 365}
	return yearDays + monthDays + day
}

julianDate(1960, month:  9, day: 28)
julianDate(1900, month:  1, day: 1)
julianDate(1900, month: 12, day: 31)
julianDate(1901, month: 1, day: 1)
julianDate(1901, month: 1, day: 1) - julianDate(1900, month: 1, day: 1)
julianDate(2001, month: 1, day: 1) - julianDate(2000, month: 1, day: 1)

isLeap(1960)
isLeap(1900)
isLeap(2000)
