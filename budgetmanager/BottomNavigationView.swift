//
//  BottomNavigationView.swift
//  budgetmanager
//
//  Created by Kiss Roland on 2023. 04. 23..
//
import SwiftUI
import CoreData


struct BottomNavigationView: View {
    @State private var selection = 0
    @State private var showingWelcomeScreen = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
    let persistenceController = PersistenceController.shared

    var body: some View {
        
        Group {
            if showingWelcomeScreen {
                WelcomeView(isPresented: $showingWelcomeScreen)
            } else {
                TabView(selection: $selection) {
                    
                    
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Beállítások")
                        }
                        .tag(2)
                    
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Kezdőlap")
                        }
                        .tag(0)
                    
                    
                    AnalysisView()
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Elemzés")
                        }
                        .tag(1)
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
        .onAppear {
            if UserDefaults.standard.bool(forKey: "HasLaunchedBefore") == false {
                let defaultCategories = ["Élelmiszer", "Számlák", "Bérleti díj", "Szórakozás", "Egyéb"]
                UserDefaults.standard.set(defaultCategories, forKey: "categories")
                UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            }
        }

    }
    
}









struct BottomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview

        return BottomNavigationView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
