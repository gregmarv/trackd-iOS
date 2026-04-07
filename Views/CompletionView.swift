import SwiftUI

struct CompletionView: View {
    let category: String
    let duration: Int
    @Environment(\.dismiss) var dismiss

    let exercisesCompleted = 12
    let muscleGroups = ["Chest", "Back", "Shoulders"]

    var formattedDuration: String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            Color(white: 0.05).ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))

                            Text("Workout Complete!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text(category)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .background(Color(white: 0.1))
                        .cornerRadius(12)

                        VStack(spacing: 16) {
                            StatRow(label: "Duration", value: formattedDuration, icon: "timer")
                            Divider().background(Color(white: 0.1))
                            StatRow(label: "Exercises", value: "\(exercisesCompleted)", icon: "dumbbell")
                            Divider().background(Color(white: 0.1))
                            StatRow(label: "Muscles Worked", value: muscleGroups.count.description, icon: "figure.walk")
                        }
                        .padding(16)
                        .background(Color(white: 0.1))
                        .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Muscle Groups Hit")
                                .font(.headline)
                                .foregroundColor(.white)

                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(muscleGroups, id: \.self) { group in
                                    HStack {
                                        Circle()
                                            .fill(Color(red: 0.4, green: 0.4, blue: 0.9).opacity(0.5))
                                            .frame(width: 8, height: 8)

                                        Text(group)
                                            .foregroundColor(.white)

                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(white: 0.1))
                        .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Great Effort!")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("You've built consistency. Keep it up to see real progress!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(3)
                        }
                        .padding(16)
                        .background(Color(red: 0.4, green: 0.4, blue: 0.9).opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(20)
                }

                VStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Text("Back to Home")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color(red: 0.4, green: 0.4, blue: 0.9))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button(action: { dismiss() }) {
                        Text("View Detailed Summary")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color(white: 0.15))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                            .cornerRadius(12)
                    }
                }
                .padding(16)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                .frame(width: 24)

            Text(label)
                .foregroundColor(.gray)

            Spacer()

            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    NavigationStack {
        CompletionView(category: "Upper Body", duration: 2715)
    }
    .preferredColorScheme(.dark)
}
