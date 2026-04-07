import Foundation
import SwiftData

nonisolated enum WorkoutCategory: String, Codable, CaseIterable, Sendable {
    case strength
    case running
    case cycling
    case swimming
    case sports
    case mobility
    case mixed
}

nonisolated enum SessionType: String, Codable, CaseIterable, Sendable {
    case easy
    case moderate
    case hard
    case interval
    case tempo
    case longRun = "long_run"
    case recovery
    case cross
}

nonisolated struct RunSegment: Codable, Identifiable, Sendable {
    let id: UUID
    let label: String
    let minutes: Int
    let paceZone: String
    let type: String
    let details: String?
    let resolvedPace: Double?

    // Actual logged data
    var actualDistance: Double?
    var actualTime: Int?
    var actualPace: Double?
    var splits: [Double]?

    enum CodingKeys: String, CodingKey {
        case id
        case label
        case minutes
        case paceZone
        case type
        case details
        case resolvedPace
        case actualDistance
        case actualTime
        case actualPace
        case splits
    }

    init(
        id: UUID = UUID(),
        label: String,
        minutes: Int,
        paceZone: String,
        type: String,
        details: String? = nil,
        resolvedPace: Double? = nil,
        actualDistance: Double? = nil,
        actualTime: Int? = nil,
        actualPace: Double? = nil,
        splits: [Double]? = nil
    ) {
        self.id = id
        self.label = label
        self.minutes = minutes
        self.paceZone = paceZone
        self.type = type
        self.details = details
        self.resolvedPace = resolvedPace
        self.actualDistance = actualDistance
        self.actualTime = actualTime
        self.actualPace = actualPace
        self.splits = splits
    }
}

@Model
final class Workout {
    @Attribute(.unique) var id: UUID
    var date: Date
    var category: WorkoutCategory
    var isPrescriptive: Bool
    var sessionType: SessionType
    var title: String
    var workoutDescription: String?
    var targetMinutes: Int?
    var targetDistance: Double?
    var targetPace: Double?
    var duration: Int?
    var exercises: [LoggedExercise]
    var structure: [RunSegment]
    var warmup: String?
    var cooldown: String?
    var actualPace: Double?
    var actualDistance: Double?
    var overallRating: ExerciseDifficulty?
    var notes: String?
    var completed: Bool
    var programId: UUID?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        date: Date,
        category: WorkoutCategory,
        isPrescriptive: Bool = false,
        sessionType: SessionType = .easy,
        title: String,
        workoutDescription: String? = nil,
        targetMinutes: Int? = nil,
        targetDistance: Double? = nil,
        targetPace: Double? = nil,
        duration: Int? = nil,
        exercises: [LoggedExercise] = [],
        structure: [RunSegment] = [],
        warmup: String? = nil,
        cooldown: String? = nil,
        actualPace: Double? = nil,
        actualDistance: Double? = nil,
        overallRating: ExerciseDifficulty? = nil,
        notes: String? = nil,
        completed: Bool = false,
        programId: UUID? = nil
    ) {
        self.id = id
        self.date = date
        self.category = category
        self.isPrescriptive = isPrescriptive
        self.sessionType = sessionType
        self.title = title
        self.workoutDescription = workoutDescription
        self.targetMinutes = targetMinutes
        self.targetDistance = targetDistance
        self.targetPace = targetPace
        self.duration = duration
        self.exercises = exercises
        self.structure = structure
        self.warmup = warmup
        self.cooldown = cooldown
        self.actualPace = actualPace
        self.actualDistance = actualDistance
        self.overallRating = overallRating
        self.notes = notes
        self.completed = completed
        self.programId = programId
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    // MARK: - Computed Properties

    var isRunning: Bool {
        category == .running && !isPrescriptive == false
    }

    var isPrescriptiveRun: Bool {
        category == .running && isPrescriptive
    }

    var completedExerciseCount: Int {
        exercises.filter { $0.completed }.count
    }

    var totalExerciseCount: Int {
        exercises.count
    }

    var exerciseCompletionPercentage: Double {
        guard totalExerciseCount > 0 else { return 0 }
        return Double(completedExerciseCount) / Double(totalExerciseCount)
    }

    var isFullyCompleted: Bool {
        guard !exercises.isEmpty else { return completed }
        return exercises.allSatisfy { $0.completed } && completed
    }

    var durationMinutes: Int {
        duration ?? targetMinutes ?? 0
    }

    var workoutDate: Date {
        date
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var formattedTime: String {
        guard let duration = duration else { return "0m" }
        if duration < 60 {
            return "\(duration)m"
        } else {
            let hours = duration / 60
            let minutes = duration % 60
            return "\(hours)h \(minutes)m"
        }
    }

    var completedRunSegmentCount: Int {
        structure.filter { $0.actualDistance != nil || $0.actualTime != nil }.count
    }

    var totalRunSegmentCount: Int {
        structure.count
    }

    var runSegmentCompletionPercentage: Double {
        guard totalRunSegmentCount > 0 else { return 0 }
        return Double(completedRunSegmentCount) / Double(totalRunSegmentCount)
    }
}
