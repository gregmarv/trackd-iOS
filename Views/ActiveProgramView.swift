import SwiftUI

struct ActiveProgramView: View {
    let program: ProgramInfo
    @Environment(\.dismiss) var dismiss
    @State private var showQuitConfirmation = false

    let currentWeekSessions = [
        ProgramSession(id: "s1", day: "Monday", name: "Push - Upper Focus", type: "Strength", completed: false),
        ProgramSession(id: "s2", day: "Wednesday", name: "Pull - Back Focus", type: "Strength", completed: true),
        ProgramSession(id: "s3", day: "Friday", name: "Legs & Core", type: "Strength", completed: false),
    ]

    let upcomingWeeks = [
        ("Week 2", 3),
        ("Week 3", 3),
        ("Week 4", 3),
    ]

    var progressPercent: Double {
        Double(currentWeekSessions.filter(\.completed).count) / Double(currentWeekSessions.count)
    }

    var body: some View {
        ZStack {
            Color(white: 0.05).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            Text(program.emoji)
                                .font(.system(size: 40))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(program.name)
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("Week 1 of \(program.durationWeeks)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }

                        VStack(spacing: 8) {
                            HStack {
                                Text("Progress")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Spacer()

                                Text(String(format: "%.0f%%", progressPercent * 100))
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                            }

                            ProgressView(value: progressPercent)
                                .tint(Color(red: 0.4, green: 0.4, blue: 0.9))
                        }
                    }
                    .padding(16)
                    .background(Color(white: 0.1))
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("This Week's Sessions")
                            .font(.headline)
                            .foregroundColor(.white)

                        VStack(spacing: 12) {
                            ForEach(currentWeekSessions, id: \.id) { session in
                                SessionCard(session: session)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(white: 0.1))
                    .cornerRadius(12)

                    DisclosureGroup("Upcoming Weeks") {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(upcomingWeeks, id: \.0) { weekLabel, sessions in
                                HStack {
                                    Text(weekLabel)
                                        .font(.subheadline)
                                        .foregroundColor(.white)

                                    Spacer()

                                    Text("\(sessions) sessions")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(12)
                                .background(Color(white: 0.05))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Color(white: 0.1))
                    .cornerRadius(12)

                    Button(role: .destructive, action: { showQuitConfirmation = true }) {
                        Text("Quit Program")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color(red: 0.7, green: 0.3, blue: 0.3).opacity(0.2))
                            .foregroundColor(Color(red: 0.7, green: 0.3, blue: 0.3))
                            .cornerRadius(12)
                    }
                    .alert("Quit Program?", isPresented: $showQuitConfirmation) {
                        Button("Cancel", role: .cancel) { }
                        Button("Quit", role: .destructive) {
                            dismiss()
                        }
                    } message: {
                        Text("You'll lose progress on this program. Are you sure?")
                    }
                }
                .padding(16)
            }
        }
        .navigationBarBackButtonHidden()
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

struct ProgramSession: Identifiable {
    let id: String
    let day: String
    let name: String
    let type: String
    let completed: Bool
}

struct SessionCard: View {
    let session: ProgramSession

    let typeColors: [String: Color] = [
        "Strength": Color(red: 0.4, green: 0.4, blue: 0.9),
        "Hypertrophy": Color(red: 0.9, green: 0.6, blue: 0.2),
        "Endurance": Color(red: 0.3, green: 0.7, blue: 0.3),
    ]

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(session.day)
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(session.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(session.type)
                    .font(.caption)
                    .foregroundColor(typeColors[session.type] ?? .gray)
            }

            Spacer()

            if session.completed {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.3, green: 0.7, blue: 0.3))
            } else {
                Button(action: {}) {
                    Text("Start")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.4, green: 0.4, blue: 0.9))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    (typeColors[session.type] ?? .gray).opacity(0.3),
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    NavigationStack {
        ActiveProgramView(program: ProgramInfo(
            id: "pb-1",
            emoji: "💪",
            name: "Push/Pull/Legs",
            subtitle: "3-day split",
            description: "Classic strength training split",
            durationWeeks: 12,
            sessionsPerWeek: 3,
            equipment: ["Dumbbells", "Barbell", "Machines"],
            isEnrolled: true
        ))
    }
    .preferredColorScheme(.dark)
}
