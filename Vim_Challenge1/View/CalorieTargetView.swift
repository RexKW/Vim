import SwiftData
import SwiftUI

struct CalorieTargetView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var select_index = 0
    @State private var value: Int = 500
    @State private var shouldNavigate = false
    @Binding var isFinished: Bool
    
    // Pindahkan logika perhitungan steps ke luar body agar bersih dan tidak error
    private var steps: Int {
        Int(Double(value) / 0.04)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Initial target Calories")
                    .font(.system(size: 22))
                    .bold()
                    .padding(.bottom, 9)
                
                Text("Everybody starts somewhere! Chose \nthe target caloriest that suits your ability \nand daily routine")
                    .font(.system(size: 17))
                    .padding(.bottom, 41)
                    .multilineTextAlignment(.center)
                
                Picker("Difficulty", selection: $select_index) {
                    Text("Easy").tag(0)
                    Text("Medium").tag(1)
                    Text("Hard").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 250)
                .padding(.bottom, 20)
                .scaleEffect(1.2)
                .onChange(of: value) { _, newValue in
                    valueswitchautomatic(value: Int(newValue))
                }
                .onChange(of: select_index) { _, newValue in
                    updateValueFromPicker(newValue)
                }

                HStack {
                    buttonminmax(plusorminus: "minus")
                    VStack(spacing: 2) {
                        Text("\(value)")
                            .font(.system(size: 60, weight: .bold))
                        Text("Kcal")
                            .font(.system(size: 22, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    buttonminmax(plusorminus: "plus")
                }
                .frame(maxWidth: 270)
                .padding(.bottom, 40)
                
                // Gunakan variabel 'steps' yang sudah didefinisikan di atas
                VStack(alignment: .leading) {
                    Text("This is equivalent to :")
                    Text("- **\(steps) steps** on the run.")
                    Text("- **\(steps / 2) stairs steps.**")
                }
                .padding(.bottom, 100)
                
                Text("The target calorie can be completed anytime, but **2 weeks of inactivity** will result in a **reset**")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 18)
                
                Button(action: {
                    saveInitialHP()
                    isFinished = true
                    shouldNavigate = true
                    
                }) {
                    Text("Set Target")
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 272, height: 48)
                        .background(Color.blue)
                        .cornerRadius(24)
                }
            }
            .navigationDestination(isPresented: $shouldNavigate) {
                MonsterView()
            }
            .navigationBarBackButtonHidden()
        }
    }

    // Fungsi pembantu untuk tombol plus minus
    func buttonminmax(plusorminus: String) -> some View {
        Button {
            if plusorminus == "minus" {
                if value > 450 { value -= 10 }
            } else {
                value += 10
            }
        } label: {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 46, height: 42)
                .overlay(
                    Image(systemName: plusorminus == "plus" ? "plus" : "minus")
                        .font(.title2)
                        .foregroundStyle(.black)
                )
        }
    }

    // Memperbaiki logika switch agar tidak berulang-ulang
    func updateValueFromPicker(_ index: Int) {
        switch index {
        case 0: if value >= 750 { value = 500 }
        case 1: if value < 750 || value >= 1000 { value = 750 }
        case 2: if value < 1000 { value = 1000 }
        default: break
        }
    }

    func valueswitchautomatic(value: Int) {
        let targetIndex = value < 750 ? 0 : (value < 1000 ? 1 : 2)
        if select_index != targetIndex {
            select_index = targetIndex
        }
    }

//    func saveInitialHP() {
//        let monsterque = [
//            (name: "Rex Mohawk", image: "Rex"),
//            (name: "AdamDevil", image: "AdamDevil"),
//            (name: "Jojomblo", image: "Jojomblo"),
//            (name: "Unknown", image: "UnknownMonster")
//        ]
//        
//        let descriptor = FetchDescriptor<Monster>()
//        let allmonster = (try? modelContext.fetch(descriptor)) ?? []
//        let currentActive = allmonster.first { $0.status == "In Progress" }
//        let countDone = allmonster.filter { $0.status == "Done" }.count
//        
//        if let monster = currentActive {
//            monster.hp = Double(value)
//        } else if countDone < monsterque.count {
//            let nextData = monsterque[countDone]
//            let newmonster = Monster(
//                name: nextData.name,
//                hp: Double(value),
//                image: nextData.image,
//                deadImage: "",
//                status: "In Progress"
//            )
//            modelContext.insert(newmonster)
//            try? modelContext.save()
//        }
//    }
    
    //MARK: funv saveInitialHP
    func saveInitialHP() {
        let descriptor = FetchDescriptor<Monster>(sortBy: [SortDescriptor(\.id, order: .forward)])
        let allmonster = (try? modelContext.fetch(descriptor)) ?? []
        
        // if hasnt input the monster
        if allmonster.isEmpty {
            let monsterque = [
                (name: "Rex Mohawk", image: "Rex"),
                (name: "AdamDevil", image: "AdamDevil"),
                (name: "Jojomblo", image: "Jojomblo"),
                (name: "Unknown", image: "UnknownMonster")
            ]
            
            for (index, data) in monsterque.enumerated() {
                let initialStatus = (index == 0) ? "In Progress" : "Locked"
                let initialHP = (index == 0) ? Double(value) : 0.0
                
                let newMonster = Monster(id: index,
                                         name: data.name,
                                         hp: initialHP,
                                         image: data.image,
                                         deadImage: "",
                                         status: initialStatus)
                //insert monsterdata
                modelContext.insert(newMonster)
            }
        } else {
            
            if let currentActive = allmonster.first(where: { $0.status == "In Progress" }) {
                // if there is an active monster, update hp
                currentActive.hp = Double(value)
            } else {
                //If there is no 'In Progress' monster (meaning the previous one is 'Done'), find the first 'Locked' monster and activate it.
                if let nextMonster = allmonster.first(where: { $0.status == "Locked" }) {
                    nextMonster.status = "In Progress"
                    nextMonster.hp = Double(value) // set hp with new target
                }
            }
        }
        
        try? modelContext.save()
    }
}
#Preview {
    CalorieTargetView(isFinished: .constant(false))
}

