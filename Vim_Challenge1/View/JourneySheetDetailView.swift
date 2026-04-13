import SwiftUI
import SwiftData

struct JourneySheetDetailView: View {
    @Binding var isJourney: Bool
    
    let monster: Monster
    
    var totalCalories: Double {
        monster.sessions.reduce(0) { $0 + $1.caloriesBurned }
        // reduce: menggabungkan semua isi dalam sebuah array menjadi satu nilai
        // { $0 + $1.caloriesBurned }: nambah nilai sebelumnya (tampung) + nilai berikutnya/nilai yg skrg diproses
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
                                
                                Text(session.timeStamp.formatted(date: .abbreviated, time: .omitted)) //omitted: ga muncul
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
            id: 0,
            name: "Rex Mohawk",
            hp: 0,
            image: "Rex",
            deadImage: "",
            status: "In Progress"
        )
    )
}
