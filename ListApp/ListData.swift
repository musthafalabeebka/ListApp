// MARK: - ListData View
import SwiftUI
import CoreData

struct ListData: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    var employeeToEdit: Employee?
    
    @State private var empName: String = ""
    @State private var empAge: Int = 0
    
    var isEditMode: Bool {
        employeeToEdit != nil
    }
    
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
                
                Button(action: saveEmployee) {
                    Text(isEditMode ? "Update Employee" : "Add Employee")
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
            .navigationTitle(isEditMode ? "Edit Employee" : "Add Employee")
            .onAppear {
                if let employee = employeeToEdit {
                    empName = employee.empName ?? ""
                    empAge = Int(employee.empAge)
                }
            }
        }
    }
    
    private func saveEmployee() {
        if let employee = employeeToEdit {
            // Update existing employee
            employee.empName = empName
            employee.empAge = Int64(empAge)
        } else {
            // Create new employee
            let newEmployee = Employee(context: viewContext)
            newEmployee.empName = empName
            newEmployee.empAge = Int64(empAge)
        }
        
        do {
            try viewContext.save()
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
