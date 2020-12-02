//
//  ContentView.swift
//  PizzaRestaurant
//
//  Created by Andreas Schultz on 25.09.20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Order.entity(), sortDescriptors: [], predicate: NSPredicate(format: "status != %@", Status.completed.rawValue))

    var orders: FetchedResults<Order>
    
    @State var showOrderSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orders) { order in
                    HStack {
                        
                        NavigationLink(destination: DetailView(order: order)) {

                        VStack(alignment: .leading) {
                            Text("\(order.pizzaType) - \(order.numberOfSlices) slices")
                                .font(.headline)
                            Text("Table \(order.tableNumber)")
                                .font(.subheadline)
                        }
                      }
                    }
                        .frame(height: 50)
                }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewContext.delete(orders[index])
                        }
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
            }
                .listStyle(PlainListStyle())
                .navigationTitle("My Orders")
                .navigationBarItems(trailing: Button(action: {
                    showOrderSheet = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }))
                .sheet(isPresented: $showOrderSheet) {
                    OrderSheet()
                }
        }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
