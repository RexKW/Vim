import SwiftData
import SwiftUI

struct CalorieTargetView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @Environment(\.modelContext) private var modelContext
    @State private var select_index = 0
    @State private var value: Int = 500
    @State private var shouldNavigate = false
    @State private var isInitial: Bool = true
    @Query private var monsters: [Monster]
    
    // Pindahkan logika perhitungan steps ke luar body agar bersih dan tidak error
    private var steps: Int {
        Int(Double(value) / 0.04)
    }

    var body: some View {
        NavigationStack {
            if isInitial {
                // view for initial target calories, first download
                reusedView(
                    title: "Initial Target Calories",
                    caption: "Everybody starts somewhere! Chose \nthe target caloriest that suits your ability \nand daily routine"
                    )
            }
            else{
                // view for after defeating monster
                reusedView(
                    title: "Step Up Your Game",
                    caption: "You took down the monster and \ncrushed your exercise. Victory feels good!\nReady to plan your next move?")
            }
            
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
    
    /// for using the target calorie view
    func reusedView(title: String, caption: String) -> some View {
        VStack {
            Text(title)
                .font(.system(size: 22))
                .bold()
                .padding(.bottom, 9)
            
            Text(caption)
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
                        .onAppear() {
                            if let lastDeadMonster = monsters.last(where: { $0.status == "Dead" }) {
                                self.value = lastDeadMonster.hp
                                valueswitchautomatic(value: lastDeadMonster.hp)
                            }
                        }
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
                isInitial = false
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

    func saveInitialHP() {
        let monsterque = [
            (name: "Rex Mohawk", image: "Rex"),
            (name: "AdamDevil", image: "AdamDevil"),
            (name: "Jojomblo", image: "Jojomblo"),
            (name: "Unknown", image: "UnknownMonster")
        ]
        
        let descriptor = FetchDescriptor<Monster>()
        let allmonster = (try? modelContext.fetch(descriptor)) ?? []
        let currentActive = allmonster.first { $0.status == "In Progress" }
        let countDone = allmonster.filter { $0.status == "Done" }.count
        
        if let monster = currentActive {
            monster.hp = Double(value)
        } else if countDone < monsterque.count {
            let nextData = monsterque[countDone]
            let newmonster = Monster(
                name: nextData.name,
                hp: Double(value),
                image: nextData.image,
                deadImage: "",
                status: "In Progress"
            )
            modelContext.insert(newmonster)
            try? modelContext.save()
        }
    }
}
#Preview {
    CalorieTargetView()
}

