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
