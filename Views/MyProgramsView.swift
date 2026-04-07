import SwiftUI

struct MyProgramsView: View {
    @State private var selectedProgram: ProgramInfo?
    let activePrograms = [
        ProgramInfo(
            id: "pb-1",
            emoji: "💪",
            name: "Push/Pull/Legs",
            subtitle: "3-day split",
            description: "Classic strength training split",
            durationWeeks: 12,
            sessionsPerWeek: 3,
            equipment: ["Dumbbells", "Barbell"],
            isEnrolled: true
        ),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(white: 0.05).ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Programs")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Active training programs")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)

                    ScrollView {
                        VStack(spacing: 16) {
                            if activePrograms.isEmpty {
                                EmptyStateView()
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(activePrograms, id: \.id) { program in
                                        NavigationLink(destination: ActiveProgramView(program: program)) {
                                            MyProgramCard(program: program)
                                        }
                                    }
                                }
                                .padding(16)
                            }

                            NavigationLink(destination: ProgramBrowserView()) {
                                BrowseMoreCard()
                            }
                            .padding(16)
                        }
                    }
                }
            }
        }
    }
}

struct MyProgramCard: View {
    let program: ProgramInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(program.emoji)
                    .font(.system(size: 32))

                VStack(alignment: .leading, spacing: 4) {
                    Text(program.name)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(program.subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
            }

            VStack(spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Spacer()

                    Text("25%")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                }

                ProgressView(value: 0.25)
                    .tint(Color(red: 0.4, green: 0.4, blue: 0.9))
            }
        }
        .padding(16)
        .background(Color(white: 0.1))
        .cornerRadius(12)
    }
}

struct BrowseMoreCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))

            Text("Browse More Programs")
                .font(.headline)
                .foregroundColor(.white)

            Text("Explore new training plans")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(white: 0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.4, green: 0.4, blue: 0.9).opacity(0.3), lineWidth: 1)
        )
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bolt.badge.fill")
                .font(.system(size: 48))
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9).opacity(0.5))

            Text("No Active Programs")
                .font(.headline)
                .foregroundColor(.white)

            Text("Start a new program to get your training plan and track progress")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color(white: 0.1))
        .cornerRadius(12)
    }
}

#Preview {
    MyProgramsView()
        .preferredColorScheme(.dark)
}
