import Foundation

/// Manages exercise progression based on performance ratings and calculates weight adjustments
final class ProgressionEngine {
    /// The percentage increase for positive feedback
    private let easyIncrementPercent: Double = 0.05 // 5%
    /// The percentage decrease for negative feedback
    private let hardDecrementPercent: Double = 0.10 // 10%

    init() {}

    /// Calculates suggested weight for next session based on performance rating
    /// - Parameters:
    ///   - currentWeight: Weight used in the most recent session (in lbs)
    ///   - rating: User's rating of difficulty
    /// - Returns: Suggested weight for next session
    func suggestNextWeight(currentWeight: Double, rating: DifficultyRating) -> Double {
        let nextWeight: Double

        switch rating {
        case .tooEasy:
            nextWeight = currentWeight * (1 + easyIncrementPercent)
        case .justRight:
            nextWeight = currentWeight
        case .tooHard:
            nextWeight = currentWeight * (1 - hardDecrementPercent)
        }

        // Round to nearest 2.5 lbs for practical implementation
        return (nextWeight / 2.5).rounded() * 2.5
    }

    /// Estimates one-rep max using Epley formula
    /// Formula: 1RM = weight × (1 + reps/30)
    /// - Parameters:
    ///   - weight: Weight lifted
    ///   - reps: Repetitions completed
    /// - Returns: Estimated one-rep maximum
    func estimateOneRepMax(weight: Double, reps: Int) -> Double {
        guard reps > 0 else { return weight }
        let oneRepMax = weight * (1 + Double(reps) / 30.0)
        return (oneRepMax / 2.5).rounded() * 2.5
    }

    /// Suggests reps for next session based on training phase and 1RM
    /// - Parameters:
    ///   - phase: Current training phase (hypertrophy, strength, endurance)
    ///   - oneRepMax: Estimated one-rep maximum
    /// - Returns: Suggested repetitions
    func suggestReps(phase: TrainingPhase, oneRepMax: Double) -> (reps: Int, weight: Double) {
        switch phase {
        case .strength:
            // Strength: 1-6 reps at 85-100% of 1RM
            let weight = oneRepMax * 0.90
            return (reps: 5, weight: weight)

        case .hypertrophy:
            // Hypertrophy: 6-12 reps at 70-85% of 1RM
            let weight = oneRepMax * 0.75
            return (reps: 10, weight: weight)

        case .endurance:
            // Endurance: 12+ reps at 50-70% of 1RM
            let weight = oneRepMax * 0.60
            return (reps: 15, weight: weight)
        }
    }

    /// Calculates volume (sets × reps × weight) to track progressive overload
    /// - Parameters:
    ///   - sets: Number of sets
    ///   - reps: Repetitions per set
    ///   - weight: Weight used
    /// - Returns: Total volume
    func calculateVolume(sets: Int, reps: Int, weight: Double) -> Double {
        return Double(sets * reps) * weight
    }

    /// Tracks an exercise performance and returns next recommendation
    /// - Parameters:
    ///   - exerciseHistory: Historical records for this exercise
    ///   - currentPerformance: Most recent performance data
    /// - Returns: Recommendation for next session
    func getNextRecommendation(
        exerciseHistory: [ExercisePerformance],
        currentPerformance: ExercisePerformance
    ) -> ProgressionRecommendation {
        guard !exerciseHistory.isEmpty else {
            // First time: use base weight
            return ProgressionRecommendation(
                suggestedWeight: currentPerformance.weight,
                suggestedReps: currentPerformance.reps,
                reasoning: "First session baseline"
            )
        }

        let oneRepMax = estimateOneRepMax(weight: currentPerformance.weight, reps: currentPerformance.reps)
        let nextWeight = suggestNextWeight(currentWeight: currentPerformance.weight, rating: currentPerformance.difficultyRating)

        return ProgressionRecommendation(
            suggestedWeight: nextWeight,
            suggestedReps: currentPerformance.reps,
            reasoning: "1RM: \(String(format: "%.1f", oneRepMax)) lbs - Rating: \(currentPerformance.difficultyRating.rawValue)"
        )
    }
}

// MARK: - Supporting Types

nonisolated enum DifficultyRating: String, Codable, Sendable {
    case tooEasy = "too_easy"
    case justRight = "just_right"
    case tooHard = "too_hard"
}

nonisolated enum TrainingPhase: String, Codable, Sendable {
    case strength
    case hypertrophy
    case endurance
}

nonisolated struct ExercisePerformance: Codable, Sendable {
    let exerciseId: String
    let weight: Double
    let reps: Int
    let sets: Int
    let difficultyRating: DifficultyRating
    let date: Date
    let notes: String?
}

nonisolated struct ProgressionRecommendation: Codable, Sendable {
    let suggestedWeight: Double
    let suggestedReps: Int
    let reasoning: String
}
