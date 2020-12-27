# Seasonal

**Find the major solar events for a given year.**

Seasonal adds functionality to [`Calendar`](https://developer.apple.com/documentation/foundation/calendar) which returns the solstice and equinox dates for a given year.

## Usage

```swift
import Seasonal

let lastWinterSolstice: Date = Calendar.current.winterSolstice(for: 2019) // => 2019-12-22 04:19

let springEquinox: Date = Calendar.current.vernalEquinox(for: 2020) // => 2020-03-20 03:50
let summerSolstice: Date = Calendar.current.summerSolstice(for: 2020) // => 2020-06-20 21:43
let fallEquinox: Date = Calendar.current.atumnalEquinox(for: 2020) // => 2020-09-22 13:31
let winterSolstice: Date = Calendar.current.winterSolstice(for: 2020) // => 2020-12-21 10:03

let midwinter: Date = Calendar.current.midpoint(between: lastWinterSolstice, and: springEquinox) // => 2020-02-04 21:34
let midspring: Date = Calendar.current.midpoint(between: springEquinox, and: summerSolstice) // => 2020-05-05 17:46
let midsummer: Date = Calendar.current.midpoint(between: summerSolstice, and: fallEquinox) // => 2020-08-06 22:37
let midfall: Date = Calendar.current.midpoint(between: fallEquinox, and: winterSolstice) // => 2020-11-06 17:17
```

If you've obtained permissions for `CLLocation` location access, these methods will return the correct date for the device's hemisphere. They default to the the northern hemisphere if `CLLocation` location access is unavailable.

## License

Seasonal is available under the MIT license. See the LICENSE file for more info.

## Attribution

The main logic for Seasonal was adapted from astronomical algorithms by Jean Meeus, [seasons.js](http://jgiesen.de/astro/astroJS/seasons/seasons.js) by Juergen Giesen, and [equinox.go](https://github.com/xyproto/calendar/blob/d09b05246286e34b3e7f3d72302f369a2e2b7f54/equinox.go) by [Alexander F. Rødseth](https://github.com/xyproto).
