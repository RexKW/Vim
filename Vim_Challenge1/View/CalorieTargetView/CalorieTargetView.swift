import SwiftData
import SwiftUI

struct CalorieTargetView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var workoutVM: WorkoutViewModel
    @State var select_index = 0
    @State var value: Double = 1
    @State var shouldNavigate = false
    @Environment(\.dismiss) var dismiss
    @Query var monsters: [Monster]
    
    // Pindahkan logika perhitungan steps ke luar body agar bersih dan tidak error
    var steps: Int {
        Int(Double(value) / 0.04)
    }

    var body: some View {
        VStack {
            if !hasCompletedOnboarding {
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
        // navigate to MonsterView after setting initial calories
        .navigationDestination(isPresented: $shouldNavigate) {
                    MonsterView()
                }
    }


    
}
#Preview {
    CalorieTargetView()
        .environmentObject(WorkoutViewModel())
}

