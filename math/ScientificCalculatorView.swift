import SwiftUI
import SwiftData

struct ScientificCalculatorView: View {
    @Environment(\.modelContext) private var context
    let calculator: Calculator

    @State private var input: String = "0"
    @State private var result: String = "0"

    var body: some View {
        VStack(spacing: 16) {
            TextField("Input angka", text: $input)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)

            HStack {
                Button("sin") { applyUnary("sin") { sin($0) } }
                Button("cos") { applyUnary("cos") { cos($0) } }
                Button("x²") { applyUnary("x²") { $0 * $0 } }
                Button("x^3") { applyUnary("x³") { $0 * $0 * $0 } }
            }
            .buttonStyle(.bordered)

            HStack {
                Button("√x") { applyUnary("√x") { sqrt(max(0, $0)) } }
                Button("1/x") { applyUnary("1/x") { $0 == 0 ? .infinity : 1 / $0 } }
                Button("e^x") { applyUnary("e^x") { exp($0) } }
                Button("ln x") { applyUnary("ln") { log(max($0, 0.000001)) } }
            }
            .buttonStyle(.bordered)
            
            HStack {
                TextField("pow base", text: $input)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                Button("pow 2") { applyBinary("pow 2", secondInput: "2") { pow($0, $1) } }
                Button("pow 3") { applyBinary("pow 3", secondInput: "3") { pow($0, $1) } }
            }
            .buttonStyle(.bordered)

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

    private func applyUnary(_ opName: String, _ op: (Double) -> Double) {
        guard let x = Double(input.replacingOccurrences(of: ",", with: ".")) else { return }
        let y = op(x)
        let res = String(y)
        result = res
        let expr = "\(opName)(\(x))"
        let entry = CalcHistoryEntry(expression: expr, result: res, calculator: calculator)
        context.insert(entry)
        calculator.history.insert(entry, at: 0)
        try? context.save()
    }

    private func applyBinary(_ opName: String, secondInput: String, _ op: (Double, Double) -> Double) {
        guard let x = Double(input.replacingOccurrences(of: ",", with: ".")),
              let y = Double(secondInput.replacingOccurrences(of: ",", with: ".")) else { return }
        let resVal = op(x, y)
        let res = String(resVal)
        result = res
        let expr = "\(opName)(\(x), \(y))"
        let entry = CalcHistoryEntry(expression: expr, result: res, calculator: calculator)
        context.insert(entry)
        calculator.history.insert(entry, at: 0)
        try? context.save()
    }
}

#Preview {
    let calc = Calculator(name: "Kalkulator Ilmiah", version: "2.0", type: .scientific)
    return NavigationStack { ScientificCalculatorView(calculator: calc) }
        .modelContainer(for: [Calculator.self, CalcHistoryEntry.self], inMemory: true)
}
