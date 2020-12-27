// Equinox and solstice algorithms from Astronomical Algorithms by Jean Meeus
// Adapted from http://jgiesen.de/astro/astroJS/seasons/seasons.js
// Adapted from https://github.com/xyproto/calendar/blob/d09b05246286e34b3e7f3d72302f369a2e2b7f54/equinox.go

import Foundation
import CoreLocation

extension Calendar {
    // MARK: - Helpers
    private enum SolarEvent {
        // One degree expressed in radians
        private static let degrees = Double.pi / 180.0
        private static func abs(_ x: Double) -> Double { if x < 0 { return -x } else { return x } }
        private static func roundf(_ x: Double) -> Double { (0.5 + x).rounded(.down) }
        private static func round(_ x: Double) -> Int { Int(roundf(x)) }

        private static func tableFormula(_ x: Double) -> Double {
            var result = 485 * cos(degrees * (324.96 + x * 1934.136))
            result += 203 * cos(degrees * (337.23 + x * 32964.467))
            result += 199 * cos(degrees * (342.08 + x * 20.186))
            result += 182 * cos(degrees * (27.85 + x * 445267.112))
            result += 156 * cos(degrees * (73.14 + x * 45036.886))
            result += 136 * cos(degrees * (171.52 + x * 22518.443))
            result += 77 * cos(degrees * (222.54 + x * 65928.934))
            result += 74 * cos(degrees * (296.72 + x * 3034.906))
            result += 70 * cos(degrees * (243.58 + x * 9037.513))
            result += 58 * cos(degrees * (119.81 + x * 33718.147))
            result += 52 * cos(degrees * (297.17 + x * 150.678))
            result += 50 * cos(degrees * (21.02 + x * 2281.226))
            result += 45 * cos(degrees * (247.54 + x * 29929.562))
            result += 44 * cos(degrees * (325.15 + x * 31555.956))
            result += 29 * cos(degrees * (60.93 + x * 4443.417))
            result += 18 * cos(degrees * (155.12 + x * 67555.328))
            result += 17 * cos(degrees * (288.79 + x * 4562.452))
            result += 16 * cos(degrees * (198.04 + x * 62894.029))
            result += 14 * cos(degrees * (199.76 + x * 31436.921))
            result += 12 * cos(degrees * (95.39 + x * 14577.848))
            result += 12 * cos(degrees * (287.11 + x * 31931.756))
            result += 12 * cos(degrees * (320.81 + x * 34777.259))
            result += 9 * cos(degrees * (227.73 + x * 1222.114))
            result += 8 * cos(degrees * (15.45 + x * 16859.074))
            return result
        }

        private static func calculate(_ year: Int, _ monthFunc: (Double) -> Double) -> Date {
            let a = monthFunc((Double(year) - 2000.0) / 1000.0)
            let b = (a - 2451545.0) / 36525.0
            let c = (35999.373 * b - 2.47) * degrees
            let d = a + (0.00001 * tableFormula(b)) / (1.0 + 0.0334 * cos(c) + 0.0007 * cos(2 * c)) - (66.0 + Double(year - 2000) * 1.0) / 86400.0
            let e = roundf(d)
            let f = ((e - 1867216.25) / 36524.25).rounded(.down)
            let g = e + f - (f / 4).rounded(.down) + 1525.0
            let h = ((g - 122.1) / 365.25).rounded(.down)
            let i = 365.0 * h + (h / 4).rounded(.down)
            let j = ((g - i) / 30.6001).rounded(.down)
            let k = 24.0 * (d + 0.5 - e)
            
            var hour = Int(k.rounded(.down))
            var minute = Int(round((abs(k) - abs(k).rounded(.down)) * 60.0))
            
            if minute == 60 {
                minute = 0
                hour += 1
            }
            
            let components = DateComponents(
                year: year,
                month: Int(j - 1 - 12 * (j / 14).rounded(.down)),
                day: Int(roundf(g - i) - (30.6001 * j).rounded(.down)),
                hour: hour,
                minute: minute,
                second: 0,
                nanosecond: 0
            )
            
            return Calendar.current.date(from: components)!
        }
        
        static func northwardEquinox(for year: Int) -> Date {
            calculate(year) {
                let a = 2451623.80984
                let b = 365242.37404 * $0
                let c = 0.05169 * pow($0, 2)
                let d = 0.00411 * pow($0, 3)
                let e = 0.00057 * pow($0, 4)
                
                return a + b + c - d - e
            }
        }
        
        static func northernSolstice(for year: Int) -> Date {
            calculate(year) {
                let a = 2451716.56767
                let b = 365241.62603 * $0
                let c = 0.00325 * pow($0, 2)
                let d = 0.00888 * pow($0, 3)
                let e = 0.0003 * pow($0, 4)
                
                return a + b + c + d - e
            }
        }
        
        static func southwardEquinox(for year: Int) -> Date {
            calculate(year) {
                let a = 2451810.21715
                let b = 365242.01767 * $0
                let c = 0.11575 * pow($0, 2)
                let d = 0.00337 * pow($0, 3)
                let e = 0.00078 * pow($0, 4)
                
                return a + b - c + d + e
            }
        }

        static func southernSolstice(for year: Int) -> Date {
            calculate(year) {
                let a = 2451900.05952
                let b = 365242.74049 * $0
                let c = 0.06223 * pow($0, 2)
                let d = 0.00823 * pow($0, 3)
                let e = 0.00032 * pow($0, 4)
                
                return a + b - c - d + e
            }
        }
    }
    
    private var isSouthernHemisphere: Bool {
        if let location = CLLocationManager().location,
           location.coordinate.latitude.sign == .minus {
            return true
        }
        
        return false
    }
    
    // MARK: - Public API
    
    /**
     Returns the vernal equinox for the year specified as an `Int`.
     - Parameter year: The year of the vernal equinox.
     - Returns: The result of calculating the the vernal equinox.
     */
    public func vernalEquinox(for year: Int) -> Date {
        guard !isSouthernHemisphere else { return SolarEvent.southwardEquinox(for: year) }
        return SolarEvent.northwardEquinox(for: year)
    }
    
    /**
     Returns the summer solstice for the year specified as an `Int`.
     - Parameter year: The year of the summer solstice.
     - Returns: The result of calculating the the summer solstice.
     */
    public func summerSolstice(for year: Int) -> Date {
        guard !isSouthernHemisphere else { return SolarEvent.southernSolstice(for: year) }
        return SolarEvent.northernSolstice(for: year)
    }
    
    /**
     Returns the atumnal equinox for the year specified as an `Int`.
     - Parameter year: The year of the atumnal equinox.
     - Returns: The result of calculating the the atumnal equinox.
     */
    public func atumnalEquinox(for year: Int) -> Date {
        guard !isSouthernHemisphere else { return SolarEvent.northwardEquinox(for: year) }
        return SolarEvent.southwardEquinox(for: year)
    }
    
    /**
     Returns the winter solstice for the year specified as an `Int`.
     - Parameter year: The year of the winter solstice.
     - Returns: The result of calculating the the winter solstice.
     */
    public func winterSolstice(for year: Int) -> Date {
        guard !isSouthernHemisphere else { return SolarEvent.northernSolstice(for: year) }
        return SolarEvent.southernSolstice(for: year)
    }
    
    /**
     Returns the midpoint between two dates, to the minute.
     
     - Parameters:
         - initialDate: The starting date.
         - laterDate: The ending date.

     - Returns: The result of calculating the midpoint between the two dates.
     */
    public func midpoint(between initialDate: Date, and laterDate: Date) -> Date {
        let midpointDate = Date(timeIntervalSince1970:
            (initialDate.timeIntervalSince1970 + laterDate.timeIntervalSince1970) / 2
        )
        
        // Sanatize 30 second splits by removing the seconds component
        let components = dateComponents([.year, .month, .day, .hour, .minute], from: midpointDate)
        return date(from: components)!
    }
}
