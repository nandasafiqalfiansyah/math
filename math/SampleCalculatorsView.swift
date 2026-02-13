import SwiftUI
import SwiftData

@Model
final class Calculator {
    @Attribute(.unique) var name: String
    var version: String

    init(name: String, version: String) {
        self.name = name
        self.version = version
    }
}

@Model
final class CalcHistoryEntry {
    @Attribute(.unique) var id: UUID = UUID()
    var calculatorName: String
    var timestamp: Date = Date()

    init(calculatorName: String) {
        self.calculatorName = calculatorName
    }
}

struct SampleCalculatorsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    private let samples: [Calculator] = [
        Calculator(name: "Kalkulator Dasar", version: "1.0"),
        Calculator(name: "Kalkulator Ilmiah", version: "2.0"),
        Calculator(name: "Kalkulator Programmer", version: "1.5")
    ]

    var body: some View {
        NavigationStack {
            List(samples, id: \.name) { calc in
                HStack {
                    VStack(alignment: .leading) {
                        Text(calc.name).font(.headline)
                        Text("Versi: \(calc.version)").font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Tambahkan") {
                        add(calc)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Contoh Kalkulator")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Tutup") { dismiss() }
                }
            }
        }
    }

    private func add(_ sample: Calculator) {
        let newCalc = Calculator(name: sample.name, version: sample.version)
        context.insert(newCalc)
        try? context.save()
        dismiss()
    }
}

#Preview {
    SampleCalculatorsView()
        .modelContainer(for: [Calculator.self, CalcHistoryEntry.self], inMemory: true)
}
