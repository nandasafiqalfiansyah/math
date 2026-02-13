import SwiftUI
import SwiftData

struct CalculatorListView: View {
    @Environment(\.modelContext) private var context
    // Query existing calculators if the model exists; if not, this remains an empty list at compile time in absence of the model.
    @Query(sort: [SortDescriptor(\.name, order: .forward)]) private var calculators: [Calculator]

    var body: some View {
        NavigationStack {
            Group {
                if calculators.isEmpty {
                    ContentUnavailableView("No Calculators", systemImage: "plus.slash",
                                            description: Text("Tap + to add your first calculator."))
                } else {
                    List(calculators) { calc in
                        VStack(alignment: .leading) {
                            Text(calc.name)
                                .font(.headline)
                            if let last = (calc as? AnyObject)?.value(forKey: "lastResult") as? String, !last.isEmpty {
                                Text(last)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Calculators")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        addSampleCalculator()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Calculator")
                }
            }
        }
    }

    private func addSampleCalculator() {
        // Try to create a Calculator with a name property if available.
        // This assumes `Calculator` has an initializer `init(name:)` or default init; adjust as needed later.
        if let calculatorType = Calculator.self as? Any.Type {
            // Best-effort: attempt to initialize via default init, then set name via KVC if possible.
            if let calc = (calculatorType as? NSObject.Type)?.init() {
                _ = (calc as AnyObject).setValue("New Calculator", forKey: "name")
                context.insert(calc as! any PersistentModel)
                try? context.save()
            }
        }
    }
}

#Preview {
    CalculatorListView()
        .modelContainer(for: [Calculator.self, CalcHistoryEntry.self], inMemory: true)
}
