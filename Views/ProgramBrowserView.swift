import SwiftUI

struct ProgramBrowserView: View {
    @State private var selectedProgram: ProgramInfo?
    let mockPrograms = [
        ProgramInfo(
            id: "pb-1",
            emoji: "💪",
            name: "Push/Pull/Legs",
            subtitle: "3-day split",
            description: "Classic strength training split",
            durationWeeks: 12,
            sessionsPerWeek: 3,
            equipment: ["Dumbbells", "Barbell", "Machines"],
            isEnrolled: true
        ),
        ProgramInfo(
            id: "pb-2",
            emoji: "🏃",
            name: "Couch to 5K",
            subtitle: "Running progression",
            description: "Build endurance from scratch",
            durationWeeks: 9,
            sessionsPerWeek: 3,
            equipment: ["Running Shoes"],
            isEnrolled: false
        ),
        ProgramInfo(
            id: "pb-3",
            emoji: "🤸",
            name: "Full Body Strength",
            subtitle: "Compound focus",
            description: "Build functional strength",
            durationWeeks: 8,
            sessionsPerWeek: 4,
            equipment: ["Barbell", "Dumbbells"],
            isEnrolled: false
        ),
        ProgramInfo(
            id: "pb-4",
            emoji: "🧘",
            name: "Flexibility & Mobility",
            subtitle: "Recovery program",
            description: "Improve range of motion",
            durationWeeks: 6,
            sessionsPerWeek: 4,
            equipment: ["Yoga Mat"],
            isEnrolled: false
        ),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(white: 0.05).ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Browse Programs")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Find your next challenge")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(mockPrograms, id: \.id) { program in
                                NavigationLink(destination: ProgramDetailView(program: program)) {
                                    ProgramBrowserCard(program: program)
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
        }
    }
}

struct ProgramInfo: Identifiable {
    let id: String
    let emoji: String
    let name: String
    let subtitle: String
    let description: String
    let durationWeeks: Int
    let sessionsPerWeek: Int
    let equipment: [String]
    let isEnrolled: Bool
}

struct ProgramBrowserCard: View {
    let program: ProgramInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(program.emoji)
                    .font(.system(size: 32))

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(program.name)
                                .font(.headline)
                                .foregroundColor(.white)

                            Text(program.subtitle)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        if program.isEnrolled {
                            Text("Active")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(red: 0.4, green: 0.4, blue: 0.9).opacity(0.3))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                                .cornerRadius(4)
                        }
                    }

                    Text(program.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }

            Divider()
                .background(Color(white: 0.1))

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Duration")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("\(program.durationWeeks) weeks")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }

                Divider()
                    .frame(height: 30)
                    .background(Color(white: 0.1))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Per Week")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("\(program.sessionsPerWeek)x sessions")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
            }
        }
        .padding(16)
        .background(Color(white: 0.1))
        .cornerRadius(12)
    }
}

#Preview {
    ProgramBrowserView()
        .preferredColorScheme(.dark)
}
