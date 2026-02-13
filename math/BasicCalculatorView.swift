import SwiftUI
import SwiftData

struct BasicCalculatorView: View {
    @Environment(\.modelContext) private var context
    let calculator: Calculator

    @State private var expression: String = ""
    @State private var result: String = "0"

    var body: some View {
        VStack(spacing: 16) {
            TextField("Expression (e.g. 2+3*4)", text: $expression)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)

            HStack {
                Button("Hitung") { compute() }
                    .buttonStyle(.borderedProminent)
                Button("Clear") { expression = ""; result = "0" }
                    .buttonStyle(.bordered)
            }

            Text("Hasil: \(result)")
                .font(.title2)
                .padding(.top, 8)

            List(calculator.history.sorted(by: { $0.timestamp > $1.timestamp })) { entry in
                VStack(alignment: .leading) {
                    Text("\(entry.expression) = \(entry.result)")
                    Text(entry.timestamp, style: .time).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .navigationTitle(calculator.name)
    }

    private func compute() {
        let trimmed = expression.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        // Very simple eval using NSExpression for demo purposes
        let value: String
        let exp = NSExpression(format: trimmed)
        if let number = exp.expressionValue(with: nil, context: nil) as? NSNumber {
            value = number.stringValue
        } else {
            value = "Error"
        }
        result = value
        let entry = CalcHistoryEntry(expression: trimmed, result: value, calculator: calculator)
        context.insert(entry)
        calculator.history.insert(entry, at: 0)
        try? context.save()
    }
}

#Preview {
    let calc = Calculator(name: "Kalkulator Dasar", version: "1.0", type: .basic)
    return NavigationStack { BasicCalculatorView(calculator: calc) }
        .modelContainer(for: [Calculator.self, CalcHistoryEntry.self], inMemory: true)
}
