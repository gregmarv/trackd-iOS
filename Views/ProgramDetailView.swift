import SwiftUI

struct ProgramDetailView: View {
    let program: ProgramInfo
    @Environment(\.dismiss) var dismiss
    @State private var isEnrolled = false

    let phases = [
        ("1", "Foundation", "Weeks 1-3"),
        ("2", "Progression", "Weeks 4-8"),
        ("3", "Peak", "Weeks 9-12"),
    ]

    let weekSchedule = [
        ("Week 1", [
            ("Monday", "Push - Upper Focus"),
            ("Wednesday", "Pull - Back Focus"),
            ("Friday", "Legs & Core"),
        ]),
        ("Week 2", [
            ("Monday", "Push - Chest Focus"),
            ("Wednesday", "Pull - Deadlifts"),
            ("Friday", "Leg Press & Accessories"),
        ]),
    ]

    var body: some View {
        ZStack {
            Color(white: 0.05).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        Text(program.emoji)
                            .font(.system(size: 48))

                        VStack(spacing: 8) {
                            Text(program.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text(program.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        HStack(spacing: 16) {
                            VStack(spacing: 4) {
                                Text("Duration")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Text("\(program.durationWeeks) weeks")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)

                            Divider()
                                .frame(height: 40)
                                .background(Color(white: 0.1))

                            VStack(spacing: 4) {
                                Text("Sessions")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Text("\(program.sessionsPerWeek)/week")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(20)
                    .background(Color(white: 0.1))
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Equipment Needed")
                            .font(.headline)
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(program.equipment, id: \.self) { item in
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))

                                    Text(item)
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
                        Text("Overview")
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(program.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(5)
                    }
                    .padding(16)
                    .background(Color(white: 0.1))
                    .cornerRadius(12)

                    DisclosureGroup(isExpanded: .constant(false)) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Scientific research shows that progressive overload combined with adequate recovery produces the best results for muscle growth and strength development.")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Text("This program incorporates:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)

                            VStack(alignment: .leading, spacing: 6) {
                                BulletPoint(text: "Linear periodization for strength")
                                BulletPoint(text: "Adequate recovery between sessions")
                                BulletPoint(text: "Progressive overload principles")
                            }
                        }
                    } label: {
                        Text("The Science")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(16)
                    .background(Color(white: 0.1))
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Training Phases")
                            .font(.headline)
                            .foregroundColor(.white)

                        VStack(spacing: 8) {
                            ForEach(phases, id: \.0) { number, name, duration in
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.4, green: 0.4, blue: 0.9))

                                        Text(number)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 40, height: 40)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(name)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)

                                        Text(duration)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(white: 0.1))
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Weekly Schedule")
                            .font(.headline)
                            .foregroundColor(.white)

                        VStack(spacing: 12) {
                            ForEach(weekSchedule, id: \.0) { weekLabel, sessions in
                                DisclosureGroup(weekLabel) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(sessions, id: \.0) { day, workout in
                                            HStack {
                                                Text(day)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)

                                                Spacer()

                                                Text(workout)
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                            }
                                            .padding(10)
                                            .background(Color(white: 0.05))
                                            .cornerRadius(6)
                                        }
                                    }
                                }
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(white: 0.1))
                    .cornerRadius(12)

                    Button(action: { isEnrolled.toggle() }) {
                        Text(isEnrolled ? "Restart Program" : "Start This Program")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(isEnrolled ? Color(white: 0.15) : Color(red: 0.4, green: 0.4, blue: 0.9))
                            .foregroundColor(isEnrolled ? Color(red: 0.4, green: 0.4, blue: 0.9) : .white)
                            .cornerRadius(12)
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

struct BulletPoint: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Text("•")
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))

            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    NavigationStack {
        ProgramDetailView(program: ProgramInfo(
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
