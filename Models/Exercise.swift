import Foundation

nonisolated enum ExerciseCategory: String, Codable, CaseIterable, Sendable {
    case upperBody = "upper_body"
    case lowerBody = "lower_body"
    case core
    case cardio
    case fullBody = "full_body"
    case flexibility
}

nonisolated enum ExerciseType: String, Codable, CaseIterable, Sendable {
    case strength
    case cardio
    case power
    case mobility
}

nonisolated enum LoggingType: String, Codable, CaseIterable, Sendable {
    case reps
    case distance
    case time
    case weight
    case duration
}

nonisolated enum ExerciseDifficulty: String, Codable, CaseIterable, Sendable {
    case tooHard = "too_hard"
    case justRight = "just_right"
    case tooEasy = "too_easy"
}

nonisolated struct Exercise: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let exerciseId: String
    let name: String
    let category: ExerciseCategory
    let equipment: [String]
    let targetSystems: [String]
    let type: ExerciseType
    let sets: Int?
    let reps: Int?
    let restSeconds: Int?
    let weight: Double?
    let tips: [String]
    let loggingType: LoggingType
    let videoUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case exerciseId
        case name
        case category
        case equipment
        case targetSystems
        case type
        case sets
        case reps
        case restSeconds
        case weight
        case tips
        case loggingType
        case videoUrl
    }

    init(
        id: UUID = UUID(),
        exerciseId: String,
        name: String,
        category: ExerciseCategory,
        equipment: [String] = [],
        targetSystems: [String] = [],
        type: ExerciseType,
        sets: Int? = nil,
        reps: Int? = nil,
        restSeconds: Int? = nil,
        weight: Double? = nil,
        tips: [String] = [],
        loggingType: LoggingType,
        videoUrl: String? = nil
    ) {
        self.id = id
        self.exerciseId = exerciseId
        self.name = name
        self.category = category
        self.equipment = equipment
        self.targetSystems = targetSystems
        self.type = type
        self.sets = sets
        self.reps = reps
        self.restSeconds = restSeconds
        self.weight = weight
        self.tips = tips
        self.loggingType = loggingType
        self.videoUrl = videoUrl
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
}

nonisolated struct LoggedExercise: Codable, Identifiable, Sendable {
    let id: UUID
    let exercise: Exercise
    var completed: Bool
    var actualSets: Int?
    var actualReps: Int?
    var actualWeight: Double?
    var rating: ExerciseDifficulty?

    enum CodingKeys: String, CodingKey {
        case id
        case exercise
        case completed
        case actualSets
        case actualReps
        case actualWeight
        case rating
    }

    init(
        id: UUID = UUID(),
        exercise: Exercise,
        completed: Bool = false,
        actualSets: Int? = nil,
        actualReps: Int? = nil,
        actualWeight: Double? = nil,
        rating: ExerciseDifficulty? = nil
    ) {
        self.id = id
        self.exercise = exercise
        self.completed = completed
        self.actualSets = actualSets
        self.actualReps = actualReps
        self.actualWeight = actualWeight
        self.rating = rating
    }
}
