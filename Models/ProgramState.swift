import Foundation
import SwiftData

nonisolated struct CalibratedParams: Codable, Sendable {
    var vdotEstimate: Double?
    var preferredDays: [String]?
    var strengthTier: String?
    var mobilityLevel: String?
    var recoveryNeeded: Bool?
    var intensity: String?

    enum CodingKeys: String, CodingKey {
        case vdotEstimate
        case preferredDays
        case strengthTier
        case mobilityLevel
        case recoveryNeeded
        case intensity
    }

    init(
        vdotEstimate: Double? = nil,
        preferredDays: [String]? = nil,
        strengthTier: String? = nil,
        mobilityLevel: String? = nil,
        recoveryNeeded: Bool? = nil,
        intensity: String? = nil
    ) {
        self.vdotEstimate = vdotEstimate
        self.preferredDays = preferredDays
        self.strengthTier = strengthTier
        self.mobilityLevel = mobilityLevel
        self.recoveryNeeded = recoveryNeeded
        self.intensity = intensity
    }
}

nonisolated struct CompletedSession: Codable, Identifiable, Sendable {
    let id: UUID
    let week: Int
    let sessionIndex: Int
    let workoutId: UUID
    let completedAt: Date
    let rating: ExerciseDifficulty?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case id
        case week
        case sessionIndex
        case workoutId
        case completedAt
        case rating
        case notes
    }

    init(
        id: UUID = UUID(),
        week: Int,
        sessionIndex: Int,
        workoutId: UUID,
        completedAt: Date,
        rating: ExerciseDifficulty? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.week = week
        self.sessionIndex = sessionIndex
        self.workoutId = workoutId
        self.completedAt = completedAt
        self.rating = rating
        self.notes = notes
    }
}

@Model
final class ProgramState {
    @Attribute(.unique) var programId: UUID
    var startDate: Date
    var currentWeek: Int
    var completedSessions: [CompletedSession]
    var assessmentResults: Assessment?
    var calibratedParams: CalibratedParams
    var isActive: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        programId: UUID = UUID(),
        startDate: Date,
        currentWeek: Int = 1,
        completedSessions: [CompletedSession] = [],
        assessmentResults: Assessment? = nil,
        calibratedParams: CalibratedParams = CalibratedParams(),
        isActive: Bool = true
    ) {
        self.programId = programId
        self.startDate = startDate
        self.currentWeek = currentWeek
        self.completedSessions = completedSessions
        self.assessmentResults = assessmentResults
        self.calibratedParams = calibratedParams
        self.isActive = isActive
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    // MARK: - Computed Properties

    var weeksSinceStart: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear], from: startDate, to: Date())
        return components.weekOfYear ?? 0
    }

    var daysActive: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: Date())
        return components.day ?? 0
    }

    var completedSessionCount: Int {
        completedSessions.count
    }

    var sessionsCompletedInCurrentWeek: Int {
        completedSessions.filter { $0.week == currentWeek }.count
    }

    var sessionsCompletedByWeek: [Int: Int] {
        var result: [Int: Int] = [:]
        for session in completedSessions {
            result[session.week, default: 0] += 1
        }
        return result
    }

    var lastCompletedSession: CompletedSession? {
        completedSessions.max { $0.completedAt < $1.completedAt }
    }

    var lastCompletedDate: Date? {
        lastCompletedSession?.completedAt
    }

    var programDurationDays: Int {
        daysActive
    }

    var averageSessionsPerWeek: Double {
        let activeWeeks = max(1, weeksSinceStart + 1)
        return Double(completedSessionCount) / Double(activeWeeks)
    }

    var completionRate: Double {
        guard !completedSessions.isEmpty else { return 0 }
        let expectedSessions = max(1, currentWeek) * 4
        return Double(completedSessionCount) / Double(expectedSessions)
    }

    var vdot: Double? {
        calibratedParams.vdotEstimate
    }

    var preferredTrainingDays: [String]? {
        calibratedParams.preferredDays
    }

    func sessionCountForWeek(_ week: Int) -> Int {
        completedSessions.filter { $0.week == week }.count
    }

    func hasCompletedSession(week: Int, index: Int) -> Bool {
        completedSessions.contains { $0.week == week && $0.sessionIndex == index }
    }
}
