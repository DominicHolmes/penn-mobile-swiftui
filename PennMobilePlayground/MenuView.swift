import SwiftUI

struct DiningHeaderView: View {
    
    let config: DiningMenuAPIResponse
    
    var statusHeader: some View {
        HStack {
            Image(systemName: "circle.fill")
                .foregroundColor(config.isOpen ? .green : .gray)
            Text(config.currentMeal)
                .foregroundColor(config.isOpen ? .green : .gray)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            statusHeader
            Text(config.name).font(.title)
            Image.init(config.imageURL)
                .resizable()
                .frame(height: 200)
                .cornerRadius(14)
                .padding(.bottom)
                .scaledToFit()
        }
    }
}

struct MenuView: View {
    
    let config: DiningMenuAPIResponse
    
    @State private var selectedTab = 0
    var tabs = ["Menus", "Hours", "Location"]
    
    var body: some View {
        VStack {
            List {
                DiningHeaderView(config: config)
                
                Picker(selection: $selectedTab, label: Text("Select a dining tab.")) {
                    ForEach(0..<tabs.count) { index in
                        Text(self.tabs[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                if selectedTab == 0 {
                    ToggleableMenuItemsView(meals: meals)
                } else if selectedTab == 1 {
                    Section (header:
                        HStack {
                            Text("Today")
                                .padding()
                            Spacer()
                        }.background(Color.blue).listRowInsets(EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 0))
                    ) {
                        Text("yep")
                    }
                } else if selectedTab == 2 {
                    Section (header: Text("Address"), content: {
                        Text("hello")
                        Text("address")
                    })
                    Section (header: Text("Address"), content: {
                        Text("hello")
                        Text("address")
                    })
                }
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
                header:
                HStack {
                    Text(meal.title)
                        .font(Font.system(size: 24).weight(.medium))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(self.isExpanded(meal.id) ? 180 : 0))
                }
                .padding()
                    // Color is required to make the whole cell tappable
                    .background(Color(white: 0.95))
                    .listRowInsets(EdgeInsets(
                        top: 0,
                        leading: 0,
                        bottom: 0,
                        trailing: 0))
                    .onTapGesture {
                        self.expandedStates[meal.id] = !self.isExpanded(meal.id)
                },
                content: {
                    if self.isExpanded(meal.id) {
                        ForEach(meal.stations) { station in
                            Section(
                                header:
                                HStack {
                                    Text(station.title)
                                        .font(Font.system(size: 17).weight(.medium))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .rotationEffect(.degrees(self.isExpanded(station.id) ? 180 : 0))
                                }
                                .padding()
                                .padding(.leading)
                                    // Color is required to make the whole cell tappable
                                    .background(Color(white: 0.95))
                                    .listRowInsets(EdgeInsets(
                                        top: 0,
                                        leading: 0,
                                        bottom: 0,
                                        trailing: 0))
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
                        .font(.body)
                    ForEach(item.attributes, id: \.self) { attribute in
                        attribute.icon
                    }
                }
                if item.description != "" {
                    Text(item.description)
                        .font(.caption)
                        .fontWeight(.light)
                }
            }
            .padding(.leading)
        }
    }
}

struct DiningMenuAPIResponse {
    let name: String
    let currentMeal: String
    let imageURL: String
    let isOpen: Bool
    let meals: [Meal]
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
            case .lowGluten:
                return "g.circle.fill"
            default:
                return "circle.fill"
            }
        }
        
        private var iconColor: Color {
            switch self {
            case .vegan:
                return .green
            case .lowGluten:
                return .orange
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
            MealItem(title: "Pancakes roast turkey, red leaf lettuce, jersey tomato, red onion roast turkey, red leaf lettuce, jersey tomato, red onion", description: "roast turkey, red leaf lettuce, jersey tomato, red onion, lemon basil aioli, ficelle roast turkey, red leaf lettuce, jersey tomato, red onion, lemon basil aioli, ficelle", attributes: [.vegan, .lowGluten]),
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

let config = DiningMenuAPIResponse(name: "1920 Commons", currentMeal: "Breakfast", imageURL: "commons", isOpen: true, meals: meals)

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(config: config)
    }
}
