import SwiftUI
import CoreData

struct ListData: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss  // <- allows dismissing the sheet
    
    @State private var empName: String = ""
    @State private var empAge: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter Name")
                    .font(.headline)
                TextField("Employee Name", text: $empName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Enter Age")
                    .font(.headline)
                TextField("Employee Age", value: $empAge, formatter: NumberFormatter())
                    .padding()
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: addEmployee) {
                    Text("Add Employee")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(empName.isEmpty || empAge <= 0)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Employee")
        }
    }
    
    private func addEmployee() {
        let newEmployee = Employee(context: viewContext)
        newEmployee.empName = empName
        newEmployee.empAge = Int64(empAge)
        
        do {
            try viewContext.save()
            // Reset inputs
            empName = ""
            empAge = 0
            // Dismiss the sheet
            dismiss()
        } catch {
            print("Error saving employee: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let persistenceController = PersistenceController.preview
    return ListData()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
}
