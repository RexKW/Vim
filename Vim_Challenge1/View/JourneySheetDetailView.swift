import SwiftUI
import SwiftData

struct MonsterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Monster.name) private var monsters: [Monster]

    var body: some View {
        NavigationStack {
            List(monsters) { monster in
                VStack(alignment: .leading, spacing: 5) {
                    Text(monster.name)
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "heart.fill") // Icon hati kecil
                            .foregroundColor(.red)
                        Text("HP: \(monster.hp)")
                        
                        Spacer()
                        
                        Text(monster.status)
                            .font(.caption)
                            .italic()
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Monsters")
            .onAppear {
                print("Jumlah monster saat ini: \(monsters.count)")
            }
        }
    }
}

struct JourneySheetDetailView: View {
    @Binding var isJourney: Bool
    
    let monster: Monster
    
    //dummy
//    var sessions: [Session] = [
//        Session(name: "Session 1", timeStamp: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 1))!, duration: 310, caloriesBurned: 50),
//        Session(name: "Session 2", timeStamp: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 1))!, duration: 383, caloriesBurned: 60),
//        Session(name: "Session 3", timeStamp: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 2))!, duration: 534, caloriesBurned: 72),
//        Session(name: "Session 4", timeStamp: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 3))!, duration: 920, caloriesBurned: 80),
//        Session(name: "Session 5", timeStamp: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 4))!, duration: 1021, caloriesBurned: 110),
//    ]
    
    var totalCalories: Double {
        monster.sessions.reduce(0) { $0 + $1.caloriesBurned }
    }

    var progressText: String {
        if monster.status == "Completed" {
            return "The Journey of Rex is complete. You have mastered the trial of the Mohawk and documented your victory."
        } else {
            return "Rex's Journey: In Progress. \nEach exercise brings mastery closer."
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 10){
                
                ZStack{
                    Image(systemName: "shield.fill")
                        .font(.system(size: 120))
                        .foregroundColor(.orange.opacity(0.4))
                        .offset(y: 15)

                    
                    Image(monster.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .offset(y: 20)
                        .clipShape(.capsule)
                        .padding(.top, 10)
                    
                    
                }
                .padding(.bottom)
                
                Text(progressText)
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .frame(width: 250)
                    .padding(.bottom,20)

                Text("Total Calories Burned:")
                    .font(.title2)
                
                Text("\(String(format: "%.2f",totalCalories))")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom,16)
                
                
                //session list
                List {
                    ForEach(monster.sessions) { session in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(session.name).font(.headline)
                                
                                Text(session.timeStamp.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                
                                HStack(spacing: 5){
                                    Text("\(String(format: "%.2f",session.caloriesBurned))")
                                        .fontWeight(.bold)
                                    Text("kcal Burned")
                                        .font(.subheadline)
                                }
                                
                                
                                Text("in \(session.duration / 60):\(String(format: "%02d", session.duration % 60)) minute")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                
                Spacer()
                
                
            }
            .padding(.horizontal)
            .navigationTitle(monster.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isJourney = false
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    JourneySheetDetailView(isJourney: .constant(true),
        monster: Monster(
            name: "Rex Mohawk",
            hp: 0,
            image: "Rex",
            deadImage: "",
            status: "In Progress"
        )
    )
}

//import SwiftUI
//import SwiftData
//
//struct MonsterListView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query(sort: \Monster.name) private var monsters: [Monster]
//
//    var body: some View {
//        NavigationStack {
//            List(monsters) { monster in
//                VStack(alignment: .leading, spacing: 5) {
//                    Text(monster.name)
//                        .font(.headline)
//                    
//                    HStack {
//                        Image(systemName: "heart.fill") // Icon hati kecil
//                            .foregroundColor(.red)
//                        Text("HP: \(monster.hp)")
//                        
//                        Spacer()
//                        
//                        Text(monster.status)
//                            .font(.caption)
//                            .italic()
//                    }
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                }
//            }
//            .navigationTitle("Monsters")
//            .onAppear {
//                print("Jumlah monster saat ini: \(monsters.count)")
//            }
//        }
//    }
//}
