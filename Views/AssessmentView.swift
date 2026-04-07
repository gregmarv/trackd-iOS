import SwiftUI

struct AssessmentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentQuestion = 0
    @State private var answers: [String] = Array(repeating: "", count: 5)
    @State private var showCompletion = false

    let questions = [
        AssessmentQuestion(
            id: 0,
            title: "Training Experience",
            question: "What's your training background?",
            options: ["Beginner", "Intermediate", "Advanced", "Elite"]
        ),
        AssessmentQuestion(
            id: 1,
            title: "Activity Level",
            question: "How active are you currently?",
            options: ["Sedentary", "Light Activity", "Moderate Activity", "Very Active"]
        ),
        AssessmentQuestion(
            id: 2,
            title: "Running Baseline",
            question: "How far can you run without stopping?",
            options: ["Can't run", "< 1 mile", "1-3 miles", "> 3 miles"]
        ),
        AssessmentQuestion(
            id: 3,
            title: "Strength Baseline",
            question: "What's your max bench press (roughly)?",
            options: ["Bodyweight", "1-1.25x BW", "1.25-1.5x BW", "> 1.5x BW"]
        ),
        AssessmentQuestion(
            id: 4,
            title: "Injuries",
            question: "Any current injuries or limitations?",
            options: ["None", "Minor (past 6 months)", "Current pain", "Needs PT"]
        ),
    ]

    var canProgress: Bool {
        !answers[currentQuestion].isEmpty
    }

    var canFinish: Bool {
        answers.allSatisfy { !$0.isEmpty }
    }

    var body: some View {
        ZStack {
            Color(white: 0.05).ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack {
                        Text("Assessment")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        Text("\(currentQuestion + 1)/\(questions.count)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    ProgressView(value: Double(currentQuestion + 1) / Double(questions.count))
                        .tint(Color(red: 0.4, green: 0.4, blue: 0.9))
                }
                .padding(20)

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(questions[currentQuestion].title)
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                                .fontWeight(.semibold)

                            Text(questions[currentQuestion].question)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }

                        VStack(spacing: 10) {
                            ForEach(questions[currentQuestion].options, id: \.self) { option in
                                Button(action: {
                                    answers[currentQuestion] = option
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(option)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }

                                        Spacer()

                                        if answers[currentQuestion] == option {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                                        } else {
                                            Circle()
                                                .stroke(Color(white: 0.2), lineWidth: 1)
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(answers[currentQuestion] == option ?
                                                Color(red: 0.4, green: 0.4, blue: 0.9).opacity(0.1) :
                                                Color(white: 0.1))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                answers[currentQuestion] == option ?
                                                Color(red: 0.4, green: 0.4, blue: 0.9) :
                                                Color(white: 0.1),
                                                lineWidth: 1
                                            )
                                    )
                                }
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(20)
                }

                VStack(spacing: 12) {
                    if currentQuestion > 0 {
                        Button(action: {
                            withAnimation {
                                currentQuestion -= 1
                            }
                        }) {
                            Text("Back")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Color(white: 0.15))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.9))
                                .cornerRadius(10)
                        }
                    }

                    if currentQuestion < questions.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentQuestion += 1
                            }
                        }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "arrow.right")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(canProgress ?
                                Color(red: 0.4, green: 0.4, blue: 0.9) :
                                Color(red: 0.4, green: 0.4, blue: 0.9).opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(!canProgress)
                    } else {
                        Button(action: { showCompletion = true }) {
                            Text("Complete Assessment")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(canFinish ?
                                    Color(red: 0.4, green: 0.4, blue: 0.9) :
                                    Color(red: 0.4, green: 0.4, blue: 0.9).opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(!canFinish)
                    }
                }
                .padding(20)
            }
        }
        .navigationBarBackButtonHidden()
        .alert("Assessment Complete!", isPresented: $showCompletion) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("Your profile has been created. You're ready to start your first workout!")
        }
    }
}

struct AssessmentQuestion {
    let id: Int
    let title: String
    let question: String
    let options: [String]
}

#Preview {
    NavigationStack {
        AssessmentView()
    }
    .preferredColorScheme(.dark)
}
