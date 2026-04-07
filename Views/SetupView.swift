import SwiftUI

struct SetupView: View {
    let category: String
    @Environment(\.dismiss) var dismiss
    @State private var selectedDuration: Int = 30
    @State private var selectedEquipment: Set<String> = []
    @State private var navigateToWorkout = false

    let durations = [15, 20, 30, 45, 60]
    let equipmentOptions = ["Dumbbells", "Barbell", "Bodyweight", "Machines", "Resistance Bands"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Set Up Your Workout")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(category)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Duration")
                                .font(.headline)

                            HStack(spacing: 8) {
                                ForEach(durations, id: \.self) { duration in
                                    Button(action: { selectedDuration = duration }) {
                                        Text("\(duration)m")
                                            .font(.subheadline)
                                            .frame(maxWidth: .infinity)
                                            .padding(10)
                                            .background(selectedDuration == duration ?
                                                Color(red: 0.4, green: 0.4, blue: 0.9) :
                                                Color(white: 0.15))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Available Equipment")
                                .font(.headline)

                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(equipmentOptions, id: \.self) { equipment in
                                    Button(action: {
                                        if selectedEquipment.contains(equipment) {
                                            selectedEquipment.remove(equipment)
                                        } else {
                                            selectedEquipment.insert(equipment)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: selectedEquipment.contains(equipment) ?
                                                "checkmark.square.fill" :
                                                "square")
                                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))

                                            Text(equipment)
                                                .foregroundColor(.white)

                                            Spacer()
                                        }
                                        .padding(12)
                                        .background(Color(white: 0.1))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }

                        Spacer()
                    }
                }

                NavigationLink(destination: WorkoutView(category: category, duration: selectedDuration)) {
                    Text("Start Workout")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color(red: 0.4, green: 0.4, blue: 0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                    }
                }
            }
        }
    }
}

#Preview {
    SetupView(category: "Upper Body")
        .preferredColorScheme(.dark)
}
