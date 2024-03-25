
import SwiftUI

struct HomeView: View {
    @State private var showingAddItemView = false
    @State private var selectedDate = Date()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ListItem.name, ascending: true)],
        animation: .default)
    private var listItems: FetchedResults<ListItem>

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var totalSpending: Double {
        listItems.filter { listItem in
            guard let listItemDate = listItem.date else {
                return false
            }
            return listItem.price < 0 && Calendar.current.isDate(listItemDate, inSameDayAs: selectedDate)
        }
        .reduce(0) { $0 + $1.price }
    }

    var totalRevenue: Double {
        listItems.filter { listItem in
            guard let listItemDate = listItem.date else {
                return false
            }
            return listItem.price >= 0 && Calendar.current.isDate(listItemDate, inSameDayAs: selectedDate)
        }
        .reduce(0) { $0 + $1.price }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                    }) {
                        Text("<")
                            .font(.title)
                    }
                    .padding()
                    

                    Text(isToday(date: selectedDate) ? "Ma" : dateFormatter.string(from: selectedDate))
                        .padding()

                    Button(action: {
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                    }) {
                        Text(">")
                            .font(.title)
                    }
                    .padding()
                    Spacer()
                }
                .padding()

                List {
                        ForEach(listItems.filter({ listItem in
                                    guard let listItemDate = listItem.date else {
                                        return false
                                    }
                                    return Calendar.current.isDate(listItemDate, inSameDayAs: selectedDate)
                                })) { listItem in
                                    NavigationLink(destination: DetailView(listItem: listItem)) {
                                        CardView(itemName: listItem.name ?? "", itemCategory: listItem.category ?? "", price: listItem.price, quantity: Int(listItem.quantity))
                                           
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())


                HStack {
                    VStack(alignment: .leading) {
                        Text("Elköltve: \(Int(abs(totalSpending))) Ft")
                        Text("Bevétel: \(Int(totalRevenue)) Ft")
                    }
                    .padding()
            
                    Spacer()
                }
            }
            .navigationBarItems(trailing: Button(action: {
                self.showingAddItemView.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.title)
            })
            .sheet(isPresented: $showingAddItemView) {
                AddItemView(selectedDate: selectedDate)
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
            .navigationTitle("Kezdőlap")
        }
        
        
    }
        

    private func isToday(date: Date) -> Bool {
        return Calendar.current.isDateInToday(date)
    }
}


#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
