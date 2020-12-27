import Foundation
import XCTest
import Seasonal

final class SeasonalTests: XCTestCase {
    // MARK: - Data & Utilities
    private let calendar = Calendar.current
    
    // Data from: https://en.wikipedia.org/wiki/Solstice
    private let springEquinoxes = [
        DateComponents(year: 2015, month: 3, day: 20, hour: 22, minute: 45),
        DateComponents(year: 2016, month: 3, day: 20, hour: 4, minute: 31),
        DateComponents(year: 2017, month: 3, day: 20, hour: 10, minute: 29),
        DateComponents(year: 2018, month: 3, day: 20, hour: 16, minute: 15),
        DateComponents(year: 2019, month: 3, day: 20, hour: 21, minute: 58),
        DateComponents(year: 2020, month: 3, day: 20, hour: 3, minute: 50),
        DateComponents(year: 2021, month: 3, day: 20, hour: 9, minute: 37),
        DateComponents(year: 2022, month: 3, day: 20, hour: 15, minute: 33),
        DateComponents(year: 2023, month: 3, day: 20, hour: 21, minute: 25),
        DateComponents(year: 2024, month: 3, day: 20, hour: 3, minute: 7),
        DateComponents(year: 2025, month: 3, day: 20, hour: 9, minute: 2)
    ]
    
    private let summerSolstices = [
        DateComponents(year: 2015, month: 6, day: 21, hour: 16, minute: 38),
        DateComponents(year: 2016, month: 6, day: 20, hour: 22, minute: 35),
        DateComponents(year: 2017, month: 6, day: 21, hour: 4, minute: 25),
        DateComponents(year: 2018, month: 6, day: 21, hour: 10, minute: 7),
        DateComponents(year: 2019, month: 6, day: 21, hour: 15, minute: 54),
        DateComponents(year: 2020, month: 6, day: 20, hour: 21, minute: 43),
        DateComponents(year: 2021, month: 6, day: 21, hour: 3, minute: 32),
        DateComponents(year: 2022, month: 6, day: 21, hour: 9, minute: 14),
        DateComponents(year: 2023, month: 6, day: 21, hour: 14, minute: 58),
        DateComponents(year: 2024, month: 6, day: 20, hour: 20, minute: 51),
        DateComponents(year: 2025, month: 6, day: 21, hour: 2, minute: 42)
    ]
    
    private let fallEquinoxes = [
        DateComponents(year: 2015, month: 9, day: 23, hour: 8, minute: 20),
        DateComponents(year: 2016, month: 9, day: 22, hour: 14, minute: 21),
        DateComponents(year: 2017, month: 9, day: 22, hour: 20, minute: 2),
        DateComponents(year: 2018, month: 9, day: 23, hour: 1, minute: 54),
        DateComponents(year: 2019, month: 9, day: 23, hour: 7, minute: 50),
        DateComponents(year: 2020, month: 9, day: 22, hour: 13, minute: 31),
        DateComponents(year: 2021, month: 9, day: 22, hour: 19, minute: 21),
        DateComponents(year: 2022, month: 9, day: 23, hour: 1, minute: 4),
        DateComponents(year: 2023, month: 9, day: 23, hour: 6, minute: 50),
        DateComponents(year: 2024, month: 9, day: 22, hour: 12, minute: 44),
        DateComponents(year: 2025, month: 9, day: 22, hour: 18, minute: 20)
    ]
    
    private let winterSolstices = [
        DateComponents(year: 2015, month: 12, day: 22, hour: 4, minute: 48),
        DateComponents(year: 2016, month: 12, day: 21, hour: 10, minute: 45),
        DateComponents(year: 2017, month: 12, day: 21, hour: 16, minute: 29),
        DateComponents(year: 2018, month: 12, day: 21, hour: 22, minute: 22),
        DateComponents(year: 2019, month: 12, day: 22, hour: 4, minute: 19),
        DateComponents(year: 2020, month: 12, day: 21, hour: 10, minute: 3),
        DateComponents(year: 2021, month: 12, day: 21, hour: 15, minute: 59),
        DateComponents(year: 2022, month: 12, day: 21, hour: 21, minute: 48),
        DateComponents(year: 2023, month: 12, day: 22, hour: 3, minute: 28),
        DateComponents(year: 2024, month: 12, day: 21, hour: 9, minute: 20),
        DateComponents(year: 2025, month: 12, day: 21, hour: 15, minute: 3)
    ]
        
    private func test(_ solarEventDatabase: [DateComponents], _ eventCalculator: (Int) -> Date) {
        solarEventDatabase.forEach { dateComponents in
            let databaseDate = calendar.date(from: dateComponents)!
            let solarEvent = eventCalculator(dateComponents.year!)
            XCTAssertDatesEqual(databaseDate, solarEvent)
        }
    }
    
    // MARK: - Test Methods
    func testSpringEquinoxes() {
        test(springEquinoxes, calendar.vernalEquinox)
    }
    
    func testSummerSolstices() {
        test(summerSolstices, calendar.summerSolstice)
    }
    
    func testFallEquinoxs() {
        test(fallEquinoxes, calendar.atumnalEquinox)
    }
    
    func testWinterSolstices() {
        test(winterSolstices, calendar.winterSolstice)
    }
    
    static var allTests = [
        ("testSpringEquinoxes", testSpringEquinoxes),
        ("testSummerSolstices", testSummerSolstices),
        ("testFallEquinoxs", testFallEquinoxs),
        ("testWinterSolstices", testWinterSolstices)
    ]
}

func XCTAssertDatesEqual(_ lhs: Date, _ rhs: Date) {
    let calendar = Calendar.current
    
    let lhsComponents = calendar.dateComponents([.year, .month, .day, .hour], from: lhs)
    let lhsMinutes = calendar.component(.minute, from: lhs)
    
    let rhsComponents = calendar.dateComponents([.year, .month, .day, .hour], from: rhs)
    let rhsMinutes = calendar.component(.minute, from: rhs)
    
    let componentsMatch = lhsComponents == rhsComponents
    let minuteThreshhold = 1
    let minutesWithinRange = (lhsMinutes >= (rhsMinutes - minuteThreshhold)) && (lhsMinutes <= (rhsMinutes + minuteThreshhold))
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    let lhsFormatted = formatter.string(from: lhs)
    let rhsFormatted = formatter.string(from: rhs)
    
    XCTAssert(componentsMatch && minutesWithinRange, "\(lhsFormatted) ≠ \(rhsFormatted)")
}
