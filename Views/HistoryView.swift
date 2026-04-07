import SwiftUI

struct HistoryView: View {
    @State private var selectedDate: Date?
    let mockWorkouts = [
        WorkoutRecord(date: Date(), category: "Upper Body", title: "Chest & Back", duration: 2715, exerciseCount: 8),
        WorkoutRecord(date: Date().addingTimeInterval(-86400), category: "Lower Body", title: "Legs", duration: 2400, exerciseCount: 6),
        WorkoutRecord(date: Date().addingTimeInterval(-172800), category: "Full Body", title: "Total Body", duration: 3600, exerciseCount: 10),
        WorkoutRecord(date: Date().addingTimeInterval(-259200), category: "Cardio", title: "Running", duration: 1800, exerciseCount: 1),
        WorkoutRecord(date: Date().addingTimeInterval(-345600), category: "Upper Body", title: "Shoulder Day", duration: 2400, exerciseCount: 7),
    ]

    let categoryEmojis = [
        "Upper Body": "💪",
        "Lower Body": "🦵",
        "Core": "⚙️",
        "Cardio": "🏃",
        "Full Body": "🤸",
        "Flexibility": "🧘"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(white: 0.05).ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Workout History")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Your last 12 weeks")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)

                    ScrollView {
                        VStack(spacing: 16) {
                            HeatmapCalendarView()

                            VStack(spacing: 12) {
                                ForEach(mockWorkouts, id: \.id) { workout in
                                    WorkoutHistoryRow(
                                        emoji: categoryEmojis[workout.category] ?? "💪",
                                        title: workout.title,
                                        duration: workout.duration,
                                        exerciseCount: workout.exerciseCount,
                                        date: workout.date
                                    )
                                }
                            }
                            .padding(16)
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
}

struct WorkoutRecord: Identifiable {
    let id = UUID()
    let date: Date
    let category: String
    let title: String
    let duration: Int
    let exerciseCount: Int
}

struct WorkoutHistoryRow: View {
    let emoji: String
    let title: String
    let duration: Int
    let exerciseCount: Int
    let date: Date

    var formattedDuration: String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text(emoji)
                    .font(.system(size: 28))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(formattedDuration)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))

                    Text("\(exerciseCount) exercises")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color(white: 0.1))
        .cornerRadius(10)
    }
}

struct HeatmapCalendarView: View {
    let daysInWeek = 7
    let weeksToShow = 12

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity Heatmap")
                .font(.headline)
                .foregroundColor(.white)

            VStack(spacing: 4) {
                ForEach(0..<weeksToShow, id: \.self) { week in
                    HStack(spacing: 2) {
                        ForEach(0..<daysInWeek, id: \.self) { day in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(heatmapColor(for: week, day: day))
                                .frame(height: 20)
                        }
                    }
                }
            }

            HStack(spacing: 12) {
                Text("Less")
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack(spacing: 2) {
                    ForEach([0.0, 0.3, 0.6, 0.9, 1.0], id: \.self) { intensity in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.4, green: 0.4, blue: 0.9).opacity(intensity))
                            .frame(width: 12, height: 12)
                    }
                }

                Text("More")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()
            }
        }
        .padding(16)
        .background(Color(white: 0.1))
        .cornerRadius(10)
    }

    private func heatmapColor(for week: Int, day: Int) -> Color {
        let randomIntensity = Double.random(in: 0...1)
        return Color(red: 0.4, green: 0.4, blue: 0.9).opacity(randomIntensity)
    }
}

#Preview {
    HistoryView()
        .preferredColorScheme(.dark)
}
