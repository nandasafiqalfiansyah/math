import SwiftData
import Foundation

@Model
class CalcHistoryEntry {
    var timestamp: Date
    var expression: String
    var result: String
    // Optional relationship back to Calculator model for flexibility
    var calculator: Calculator?

    init(timestamp: Date = Date(), expression: String, result: String, calculator: Calculator? = nil) {
        self.timestamp = timestamp
        self.expression = expression
        self.result = result
        self.calculator = calculator
    }
}
