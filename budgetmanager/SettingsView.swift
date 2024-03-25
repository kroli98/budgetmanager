//
//  SettingsView.swift
//  budgetmanager
//
//  Created by Kiss Roland on 25/03/2024.
//

import SwiftUI


struct SettingsView: View {
    @State private var userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
    @State private var spendingLimit = UserDefaults.standard.string(forKey: "SpendingLimit") ?? ""
    @State private var categories = UserDefaults.standard.array(forKey: "categories") as? [String] ?? [String]()
    @State private var newCategory = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Felhasználónév")) {
                    TextField("Írja be a felhasználónevét", text: $userName)
                    Button(action: {
                        // Save userName to UserDefaults
                        UserDefaults.standard.set(userName, forKey: "UserName")
                    }) {
                        Text("Felhasználónév mentése")
                    }
                    .disabled(userName.isEmpty)
                }

                Section(header: Text("Kiadási limit")) {
                    TextField("Adja meg a költési limitet", text: $spendingLimit)
                        .keyboardType(.decimalPad)
                    Button(action: {
                       
                        UserDefaults.standard.set(Double(spendingLimit) ?? 0.0, forKey: "SpendingLimit")
                    }) {
                        Text("Kiadási limit mentése")
                    }
                    .disabled(spendingLimit.isEmpty)
                }
                
                Section(header: Text("Kategóriák")) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                    .onDelete(perform: deleteCategory)

                    HStack {
                        TextField("Új kategória hozzáadása", text: $newCategory)
                        Button(action: {
                            addCategory()
                        }) {
                            Text("Hozzáad")
                        }
                    }
                }
            }
            .navigationBarTitle("Beállítások")
            .listStyle(GroupedListStyle())
            .navigationBarItems(trailing: EditButton())
            .gesture(TapGesture().onEnded({ _ in
                UIApplication.shared.endEditing()
            }))
        }
    }

    private func deleteCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
        UserDefaults.standard.set(categories, forKey: "categories")
    }

    private func addCategory() {
        categories.append(newCategory)
        newCategory = ""
        UserDefaults.standard.set(categories, forKey: "categories")
    }
}

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}



#Preview {
    SettingsView()
}
