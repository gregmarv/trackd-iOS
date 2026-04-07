import Foundation

// MARK: - WorkoutGenerator
// Self-contained workout generation service. All helper types are fileprivate
// to avoid conflicts with canonical types in Models/.

/// Generates workout sessions from the exercise database based on specified criteria
final class WorkoutGenerator {

    // MARK: - Helper Types (fileprivate)

    fileprivate struct GeneratorExercise: Identifiable {
        let id: String
        let name: String
        let category: GeneratorCategory
        let bodySystem: GeneratorBodySystem
        let equipment: [GeneratorEquipment]
        let intensity: GeneratorIntensity
    }

    fileprivate enum GeneratorCategory: String {
        case strength
        case cardio
        case conditioning
    }

    fileprivate enum GeneratorBodySystem: String {
        case chest, back, shoulders, legs, arms, full, cardiovascular
    }

    fileprivate enum GeneratorEquipment: String, Hashable {
        case barbell, dumbbells, bench, rack, machine, cable
        case treadmill, bike, rower, pool, pullupBar
    }

    fileprivate enum GeneratorIntensity: String {
        case low, moderate, high
    }

    fileprivate struct GeneratedWorkout: Identifiable {
        let id: String
        let name: String
        let category: GeneratorCategory
        let duration: Int
        let exercises: [GeneratedExercise]
        let createdAt: Date
    }

    fileprivate struct GeneratedExercise: Codable {
        let exerciseId: String
        let exerciseName: String
        let sets: Int
        let reps: Int
        let restSeconds: Int
        let notes: String
    }

    // MARK: - Exercise Database

    private let exerciseDatabase: [GeneratorExercise] = [
        // Strength - Upper Body
        GeneratorExercise(id: "ex_001", name: "Bench Press", category: .strength, bodySystem: .chest, equipment: [.barbell, .bench], intensity: .moderate),
        GeneratorExercise(id: "ex_002", name: "Incline Dumbbell Press", category: .strength, bodySystem: .chest, equipment: [.dumbbells], intensity: .moderate),
        GeneratorExercise(id: "ex_003", name: "Barbell Rows", category: .strength, bodySystem: .back, equipment: [.barbell], intensity: .moderate),
        GeneratorExercise(id: "ex_004", name: "Dumbbell Rows", category: .strength, bodySystem: .back, equipment: [.dumbbells], intensity: .moderate),
        GeneratorExercise(id: "ex_005", name: "Pull-ups", category: .strength, bodySystem: .back, equipment: [.pullupBar], intensity: .high),
        GeneratorExercise(id: "ex_006", name: "Lat Pulldown", category: .strength, bodySystem: .back, equipment: [.cable], intensity: .moderate),
        GeneratorExercise(id: "ex_007", name: "Overhead Press", category: .strength, bodySystem: .shoulders, equipment: [.barbell, .dumbbells], intensity: .moderate),
        GeneratorExercise(id: "ex_008", name: "Lateral Raises", category: .strength, bodySystem: .shoulders, equipment: [.dumbbells], intensity: .low),
        GeneratorExercise(id: "ex_009", name: "Barbell Squats", category: .strength, bodySystem: .legs, equipment: [.barbell, .rack], intensity: .high),
        GeneratorExercise(id: "ex_010", name: "Leg Press", category: .strength, bodySystem: .legs, equipment: [.machine], intensity: .moderate),
        GeneratorExercise(id: "ex_011", name: "Leg Curls", category: .strength, bodySystem: .legs, equipment: [.machine], intensity: .low),
        GeneratorExercise(id: "ex_012", name: "Deadlifts", category: .strength, bodySystem: .legs, equipment: [.barbell], intensity: .high),

        // Cardio
        GeneratorExercise(id: "ex_020", name: "Treadmill Run", category: .cardio, bodySystem: .cardiovascular, equipment: [.treadmill], intensity: .moderate),
        GeneratorExercise(id: "ex_021", name: "Outdoor Run", category: .cardio, bodySystem: .cardiovascular, equipment: [], intensity: .moderate),
        GeneratorExercise(id: "ex_022", name: "Stationary Bike", category: .cardio, bodySystem: .cardiovascular, equipment: [.bike], intensity: .moderate),
        GeneratorExercise(id: "ex_023", name: "Rowing Machine", category: .cardio, bodySystem: .cardiovascular, equipment: [.rower], intensity: .high),
        GeneratorExercise(id: "ex_024", name: "Jump Rope", category: .cardio, bodySystem: .cardiovascular, equipment: [], intensity: .high),
        GeneratorExercise(id: "ex_025", name: "Swimming", category: .cardio, bodySystem: .cardiovascular, equipment: [.pool], intensity: .moderate),

        // Conditioning
        GeneratorExercise(id: "ex_030", name: "Burpees", category: .conditioning, bodySystem: .full, equipment: [], intensity: .high),
        GeneratorExercise(id: "ex_031", name: "Mountain Climbers", category: .conditioning, bodySystem: .full, equipment: [], intensity: .high),
    ]

    init() {}

    // MARK: - Public API

    /// Generates a workout matching the specified criteria
    func generateQuickWorkout(
        category: String,
        duration: Int
    ) -> [String: Any] {
        let cat = GeneratorCategory(rawValue: category) ?? .strength

        let candidateExercises = exerciseDatabase.filter { $0.category == cat }
        let selectedExercises = selectExercises(from: candidateExercises, for: duration, category: cat)

        return [
            "id": UUID().uuidString,
            "name": "\(cat.rawValue.capitalized) Workout",
            "duration": duration,
            "exerciseCount": selectedExercises.count
        ]
    }

    // MARK: - Private Helpers

    private func selectExercises(
        from candidates: [GeneratorExercise],
        for duration: Int,
        category: GeneratorCategory
    ) -> [GeneratedExercise] {
        guard !candidates.isEmpty else { return [] }

        let exerciseCount = max(1, min(8, duration / 8))
        var selected: [GeneratedExercise] = []
        var exercisesToSelect = candidates

        for _ in 0..<min(exerciseCount, candidates.count) {
            guard let exercise = exercisesToSelect.randomElement() else { break }
            exercisesToSelect.removeAll { $0.id == exercise.id }

            let workoutExercise = createExercise(exercise, category: category)
            selected.append(workoutExercise)
        }

        return selected
    }

    private func createExercise(
        _ exercise: GeneratorExercise,
        category: GeneratorCategory
    ) -> GeneratedExercise {
        let (sets, reps, restSeconds) = determineScheme(for: exercise, category: category)

        return GeneratedExercise(
            exerciseId: exercise.id,
            exerciseName: exercise.name,
            sets: sets,
            reps: reps,
            restSeconds: restSeconds,
            notes: ""
        )
    }

    private func determineScheme(
        for exercise: GeneratorExercise,
        category: GeneratorCategory
    ) -> (sets: Int, reps: Int, restSeconds: Int) {
        switch category {
        case .strength:
            switch exercise.intensity {
            case .high:
                return (sets: 5, reps: 5, restSeconds: 180)
            case .moderate:
                return (sets: 3, reps: 10, restSeconds: 90)
            case .low:
                return (sets: 3, reps: 15, restSeconds: 60)
            }
        case .cardio:
            return (sets: 1, reps: 20, restSeconds: 0)
        case .conditioning:
            return (sets: 3, reps: 20, restSeconds: 60)
        }
    }
}
