//
//  WelcomeView.swift
//  budgetmanager
//
//  Created by Kiss Roland on 2023. 05. 29..
//
import SwiftUI

struct WelcomeView: View {
    @Binding var isPresented: Bool
    @State private var userName = ""
    @State private var spendingLimit = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Felhasználónév")) {
                    TextField("Írja be a felhasználónevét", text: $userName)
                }

                Section(header: Text("Kiadási limit")) {
                    TextField("Adja meg a költési limitet", text: $spendingLimit)
                        .keyboardType(.decimalPad)
                }

                Button(action: {
                    UserDefaults.standard.set(userName, forKey: "UserName")
                    UserDefaults.standard.set(Double(spendingLimit) ?? 0.0, forKey: "SpendingLimit")
                    isPresented = false
                }) {
                    Text("Mentés és az alkalmazás használatának megkezdése")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .frame(height: 50)
                        .background(.brown)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                }
                .disabled(userName.isEmpty || spendingLimit.isEmpty)
                .listRowBackground(Color(.secondarySystemBackground))
                .listRowSeparator(.hidden)
                
            }
            .navigationBarTitle("Üdvözlet")
        }
    }
}


struct WelcomeView_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        WelcomeView(isPresented: $isPresented)
    }
}
