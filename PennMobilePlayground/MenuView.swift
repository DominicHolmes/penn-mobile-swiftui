import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack {
            Text("1920 Commons").font(.largeTitle)
            Image.init("commons")
                .resizable()
                .frame(width: 128, height: 128)
                .cornerRadius(20)
                .shadow(radius: 5)
            List {
                ToggleableMenuItemsView(meals: meals)
                .padding()
            }
        }
    }

    private var bounds: CGRect { UIScreen.main.bounds }
}

struct ToggleableMenuItemsView: View {
    
    let meals: [Meal]
    @State var expandedStates = [String : Bool]()
    
    private func isExpanded(_ id: String) -> Bool {
        expandedStates[id] ?? false
    }
    
    var body: some View {
        ForEach(meals) { meal in
            Section(
                header: Text(meal.title)
                    .font(.title)
                    .onTapGesture {
                        self.expandedStates[meal.id] = !self.isExpanded(meal.id)
                },
                content: {
                    if self.isExpanded(meal.id) {
                        ForEach(meal.stations) { station in
                            Section(
                                header: Text(station.title)
                                    .font(.headline)
                                    .onTapGesture {
                                        self.expandedStates[station.id] = !self.isExpanded(station.id)
                                },
                                content: {
                                    if self.isExpanded(station.id) {
                                        MealItemListView(items: station.items)
                                    }
                            })
                        }
                    }
            }
            )
        }
    }
}

struct MealItemListView: View {
    let items: [MealItem]

    var body: some View {
        ForEach(items) { item in
            VStack(alignment: .leading) {
                HStack {
                    Text(item.title)
                    .font(.subheadline)
                    ForEach(item.attributes, id: \.self) { attribute in
                        attribute.icon
                    }
                }
                if item.description != "" {
                    Text(item.description)
                        .font(.caption)
                }
            }
            
        }
    }
}

struct Meal: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let stations: [MealStation]
}

struct MealStation: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let items: [MealItem]
}

struct MealItem: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    var description: String = ""
    var attributes: [Attribute] = []
    
    enum Attribute {
        case vegan, vegetarian, lowGluten
        
        var icon: some View {
            return Image(systemName: iconName).foregroundColor(iconColor)
        }
        
        private var iconName: String {
            switch self {
            case .vegan:
                return "v.circle.fill"
            default:
                return "circle.fill"
            }
        }
        
        private var iconColor: Color {
            switch self {
            case .vegan:
                return .green
            default:
                return .gray
            }
        }
    }
    
    init(title: String, description: String = "", attribute: Attribute) {
        self.title = title
        self.description = description
        self.attributes = [attribute]
    }
    
    init(title: String, description: String = "", attributes: [Attribute] = []) {
        self.title = title
        self.description = description
        self.attributes = attributes
    }
}

let meals = [
    Meal(title: "Breakfast", stations: [
        MealStation(title: "Breakfast Grill", items: [
            MealItem(title: "Pancakes", description: "kinda shitty small pancakes", attribute: .vegan),
            MealItem(title: "Eggs"),
            MealItem(title: "Bacon", attribute: .vegan),
            MealItem(title: "Sausage", description: "kinda shitty small pancakes"),
        ]),
        MealStation(title: "Kettles", items: [
            MealItem(title: "Oatmeal", description: "kinda shitty small pancakes"),
            MealItem(title: "Bacon"),
            MealItem(title: "Sausage", description: "kinda shitty small pancakes"),
        ])
    ]),
    Meal(title: "Lunch", stations: [
        MealStation(title: "Breakfast Grill", items: [
            MealItem(title: "Pancakes", description: "kinda shitty small pancakes", attribute: .vegan),
            MealItem(title: "Eggs"),
            MealItem(title: "Bacon"),
            MealItem(title: "Sausage", description: "kinda shitty small pancakes"),
        ]),
        MealStation(title: "Kettles", items: [
            MealItem(title: "Oatmeal", description: "kinda shitty small pancakes"),
            MealItem(title: "Bacon"),
            MealItem(title: "Sausage", description: "kinda shitty small pancakes"),
        ])
    ]),
    Meal(title: "Dinner", stations: [
        MealStation(title: "Breakfast Grill", items: [
            MealItem(title: "Pancakes", description: "kinda shitty small pancakes", attribute: .vegan),
            MealItem(title: "Eggs"),
            MealItem(title: "Bacon"),
            MealItem(title: "Sausage", description: "kinda shitty small pancakes"),
        ]),
        MealStation(title: "Kettles", items: [
            MealItem(title: "Oatmeal", description: "kinda shitty small pancakes"),
            MealItem(title: "Bacon"),
            MealItem(title: "Sausage", description: "kinda shitty small pancakes"),
        ])
    ])
]







struct MenuItem: Identifiable {
    var id: String = UUID().uuidString
    let title: String
    var children: [MenuItem] = []
}

let menuItems = [
    MenuItem(
        id: "01",
        title: "Breakfast",
        children: [
            MenuItem(
                id: "01A",
                title: "Breakfast Grill",
                children: [
                    MenuItem(
                        id: "01A01",
                        title: "Pancakes"
                    ),
                    MenuItem(
                        id: "01A02",
                        title: "Eggs"
                    ),
                    MenuItem(
                        id: "01A03",
                        title: "Sausage"
                    ),
                    MenuItem(
                        id: "01A04",
                        title: "Omelet Bar"
                    )
                ]
            ),
            MenuItem(
                id: "01B",
                title: "Kettles",
                children: [
                    MenuItem(
                        id: "01B01",
                        title: "Oatmeal"
                    ),
                    MenuItem(
                        id: "01B02",
                        title: "Tofu Scramble"
                    ),
                    MenuItem(
                        id: "01B03",
                        title: "Soup"
                    ),
                    MenuItem(
                        id: "01B04",
                        title: "Other"
                    )
                ]
            )
        ]
    )
]

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
