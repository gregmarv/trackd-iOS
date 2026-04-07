import SwiftUI

struct WorkoutView: View {
    let category: String
    let duration: Int

    @Environment(\.dismiss) var dismiss
    @State private var elapsedSeconds = 0
    @State private var isRunning = true
    @State private var timer: Timer?
    @State private var showCompletion = false

    let mockExercises = [
        MockExercise(name: "Warmup", sets: 1, reps: 5, rest: 60, category: "Warmup", videoURL: nil),
        MockExercise(name: "Bench Press", sets: 4, reps: 8, rest: 120, category: "Upper Body", videoURL: URL(string: "https://example.com/video")),
        MockExercise(name: "Barbell Rows", sets: 4, reps: 8, rest: 120, category: "Upper Body", videoURL: nil),
        MockExercise(name: "Incline Dumbbell Press", sets: 3, reps: 10, rest: 90, category: "Upper Body", videoURL: nil),
        MockExercise(name: "Cooldown Stretching", sets: 1, reps: 5, rest: 0, category: "Cooldown", videoURL: nil),
    ]

    var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            Color(white: 0.05).ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Text(formattedTime)
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                        }

                        Spacer()

                        VStack(spacing: 8) {
                            Button(action: { isRunning.toggle() }) {
                                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                    .font(.system(size: 18))
                                    .frame(width: 44, height: 44)
                                    .background(Color(white: 0.15))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }

                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(width: 44, height: 44)
                                    .background(Color(white: 0.15))
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color(white: 0.08))

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(mockExercises, id: \.name) { exercise in
                            ExerciseCardView(exercise: exercise)
                        }
                    }
                    .padding(16)
                }

                Button(action: { showCompletion = true }) {
                    Text("Complete Workout")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color(red: 0.4, green: 0.4, blue: 0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(16)
            }

            if showCompletion {
                NavigationLink(destination: CompletionView(category: category, duration: elapsedSeconds)) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if isRunning {
                elapsedSeconds += 1
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MockExercise is defined in ExerciseCardView.swift

#Preview {
    NavigationStack {
        WorkoutView(category: "Upper Body", duration: 45)
    }
    .preferredColorScheme(.dark)
}
