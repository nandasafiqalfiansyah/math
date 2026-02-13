import SwiftData

@Model
class Calculator {
    var name: String
    var version: String
    
    init(name: String = "Basic Calculator", version: String = "1.0") {
        self.name = name
        self.version = version
    }
}
