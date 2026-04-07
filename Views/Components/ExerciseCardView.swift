import SwiftUI

// Mock Exercise model for preview (view-only, not the canonical Exercise from Models/Exercise.swift)
struct MockExercise: Identifiable {
    let id = UUID()
    let name: String
    let sets: Int
    let reps: Int
    let rest: Int
    let category: String
    let videoURL: URL?
}

struct ExerciseCardView: View {
    let exercise: MockExercise
    @State private var isCompleted = false
    @State private var isExpanded = false
    @State private var setsDone = ""
    @State private var repsDone = ""
    @State private var weightUsed = ""
    @State private var rating: String? = nil
    @State private var restTimeRemaining = 0
    @State private var restTimer: Timer?

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: { isCompleted.toggle() }) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(isCompleted ? Color(red: 0.4, green: 0.4, blue: 0.9) : .gray)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(exercise.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .strikethrough(isCompleted, color: .gray)

                    HStack(spacing: 8) {
                        if exercise.category != "Warmup" && exercise.category != "Cooldown" {
                            Badge(label: "\(exercise.sets)x", color: .orange)
                            Badge(label: "\(exercise.reps) reps", color: .blue)
                            if exercise.rest > 0 {
                                Badge(label: "\(exercise.rest)s rest", color: .green)
                            }
                        }
                    }
                }

                Spacer()

                if let videoURL = exercise.videoURL {
                    Link(destination: videoURL) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                    }
                }
            }

            if !exercise.category.isEmpty && exercise.category != "Warmup" && exercise.category != "Cooldown" {
                Divider()
                    .background(Color(white: 0.1))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Log your performance")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }

                    if isExpanded {
                        VStack(spacing: 10) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Sets")
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    TextField("e.g. 4", text: $setsDone)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.numberPad)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Reps")
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    TextField("e.g. 8", text: $repsDone)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.numberPad)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Weight (lbs)")
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    TextField("optional", text: $weightUsed)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.decimalPad)
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("How was it?")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                HStack(spacing: 8) {
                                    Button(action: { rating = "Hard" }) {
                                        Text("Too Hard")
                                            .font(.caption)
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(rating == "Hard" ?
                                                Color(red: 0.7, green: 0.3, blue: 0.3) :
                                                Color(white: 0.1))
                                            .foregroundColor(.white)
                                            .cornerRadius(6)
                                    }

                                    Button(action: { rating = "Right" }) {
                                        Text("Just Right")
                                            .font(.caption)
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(rating == "Right" ?
                                                Color(red: 0.4, green: 0.4, blue: 0.9) :
                                                Color(white: 0.1))
                                            .foregroundColor(.white)
                                            .cornerRadius(6)
                                    }

                                    Button(action: { rating = "Easy" }) {
                                        Text("Too Easy")
                                            .font(.caption)
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(rating == "Easy" ?
                                                Color(red: 0.3, green: 0.7, blue: 0.3) :
                                                Color(white: 0.1))
                                            .foregroundColor(.white)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                    }
                }

                if exercise.rest > 0 {
                    Button(action: { startRestTimer() }) {
                        HStack {
                            Image(systemName: "timer")
                            Text(restTimeRemaining > 0 ?
                                "\(restTimeRemaining)s rest" :
                                "Start Rest Timer")
                        }
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color(white: 0.1))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                        .cornerRadius(8)
                    }
                    .disabled(restTimeRemaining > 0)
                }
            }
        }
        .padding(12)
        .background(Color(white: 0.1))
        .cornerRadius(10)
    }

    private func startRestTimer() {
        restTimeRemaining = exercise.rest
        restTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if restTimeRemaining > 0 {
                restTimeRemaining -= 1
            } else {
                restTimer?.invalidate()
                restTimer = nil
            }
        }
    }
}

struct Badge: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 12) {
            ExerciseCardView(exercise: MockExercise(
                name: "Bench Press",
                sets: 4,
                reps: 8,
                rest: 120,
                category: "Upper Body",
                videoURL: URL(string: "https://example.com")
            ))

            ExerciseCardView(exercise: MockExercise(
                name: "Warmup",
                sets: 1,
                reps: 5,
                rest: 0,
                category: "Warmup",
                videoURL: nil
            ))
        }
        .padding(16)
    }
    .preferredColorScheme(.dark)
    .background(Color(white: 0.05))
}
