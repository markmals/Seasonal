import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [testCase(SeasonalTests.allTests)]
}
#endif
