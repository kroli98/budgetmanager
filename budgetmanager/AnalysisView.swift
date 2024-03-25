//
//  AnalysisView.swift
//  budgetmanager
//
//  Created by Kiss Roland on 25/03/2024.
//

import SwiftUI

struct AnalysisView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ListItem.name, ascending: true)],
        animation: .default)
    private var listItems: FetchedResults<ListItem>
    
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var categoryDistribution: [String: Double] {
        let calendar = Calendar.current
        var currentDate = startDate
        var categoryCount = [String: Double]()
        
        while currentDate <= endDate {
            listItems.filter { listItem in
                guard let listItemDate = listItem.date else {
                    return false
                }
                return listItem.category != nil && calendar.isDate(listItemDate, equalTo: currentDate, toGranularity: .day)
            }
            .forEach { listItem in
                let category = listItem.category!
                categoryCount[category, default: 0] += 1
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        let totalCount = categoryCount.values.reduce(0, +)
        var categoryPercentages = [String: Double]()
        for (category, count) in categoryCount {
            categoryPercentages[category] = (count / totalCount) * 100
        }
        
        return categoryPercentages
    }
    
    var body: some View {
        NavigationView{
            VStack {
               
                DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                    .padding()
                DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
                    .padding()
                Text("Kategóriák eloszlása:")
                    .font(.title2)
                List {
                    ForEach(categoryDistribution.sorted(by: >), id: \.key) { key, value in
                        HStack {
                            Text("\(key): ")
                            Spacer()
                            Text("\(String(format: "%.2f", value))%")
                        }
                    }
                }
              
            }
            
            
            .navigationTitle("Elemzés")
        }
    }
}
#Preview {
    AnalysisView()
}
