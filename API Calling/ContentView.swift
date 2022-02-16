//
//  ContentView.swift
//  API Calling
//
//  Created by Student on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @State private var burgers = [Burger]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(burgers) { burger in
                NavigationLink (
                    destination: VStack {
                        Text(burger.name)
                            .padding()
                        Text(burger.restaurant)
                            .padding()
                        Text(burger.description)
                            .padding()
                        Spacer()
                    },
                    label: {
                        HStack {
                        Text(burger.name)
                    }
                })
            }
            .navigationTitle("Best Burgers")
        }
        .onAppear {
            queryAPI()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"), message: Text("There was a problem loading the data"), dismissButton: .default(Text("OK")))
        }
    }
    
    func queryAPI() {
        let apiKey = "?rapidapi-key=1068cdde12msh7d4332b75ebd424p14524ejsn165dd7715f89"
        let query = "https://burgers1.p.rapidapi.com/burgers\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                let contents = json.arrayValue
                for item in contents {
                    let name = item["name"].stringValue
                    let restaurant = item["restaurant"].stringValue
                    let description = item["description"].stringValue
                    let burger = Burger(name: name, restaurant: restaurant, description: description)
                    burgers.append(burger)
                }
                return
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Burger: Identifiable {
    let id = UUID()
    var name: String
    var restaurant: String
    var description: String
}
