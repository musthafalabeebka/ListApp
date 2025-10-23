import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Employee.empName, ascending: true)],
        animation: .default
    )
    private var employees: FetchedResults<Employee>
    
    @State private var searchText: String = ""
    @State private var showingAddEmployee = false
    @State private var selectedEmployee: Employee?
    
    // Filter employees in memory based on search text
    private var filteredEmployees: [Employee] {
        if searchText.isEmpty {
            return Array(employees)
        } else {
            return employees.filter { emp in
                let matchesName = emp.empName?.localizedCaseInsensitiveContains(searchText) ?? false
                let matchesAge = Int64(searchText) == emp.empAge
                return matchesName || matchesAge
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search by name or age", text: $searchText)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding([.horizontal, .top])
                
                // Employee list
                List {
                    ForEach(filteredEmployees) { employee in
                        VStack(alignment: .leading) {
                            Text(employee.empName ?? "Unknown")
                                .font(.headline)
                            Text("Age: \(employee.empAge)")
                                .font(.subheadline)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedEmployee = employee
                        }
                    }
                    .onDelete(perform: deleteEmployee)
                }
            }
            .navigationTitle("Employees")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingAddEmployee.toggle() }) {
                        Label("Add Employee", systemImage: "plus")
                    }
                }
            }
            // Show ListData view as a modal for adding
            .sheet(isPresented: $showingAddEmployee) {
                ListData()
                    .environment(\.managedObjectContext, viewContext)
            }
            // Show ListData view as a modal for editing
            .sheet(item: $selectedEmployee) { employee in
                ListData(employeeToEdit: employee)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    // Delete employee function
    private func deleteEmployee(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredEmployees[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

