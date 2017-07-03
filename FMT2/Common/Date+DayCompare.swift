import Foundation

extension Date {
    func equalDayTo(date: Date) -> Bool {
        
        let currCalendar = Calendar.current
        
        let dateCompanent1:DateComponents = currCalendar.dateComponents([.year,.month,.day], from: self)
        let dateCompanent2:DateComponents = currCalendar.dateComponents([.year,.month,.day], from: date)
        
        let date1WithoutTime:Date? = currCalendar.date(from: dateCompanent1)
        let date2WithoutTime:Date? = currCalendar.date(from: dateCompanent2)
        
        if (date1WithoutTime != nil) && (date2WithoutTime != nil)
        {
            let dateCompResult:ComparisonResult = date1WithoutTime!.compare(date2WithoutTime!)
            return dateCompResult == ComparisonResult.orderedSame
        } else {
            return false
        }
    }
    
    func afterDay(date: Date) -> Bool {
        let currCalendar = Calendar.current
        
        let dateCompanent1:DateComponents = currCalendar.dateComponents([.year,.month,.day], from: self)
        let dateCompanent2:DateComponents = currCalendar.dateComponents([.year,.month,.day], from: date)
        
        let date1WithoutTime:Date? = currCalendar.date(from: dateCompanent1)
        let date2WithoutTime:Date? = currCalendar.date(from: dateCompanent2)
        
        if (date1WithoutTime != nil) && (date2WithoutTime != nil) {
            return date1WithoutTime!.timeIntervalSince1970 > date2WithoutTime!.timeIntervalSince1970
        } else {
            return false
        }
    }
    
    func beforeDay(date: Date) -> Bool {
        let currCalendar = Calendar.current
        
        let dateCompanent1:DateComponents = currCalendar.dateComponents([.year,.month,.day], from: self)
        let dateCompanent2:DateComponents = currCalendar.dateComponents([.year,.month,.day], from: date)
        
        let date1WithoutTime:Date? = currCalendar.date(from: dateCompanent1)
        let date2WithoutTime:Date? = currCalendar.date(from: dateCompanent2)
        
        if (date1WithoutTime != nil) && (date2WithoutTime != nil) {
            return date1WithoutTime!.timeIntervalSince1970 < date2WithoutTime!.timeIntervalSince1970
        } else {
            return false
        }
    }
}
