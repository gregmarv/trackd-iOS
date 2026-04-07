import Foundation

// MARK: - Enums and Basic Types

nonisolated enum ProgramCategory: String, Codable, CaseIterable, Sendable {
    case running
    case strength
    case rehabilitation
}

// MARK: - Equipment Definition

nonisolated struct ProgramEquipment: Sendable {
    let required: [String]
    let recommended: [String]
    let optional: [String]
}

// MARK: - Program Phases

nonisolated struct ProgramPhase: Sendable {
    let name: String
    let weeks: (Int, Int)  // (start, end)
    let focus: String
}

// MARK: - Templates for Sessions

nonisolated struct WeekTemplate: Sendable {
    let week: Int
    let phase: String
    let weekFocus: String
    let sessions: [SessionTemplate]
}

nonisolated struct SessionTemplate: Identifiable, Sendable {
    var id: String { "\(sessionIndex)" }
    let sessionIndex: Int
    let sessionType: String  // easy_run, tempo_run, interval, long_run, push, pull, full_body, mobility, core, etc.
    let title: String
    let description: String
    let targetMinutes: Int
    let targetDistance: String?  // nil for non-running sessions
    let paceZone: String?  // nil for non-running sessions
    let structure: [SegmentTemplate]?  // for running sessions
    let exercises: [ExerciseTemplate]?  // for strength/rehab sessions
    let warmup: WarmupCooldown?
    let cooldown: WarmupCooldown?
    let notes: String?
}

nonisolated struct SegmentTemplate: Sendable {
    let label: String
    let minutes: Int
    let paceZone: String
    let type: String  // steady, intervals, strides, warmup, cooldown, hard, recovery, pickup
    let details: String?
    var resolvedPace: String? = nil
}

nonisolated struct ExerciseTemplate: Sendable {
    let name: String
    let sets: Int
    let reps: String
    let restSeconds: Int
    let weight: String?
    let tips: String
    let loggingType: String  // strength, mobility, cardio
}

nonisolated struct WarmupCooldown: Sendable {
    let description: String
    let durationMinutes: Int
}

// MARK: - Program Definition

nonisolated struct ProgramDefinition: Identifiable, Sendable {
    let id: String
    let name: String
    let subtitle: String
    let emoji: String
    let category: ProgramCategory
    let price: Double
    let durationWeeks: Int
    let sessionsPerWeek: Int
    let description: String
    let scienceExplanation: String
    let equipment: ProgramEquipment
    let phases: [ProgramPhase]
    let weekTemplates: [WeekTemplate]
}

// MARK: - Program Catalog

final class ProgramCatalog {
    static let shared = ProgramCatalog()

    let allPrograms: [ProgramDefinition]

    private init() {
        self.allPrograms = [
            ProgramCatalog.fiveKTraining,
            ProgramCatalog.halfMarathon,
            ProgramCatalog.strengthFoundations,
            ProgramCatalog.backPainRehab,
            ProgramCatalog.itBandRecovery,
        ]
    }

    func getProgram(_ id: String) -> ProgramDefinition? {
        return allPrograms.first { $0.id == id }
    }

    func getPrograms(category: ProgramCategory) -> [ProgramDefinition] {
        return allPrograms.filter { $0.category == category }
    }
}

// MARK: - Program Definitions

extension ProgramCatalog {

    // MARK: 5K Training Program

    static let fiveKTraining = ProgramDefinition(
        id: "5k_training_8wk",
        name: "5K Training",
        subtitle: "8-week progression to race day",
        emoji: "🏃",
        category: .running,
        price: 7.99,
        durationWeeks: 8,
        sessionsPerWeek: 3,
        description: "A comprehensive 8-week program designed to build speed and fitness for a 5K race. Combines easy runs, tempo work, and interval training with a strategic taper for peak performance.",
        scienceExplanation: "5K training develops aerobic capacity, running economy, and anaerobic threshold through varied-pace running. The periodized approach (base → build → peak → taper) optimizes adaptation while minimizing injury risk.",
        equipment: ProgramEquipment(
            required: [],
            recommended: ["running shoes"],
            optional: ["heart rate monitor"]
        ),
        phases: [
            ProgramPhase(name: "Base Building", weeks: (1, 3), focus: "Aerobic foundation and consistency"),
            ProgramPhase(name: "Build", weeks: (4, 6), focus: "Threshold and VO2 max development"),
            ProgramPhase(name: "Peak", weeks: (7, 7), focus: "Race-pace work and sharpness"),
            ProgramPhase(name: "Taper", weeks: (8, 8), focus: "Recovery and race readiness"),
        ],
        weekTemplates: [
            // Week 1
            WeekTemplate(
                week: 1,
                phase: "Base Building",
                weekFocus: "Establish aerobic base and running consistency",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "easy_run",
                        title: "Easy Run",
                        description: "Conversational pace. Focus on relaxed form and consistency.",
                        targetMinutes: 25,
                        targetDistance: "2.0-2.2 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 3, paceZone: "Z1", type: "warmup", details: "Gradual warmup to easy pace"),
                            SegmentTemplate(label: "Easy Run", minutes: 19, paceZone: "Z2", type: "steady", details: "Conversational pace, can speak in sentences"),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: "Easy jog to finish"),
                        ],
                        exercises: nil,
                        warmup: WarmupCooldown(description: "Light dynamic stretches", durationMinutes: 2),
                        cooldown: WarmupCooldown(description: "Walk and static stretches", durationMinutes: 3),
                        notes: "Keep this easy - focus on time on feet, not pace"
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "easy_run",
                        title: "Easy Run",
                        description: "Same as Monday - build consistency with easy miles.",
                        targetMinutes: 25,
                        targetDistance: "2.0-2.2 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 3, paceZone: "Z1", type: "warmup", details: "Gradual warmup to easy pace"),
                            SegmentTemplate(label: "Easy Run", minutes: 19, paceZone: "Z2", type: "steady", details: "Conversational pace"),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: "Easy jog to finish"),
                        ],
                        exercises: nil,
                        warmup: WarmupCooldown(description: "Light dynamic stretches", durationMinutes: 2),
                        cooldown: WarmupCooldown(description: "Walk and static stretches", durationMinutes: 3),
                        notes: "Recovery run - stay relaxed"
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "long_run",
                        title: "Long Run",
                        description: "Extended easy-paced run to build aerobic base and mental toughness.",
                        targetMinutes: 35,
                        targetDistance: "2.7-3.0 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 5, paceZone: "Z1", type: "warmup", details: "Easy warmup"),
                            SegmentTemplate(label: "Long Run", minutes: 27, paceZone: "Z2", type: "steady", details: "Easy, conversational pace throughout"),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: "Easy jog to finish"),
                        ],
                        exercises: nil,
                        warmup: WarmupCooldown(description: "Dynamic stretches", durationMinutes: 3),
                        cooldown: WarmupCooldown(description: "Walk and full-body stretches", durationMinutes: 5),
                        notes: "This is your longest run of the week. Fuel with water/sports drink if longer than 30 minutes"
                    ),
                ]
            ),
            // Week 2
            WeekTemplate(
                week: 2,
                phase: "Base Building",
                weekFocus: "Increase volume slightly while maintaining easy pace",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "easy_run",
                        title: "Easy Run",
                        description: "Easy-paced run to build aerobic base.",
                        targetMinutes: 27,
                        targetDistance: "2.1-2.3 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 3, paceZone: "Z1", type: "warmup", details: "Gradual warmup"),
                            SegmentTemplate(label: "Easy Run", minutes: 21, paceZone: "Z2", type: "steady", details: "Conversational pace"),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: "Easy jog"),
                        ],
                        exercises: nil,
                        warmup: WarmupCooldown(description: "Light dynamic stretches", durationMinutes: 2),
                        cooldown: WarmupCooldown(description: "Walk and static stretches", durationMinutes: 3),
                        notes: "Slight increase in volume from Week 1"
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "easy_run",
                        title: "Easy Run",
                        description: "Recovery run at easy pace.",
                        targetMinutes: 27,
                        targetDistance: "2.1-2.3 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 3, paceZone: "Z1", type: "warmup", details: "Warmup"),
                            SegmentTemplate(label: "Easy Run", minutes: 21, paceZone: "Z2", type: "steady", details: "Conversational pace"),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: "Cooldown jog"),
                        ],
                        exercises: nil,
                        warmup: WarmupCooldown(description: "Light stretches", durationMinutes: 2),
                        cooldown: WarmupCooldown(description: "Walk and stretches", durationMinutes: 3),
                        notes: "Keep recovery run at very easy pace"
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "long_run",
                        title: "Long Run",
                        description: "Extended easy run, slightly longer than Week 1.",
                        targetMinutes: 38,
                        targetDistance: "3.0-3.3 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 5, paceZone: "Z1", type: "warmup", details: "Easy warmup"),
                            SegmentTemplate(label: "Long Run", minutes: 30, paceZone: "Z2", type: "steady", details: "Easy, conversational pace"),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: "Easy jog to finish"),
                        ],
                        exercises: nil,
                        warmup: WarmupCooldown(description: "Dynamic stretches", durationMinutes: 3),
                        cooldown: WarmupCooldown(description: "Walk and stretches", durationMinutes: 5),
                        notes: "Gradual progression - continue building aerobic base"
                    ),
                ]
            ),
            // Weeks 3+ defined in full version
        ]
    )

    // MARK: Half Marathon Program

    static let halfMarathon = ProgramDefinition(
        id: "half_marathon_12wk",
        name: "Half Marathon",
        subtitle: "12-week race-specific training",
        emoji: "🏅",
        category: .running,
        price: 9.99,
        durationWeeks: 12,
        sessionsPerWeek: 4,
        description: "A comprehensive 12-week half marathon training program. Develops the specific aerobic and lactate threshold fitness needed to excel at 13.1 miles. Includes easy runs, tempo work, long runs, and structured speed work.",
        scienceExplanation: "Half marathon training emphasizes sustained lactate threshold (tempo pace), which is the intensity you can maintain for about 60 minutes. The 12-week progression builds from general fitness to race-specific strength with strategic recovery.",
        equipment: ProgramEquipment(
            required: [],
            recommended: ["running shoes", "watch or GPS"],
            optional: ["heart rate monitor", "race belt"]
        ),
        phases: [
            ProgramPhase(name: "Base", weeks: (1, 3), focus: "Aerobic foundation"),
            ProgramPhase(name: "Build", weeks: (4, 7), focus: "Threshold and long run development"),
            ProgramPhase(name: "Peak", weeks: (8, 10), focus: "Race-pace workouts"),
            ProgramPhase(name: "Taper", weeks: (11, 12), focus: "Recovery and race readiness"),
        ],
        weekTemplates: [
            // Week 1
            WeekTemplate(
                week: 1,
                phase: "Base",
                weekFocus: "Build aerobic base with varied-pace runs",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "easy_run",
                        title: "Easy Run",
                        description: "Easy-paced foundation run.",
                        targetMinutes: 30,
                        targetDistance: "2.3-2.5 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 3, paceZone: "Z1", type: "warmup", details: nil),
                            SegmentTemplate(label: "Easy Run", minutes: 24, paceZone: "Z2", type: "steady", details: nil),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: nil),
                        ],
                        exercises: nil,
                        warmup: nil,
                        cooldown: nil,
                        notes: nil
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "tempo_run",
                        title: "Tempo Run",
                        description: "Sustained harder effort at lactate threshold pace.",
                        targetMinutes: 32,
                        targetDistance: "2.5-2.7 miles",
                        paceZone: "Z1-Z4",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 5, paceZone: "Z1", type: "warmup", details: "Easy warmup"),
                            SegmentTemplate(label: "Tempo", minutes: 20, paceZone: "Z3", type: "hard", details: "Comfortably hard - can speak a few words"),
                            SegmentTemplate(label: "Cooldown", minutes: 7, paceZone: "Z1", type: "cooldown", details: "Easy jog"),
                        ],
                        exercises: nil,
                        warmup: nil,
                        cooldown: nil,
                        notes: "This is your first tempo - find a sustainable hard effort"
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "easy_run",
                        title: "Easy Run",
                        description: "Recovery run between harder sessions.",
                        targetMinutes: 25,
                        targetDistance: "2.0-2.2 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 3, paceZone: "Z1", type: "warmup", details: nil),
                            SegmentTemplate(label: "Easy Run", minutes: 19, paceZone: "Z2", type: "steady", details: nil),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: nil),
                        ],
                        exercises: nil,
                        warmup: nil,
                        cooldown: nil,
                        notes: "Keep very easy on recovery days"
                    ),
                    SessionTemplate(
                        sessionIndex: 4,
                        sessionType: "long_run",
                        title: "Long Run",
                        description: "Extended easy run to build aerobic endurance.",
                        targetMinutes: 45,
                        targetDistance: "3.5-3.8 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 5, paceZone: "Z1", type: "warmup", details: "Easy warmup"),
                            SegmentTemplate(label: "Long Run", minutes: 37, paceZone: "Z2", type: "steady", details: "Conversational pace throughout"),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: "Easy jog"),
                        ],
                        exercises: nil,
                        warmup: nil,
                        cooldown: nil,
                        notes: "Start fueling strategy if this run exceeds 45 minutes"
                    ),
                ]
            ),
            // Week 2
            WeekTemplate(
                week: 2,
                phase: "Base",
                weekFocus: "Consolidate base and introduce varied pace work",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "easy_run",
                        title: "Easy Run",
                        description: "Easy foundation run.",
                        targetMinutes: 32,
                        targetDistance: "2.5-2.7 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 3, paceZone: "Z1", type: "warmup", details: nil),
                            SegmentTemplate(label: "Easy Run", minutes: 26, paceZone: "Z2", type: "steady", details: nil),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: nil),
                        ],
                        exercises: nil,
                        warmup: nil,
                        cooldown: nil,
                        notes: nil
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "interval",
                        title: "Interval Workout",
                        description: "Introduce VO2 max intervals at faster than race pace.",
                        targetMinutes: 35,
                        targetDistance: "2.7-2.9 miles",
                        paceZone: "Z1-Z5",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 5, paceZone: "Z1", type: "warmup", details: "Easy warmup"),
                            SegmentTemplate(label: "Interval 1", minutes: 3, paceZone: "Z4", type: "hard", details: "5K pace or slightly faster"),
                            SegmentTemplate(label: "Recovery 1", minutes: 2, paceZone: "Z2", type: "recovery", details: "Easy jog"),
                            SegmentTemplate(label: "Interval 2", minutes: 3, paceZone: "Z4", type: "hard", details: "5K pace or slightly faster"),
                            SegmentTemplate(label: "Recovery 2", minutes: 2, paceZone: "Z2", type: "recovery", details: "Easy jog"),
                            SegmentTemplate(label: "Interval 3", minutes: 3, paceZone: "Z4", type: "hard", details: "5K pace or slightly faster"),
                            SegmentTemplate(label: "Cooldown", minutes: 7, paceZone: "Z1", type: "cooldown", details: "Easy jog to finish"),
                        ],
                        exercises: nil,
                        warmup: nil,
                        cooldown: nil,
                        notes: "Run intervals at 5K pace, focus on smooth form at faster pace"
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "easy_run",
                        title: "Easy Run",
                        description: "Recovery between hard efforts.",
                        targetMinutes: 28,
                        targetDistance: "2.2-2.4 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 3, paceZone: "Z1", type: "warmup", details: nil),
                            SegmentTemplate(label: "Easy Run", minutes: 22, paceZone: "Z2", type: "steady", details: nil),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: nil),
                        ],
                        exercises: nil,
                        warmup: nil,
                        cooldown: nil,
                        notes: "Keep this very easy"
                    ),
                    SessionTemplate(
                        sessionIndex: 4,
                        sessionType: "long_run",
                        title: "Long Run",
                        description: "Increase long run distance slightly.",
                        targetMinutes: 48,
                        targetDistance: "3.7-4.0 miles",
                        paceZone: "Z1-Z2",
                        structure: [
                            SegmentTemplate(label: "Warmup", minutes: 5, paceZone: "Z1", type: "warmup", details: "Easy warmup"),
                            SegmentTemplate(label: "Long Run", minutes: 40, paceZone: "Z2", type: "steady", details: "Conversational pace"),
                            SegmentTemplate(label: "Cooldown", minutes: 3, paceZone: "Z1", type: "cooldown", details: "Easy jog"),
                        ],
                        exercises: nil,
                        warmup: nil,
                        cooldown: nil,
                        notes: "Gradual build week to week"
                    ),
                ]
            ),
            // Weeks 3+ defined in full version
        ]
    )

    // MARK: Strength Foundations Program

    static let strengthFoundations = ProgramDefinition(
        id: "strength_foundations_12wk",
        name: "Strength Foundations",
        subtitle: "12-week full-body strength building",
        emoji: "💪",
        category: .strength,
        price: 9.99,
        durationWeeks: 12,
        sessionsPerWeek: 3,
        description: "A comprehensive 12-week strength training program for building functional strength and muscle. Uses a push/pull/full-body split with progressive overload to develop both upper and lower body strength.",
        scienceExplanation: "Progressive resistance training builds muscle through mechanical tension, metabolic stress, and muscle damage. The 12-week periodization emphasizes compound movements with strategic rep ranges: 8-12 reps for hypertrophy and muscle building.",
        equipment: ProgramEquipment(
            required: ["dumbbells"],
            recommended: ["bench or box", "pull-up bar"],
            optional: ["resistance bands", "foam roller"]
        ),
        phases: [
            ProgramPhase(name: "Foundation", weeks: (1, 4), focus: "Movement quality and base strength"),
            ProgramPhase(name: "Build", weeks: (5, 8), focus: "Hypertrophy and muscle development"),
            ProgramPhase(name: "Strength", weeks: (9, 12), focus: "Peak strength and power"),
        ],
        weekTemplates: [
            // Week 1
            WeekTemplate(
                week: 1,
                phase: "Foundation",
                weekFocus: "Establish movement patterns and baseline strength",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "push",
                        title: "Push Day A",
                        description: "Upper body pushing movements - chest, shoulders, triceps.",
                        targetMinutes: 50,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Dumbbell Bench Press",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Lower dumbbells to chest level, explode up. Keep shoulders packed.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Shoulder Press",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Press dumbbells overhead from shoulder height. Engage core.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Chest Flyes",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 45,
                                weight: "Light-Moderate",
                                tips: "Slight bend in elbows. Squeeze chest at the top.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Tricep Kickbacks",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 45,
                                weight: "Light",
                                tips: "Hinge forward, extend arm back. Full range of motion.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Plank",
                                sets: 3,
                                reps: "30-45 seconds",
                                restSeconds: 45,
                                weight: nil,
                                tips: "Neutral spine, engage core. No sagging hips.",
                                loggingType: "strength"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "5 minutes light cardio + arm circles", durationMinutes: 5),
                        cooldown: WarmupCooldown(description: "Upper body stretches", durationMinutes: 5),
                        notes: "First session - focus on form over weight. Use weights you can control."
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "pull",
                        title: "Pull Day",
                        description: "Back and bicep pulling movements.",
                        targetMinutes: 50,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Dumbbell Rows",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Row dumbbell to hip, squeeze shoulder blade back. One arm at a time.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Pullovers",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Slight arc motion, focus on chest and back contraction.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Bicep Curls",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 45,
                                weight: "Moderate",
                                tips: "Control the lowering phase. No momentum.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Reverse Flyes",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 45,
                                weight: "Light",
                                tips: "Rear shoulder and upper back activation. Squeeze at top.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Lat Pulldowns (or Resistance Band)",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 45,
                                weight: "Moderate",
                                tips: "Pull down to chest, engage lats.",
                                loggingType: "strength"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "Light cardio + arm/shoulder mobility", durationMinutes: 5),
                        cooldown: WarmupCooldown(description: "Upper body stretches", durationMinutes: 5),
                        notes: "Focus on back activation and controlled movements"
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "full_body",
                        title: "Full Body Day",
                        description: "Compound movements for full-body strength.",
                        targetMinutes: 55,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Dumbbell Goblet Squats",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Hold dumbbell at chest, squat to depth. Knees track over toes.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Romanian Deadlifts (RDLs)",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Hip hinge movement, slight knee bend. Feel hamstring stretch.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Single-Leg Dumbbell Deadlifts",
                                sets: 3,
                                reps: "8 per leg",
                                restSeconds: 45,
                                weight: "Light-Moderate",
                                tips: "Balance challenge - lower weight as needed. Core engagement.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Step-Ups",
                                sets: 3,
                                reps: "10-12 per leg",
                                restSeconds: 45,
                                weight: "Light-Moderate",
                                tips: "Drive through front leg. Can use bench or box.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dead Bug",
                                sets: 3,
                                reps: "8 per side",
                                restSeconds: 45,
                                weight: nil,
                                tips: "Core stability exercise. Alternate arm and leg extension.",
                                loggingType: "strength"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "5-10 minutes light cardio + dynamic stretches", durationMinutes: 8),
                        cooldown: WarmupCooldown(description: "Full-body stretches", durationMinutes: 5),
                        notes: "Compound movements build functional strength"
                    ),
                ]
            ),
            // Week 2
            WeekTemplate(
                week: 2,
                phase: "Foundation",
                weekFocus: "Increase volume and solidify form",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "push",
                        title: "Push Day B",
                        description: "Upper body push focus - chest, shoulders, triceps.",
                        targetMinutes: 52,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Dumbbell Incline Press",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Incline targets upper chest. Set bench to 30-45 degree angle.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Shoulder Press",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Press overhead from shoulder level. Full range of motion.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Machine Chest Press (or Dumbbell)",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 45,
                                weight: "Moderate",
                                tips: "Controlled movement. No bouncing at bottom.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Lateral Raises",
                                sets: 3,
                                reps: "12-15",
                                restSeconds: 45,
                                weight: "Light",
                                tips: "Shoulder isolation. Slight bend in elbows, raise to shoulder height.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Tricep Dips (or Bench Dips)",
                                sets: 3,
                                reps: "8-10",
                                restSeconds: 60,
                                weight: nil,
                                tips: "Lower body weight by bending elbows. Elbows at 45 degrees.",
                                loggingType: "strength"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "Cardio + shoulder mobility", durationMinutes: 5),
                        cooldown: WarmupCooldown(description: "Upper body stretches", durationMinutes: 5),
                        notes: "Week 2 variation - slight intensity increase"
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "pull",
                        title: "Pull Day",
                        description: "Back and bicep development.",
                        targetMinutes: 52,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Dumbbell Rows",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Drive elbow back, squeeze shoulder blade.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Single-Arm Rows",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Anti-rotation core challenge while building back.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Bicep Curls",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 45,
                                weight: "Moderate",
                                tips: "Slow eccentric (lowering) phase for muscle build.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Hammer Curls",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 45,
                                weight: "Moderate",
                                tips: "Neutral grip targets brachialis and forearms.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Face Pulls (or Dumbbell Raise)",
                                sets: 3,
                                reps: "12-15",
                                restSeconds: 45,
                                weight: "Light",
                                tips: "Posterior shoulder and rear delt work. Pull toward face.",
                                loggingType: "strength"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "Cardio + shoulder mobility", durationMinutes: 5),
                        cooldown: WarmupCooldown(description: "Upper body stretches", durationMinutes: 5),
                        notes: "Build back strength and size"
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "full_body",
                        title: "Full Body Day",
                        description: "Lower body and core emphasis.",
                        targetMinutes: 57,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Dumbbell Front Squats",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Dumbbells held at shoulders. Quad-dominant squat.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Romanian Deadlifts (RDLs)",
                                sets: 3,
                                reps: "10-12",
                                restSeconds: 60,
                                weight: "Moderate",
                                tips: "Hip hinge, hamstring focus. Slight knee bend.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Bulgarian Split Squats",
                                sets: 3,
                                reps: "10 per leg",
                                restSeconds: 45,
                                weight: "Light-Moderate",
                                tips: "Rear foot elevated. Single-leg stability.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Dumbbell Lunges",
                                sets: 3,
                                reps: "10 per leg",
                                restSeconds: 45,
                                weight: "Light-Moderate",
                                tips: "Forward or reverse lunges. Front knee at 90 degrees.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Pallof Press (or Plank with Rotation)",
                                sets: 3,
                                reps: "10 per side",
                                restSeconds: 45,
                                weight: "Light",
                                tips: "Anti-rotation core work. Resist rotation.",
                                loggingType: "strength"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "5-10 minutes light cardio + dynamic stretches", durationMinutes: 8),
                        cooldown: WarmupCooldown(description: "Full-body stretches", durationMinutes: 5),
                        notes: "Lower body development"
                    ),
                ]
            ),
            // Weeks 3+ defined in full version
        ]
    )

    // MARK: Back Pain Rehab Program

    static let backPainRehab = ProgramDefinition(
        id: "back_pain_rehab_8wk",
        name: "Back Pain Rehab",
        subtitle: "8-week recovery and prevention program",
        emoji: "🧘",
        category: .rehabilitation,
        price: 12.99,
        durationWeeks: 8,
        sessionsPerWeek: 3,
        description: "An evidence-based 8-week program for lower back pain relief and recovery. Emphasizes core activation, spinal stability, and progressive strengthening using the McGill Method. Designed for people with non-specific lower back pain.",
        scienceExplanation: "The McGill Method emphasizes spinal stability and motor control rather than spinal mobility. The Big Three exercises (curl-up, side plank, bird dog) reduce pain while building protective core strength without excessive spinal flexion.",
        equipment: ProgramEquipment(
            required: [],
            recommended: ["yoga mat", "foam roller"],
            optional: ["resistance band", "stability ball"]
        ),
        phases: [
            ProgramPhase(name: "Pain Relief", weeks: (1, 2), focus: "Reduce pain through gentle movement and activation"),
            ProgramPhase(name: "Core Activation", weeks: (3, 4), focus: "Build foundational core stability"),
            ProgramPhase(name: "Strength Building", weeks: (5, 6), focus: "Progressive strengthening"),
            ProgramPhase(name: "Integration", weeks: (7, 8), focus: "Return to normal activity"),
        ],
        weekTemplates: [
            // Week 1
            WeekTemplate(
                week: 1,
                phase: "Pain Relief",
                weekFocus: "Gentle mobility and activation to reduce pain",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "mobility",
                        title: "Gentle Mobility Session",
                        description: "Low-intensity mobility and pain relief focus.",
                        targetMinutes: 25,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Cat-Cow Mobility",
                                sets: 2,
                                reps: "10 repetitions",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Slow, controlled movement. Exhale during extension, inhale during flexion.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Bird Dog",
                                sets: 2,
                                reps: "8 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Extend opposite arm and leg. Engage core to prevent rotation.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Side Plank (Beginner)",
                                sets: 2,
                                reps: "15 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Knees on ground if needed. Maintain neutral spine.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Reverse Crunch",
                                sets: 2,
                                reps: "6 repetitions",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Minimal spinal flexion. Draw belly button toward spine. Stop before full crunch.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Child's Pose Hold",
                                sets: 2,
                                reps: "30 seconds",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Relaxing stretch. Breathe deeply. Safe for acute pain.",
                                loggingType: "mobility"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "Gentle stretching and deep breathing", durationMinutes: 3),
                        cooldown: WarmupCooldown(description: "Relaxation poses and stretching", durationMinutes: 3),
                        notes: "Go slowly. Stop if any movement increases pain. These are McGill-approved exercises."
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "core",
                        title: "McGill Big Three Focus",
                        description: "Core stability exercises emphasizing spinal control.",
                        targetMinutes: 25,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Curl-Up (McGill)",
                                sets: 2,
                                reps: "5-10 repetitions",
                                restSeconds: 45,
                                weight: nil,
                                tips: "Minimal spinal flexion. Support head with hands. Draw in belly button.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Side Plank (McGill)",
                                sets: 2,
                                reps: "15-20 seconds per side",
                                restSeconds: 45,
                                weight: nil,
                                tips: "Maintain neutral spine. Progress duration before adding difficulty.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Bird Dog (McGill)",
                                sets: 2,
                                reps: "8 per side",
                                restSeconds: 45,
                                weight: nil,
                                tips: "Hold each rep for 1-2 seconds. Core engagement prevents rotation.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Prone Hip Extension",
                                sets: 2,
                                reps: "8-10 repetitions",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Lie prone, lift one leg. Glute activation.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Quadruped Rocks",
                                sets: 2,
                                reps: "10 repetitions",
                                restSeconds: 30,
                                weight: nil,
                                tips: "On hands and knees, rock hips back slightly. Builds stability.",
                                loggingType: "mobility"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "Gentle mobility warm-up", durationMinutes: 3),
                        cooldown: WarmupCooldown(description: "Stretching", durationMinutes: 3),
                        notes: "Core activation without excessive spinal movement"
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "mobility",
                        title: "Stretching and Recovery",
                        description: "Gentle stretching and relaxation to aid recovery.",
                        targetMinutes: 20,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Knee to Chest Stretch",
                                sets: 2,
                                reps: "30 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Gentle glute and lower back stretch.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Spinal Rotation Stretch",
                                sets: 2,
                                reps: "30 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Supine twist. Gentle spinal mobility.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Hamstring Stretch",
                                sets: 2,
                                reps: "30 seconds per leg",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Seated or supine hamstring stretch.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Child's Pose Hold",
                                sets: 1,
                                reps: "45 seconds",
                                restSeconds: 0,
                                weight: nil,
                                tips: "Deep relaxation pose.",
                                loggingType: "mobility"
                            ),
                        ],
                        warmup: nil,
                        cooldown: WarmupCooldown(description: "Continued stretching", durationMinutes: 3),
                        notes: "Recovery focus - breathing and relaxation"
                    ),
                ]
            ),
            // Week 2
            WeekTemplate(
                week: 2,
                phase: "Pain Relief",
                weekFocus: "Maintain pain relief while beginning slight progressions",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "mobility",
                        title: "Gentle Mobility with Progression",
                        description: "Build on Week 1 with slight intensity increase.",
                        targetMinutes: 27,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Cat-Cow Mobility",
                                sets: 3,
                                reps: "10 repetitions",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Increase range of motion slightly. Controlled.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Bird Dog",
                                sets: 3,
                                reps: "8 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Add slight hold at extension (1 second).",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Side Plank (Beginner)",
                                sets: 2,
                                reps: "20 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Increase duration from Week 1.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Glute Bridge",
                                sets: 2,
                                reps: "10 repetitions",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Lie supine, knees bent. Lift hips. Glute activation.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Quadruped Rocks",
                                sets: 2,
                                reps: "12 repetitions",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Progress from Week 1.",
                                loggingType: "mobility"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "Gentle warm-up", durationMinutes: 3),
                        cooldown: WarmupCooldown(description: "Stretching", durationMinutes: 3),
                        notes: "Slight progression if pain permits"
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "core",
                        title: "McGill Big Three + Progression",
                        description: "Building stability with increased challenge.",
                        targetMinutes: 27,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Curl-Up (McGill)",
                                sets: 3,
                                reps: "8 repetitions",
                                restSeconds: 45,
                                weight: nil,
                                tips: "Increase reps from Week 1. Minimal spinal flexion.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Side Plank (McGill)",
                                sets: 3,
                                reps: "20-25 seconds per side",
                                restSeconds: 45,
                                weight: nil,
                                tips: "Progress duration. Maintain perfect form.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Bird Dog (McGill)",
                                sets: 3,
                                reps: "10 per side",
                                restSeconds: 45,
                                weight: nil,
                                tips: "Increase reps. Hold 1-2 seconds each rep.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Prone Hip Extension",
                                sets: 2,
                                reps: "10 repetitions per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Progress from Week 1.",
                                loggingType: "strength"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "Mobility warm-up", durationMinutes: 3),
                        cooldown: WarmupCooldown(description: "Stretching", durationMinutes: 3),
                        notes: "Progressively build core without pain"
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "mobility",
                        title: "Stretching and Recovery Plus",
                        description: "Extended stretching with breathing work.",
                        targetMinutes: 22,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Knee to Chest Stretch",
                                sets: 2,
                                reps: "40 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Increase duration from Week 1.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Spinal Rotation Stretch",
                                sets: 2,
                                reps: "40 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Gentle spinal mobility.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Piriformis Stretch",
                                sets: 2,
                                reps: "40 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Figure-4 position. Deep glute stretch.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Child's Pose Hold",
                                sets: 1,
                                reps: "60 seconds",
                                restSeconds: 0,
                                weight: nil,
                                tips: "Deep relaxation.",
                                loggingType: "mobility"
                            ),
                        ],
                        warmup: nil,
                        cooldown: WarmupCooldown(description: "Breathing and relaxation", durationMinutes: 3),
                        notes: "Focus on recovery and maintaining pain relief"
                    ),
                ]
            ),
            // Weeks 3+ defined in full version
        ]
    )

    // MARK: IT Band Recovery Program

    static let itBandRecovery = ProgramDefinition(
        id: "itband_rehab_6wk",
        name: "IT Band Recovery",
        subtitle: "6-week hip and IT band rehabilitation",
        emoji: "🏃‍♀️",
        category: .rehabilitation,
        price: 9.99,
        durationWeeks: 6,
        sessionsPerWeek: 3,
        description: "A 6-week evidence-based program for IT band syndrome recovery using the Fredericson protocol. Emphasizes hip abductor and external rotator strengthening combined with foam rolling and stretching.",
        scienceExplanation: "IT band syndrome is caused by weak hip abductors (especially gluteus medius). The Fredericson protocol uses targeted hip strengthening to correct muscle imbalances and improve running mechanics, reducing IT band tension.",
        equipment: ProgramEquipment(
            required: ["foam roller"],
            recommended: ["resistance band", "small weights"],
            optional: ["massage stick"]
        ),
        phases: [
            ProgramPhase(name: "Pain Management", weeks: (1, 2), focus: "Reduce inflammation through foam rolling and stretching"),
            ProgramPhase(name: "Hip Strengthening", weeks: (3, 4), focus: "Build hip abductor and external rotator strength"),
            ProgramPhase(name: "Return to Activity", weeks: (5, 6), focus: "Progress to pain-free running"),
        ],
        weekTemplates: [
            // Week 1
            WeekTemplate(
                week: 1,
                phase: "Pain Management",
                weekFocus: "Reduce IT band tension through foam rolling and stretching",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "mobility",
                        title: "Foam Rolling Focus",
                        description: "Systematic foam rolling to reduce IT band tension and inflammation.",
                        targetMinutes: 25,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Foam Roll: Lateral Quad",
                                sets: 1,
                                reps: "60 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Roll from knee to hip. Use body weight for pressure. Tender area - go slow.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Foam Roll: Glutes",
                                sets: 1,
                                reps: "60 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Sit on roller, roll glute area. Target tender points.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Foam Roll: TFL (Tensor Fasciae Latae)",
                                sets: 1,
                                reps: "45 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Small muscle at hip. Roll perpendicular to IT band.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Supine Figure-4 Stretch",
                                sets: 2,
                                reps: "30 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Deep glute and IT band stretch. Lie on back, cross ankle over knee.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Half-Kneeling Hip Flexor Stretch",
                                sets: 2,
                                reps: "30 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Open hip flexors. Lunge position.",
                                loggingType: "mobility"
                            ),
                        ],
                        warmup: nil,
                        cooldown: WarmupCooldown(description: "Extended stretching", durationMinutes: 3),
                        notes: "Foam rolling may be tender - this is normal. Persist but don't cause sharp pain."
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "core",
                        title: "Hip Strengthening Beginner",
                        description: "Introduce hip abductor and external rotator activation.",
                        targetMinutes: 25,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Side-Lying Clamshell",
                                sets: 2,
                                reps: "10 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "External rotation activation. Keep hips stacked, move only upper leg.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Side-Lying Hip Abduction",
                                sets: 2,
                                reps: "12 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Lift top leg straight up. Gluteus medius activation.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Prone Hip External Rotation",
                                sets: 2,
                                reps: "10 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Lie prone, bend knee to 90 degrees, rotate leg outward.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Glute Bridge",
                                sets: 2,
                                reps: "12 repetitions",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Lie supine, activate glutes at top of bridge.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Quadruped Hip Abduction",
                                sets: 2,
                                reps: "12 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "On hands and knees, lift leg out to side. Maintain neutral spine.",
                                loggingType: "strength"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "Gentle leg swings and mobility", durationMinutes: 3),
                        cooldown: WarmupCooldown(description: "Stretching", durationMinutes: 3),
                        notes: "Begin hip strengthening. This is critical for IT band recovery."
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "mobility",
                        title: "Stretching and Recovery",
                        description: "Comprehensive stretching for recovery.",
                        targetMinutes: 20,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Supine IT Band Stretch",
                                sets: 2,
                                reps: "45 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Cross leg over body, pull toward opposite shoulder.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Piriformis Stretch",
                                sets: 2,
                                reps: "45 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Deep glute stretch.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Quad Stretch",
                                sets: 2,
                                reps: "30 seconds per leg",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Standing or lying quad stretch.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Child's Pose Hold",
                                sets: 1,
                                reps: "30 seconds",
                                restSeconds: 0,
                                weight: nil,
                                tips: "Relaxation pose.",
                                loggingType: "mobility"
                            ),
                        ],
                        warmup: nil,
                        cooldown: WarmupCooldown(description: "Breathing and relaxation", durationMinutes: 3),
                        notes: "Recovery and continued tension relief"
                    ),
                ]
            ),
            // Week 2
            WeekTemplate(
                week: 2,
                phase: "Pain Management",
                weekFocus: "Continue pain management with progressive hip strengthening",
                sessions: [
                    SessionTemplate(
                        sessionIndex: 1,
                        sessionType: "mobility",
                        title: "Foam Rolling with Progression",
                        description: "Systematic foam rolling, maintain frequency.",
                        targetMinutes: 25,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Foam Roll: Lateral Quad",
                                sets: 1,
                                reps: "60 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Continue rolling. IT band tenderness should decrease gradually.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Foam Roll: Glutes",
                                sets: 1,
                                reps: "60 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Pressure and duration same as Week 1.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Foam Roll: TFL",
                                sets: 1,
                                reps: "60 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Increase duration from 45 to 60 seconds.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Supine Figure-4 Stretch",
                                sets: 2,
                                reps: "40 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Increase stretch duration. Lean into stretch more.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Half-Kneeling Hip Flexor Stretch",
                                sets: 2,
                                reps: "40 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Progress stretch intensity.",
                                loggingType: "mobility"
                            ),
                        ],
                        warmup: nil,
                        cooldown: WarmupCooldown(description: "Extended stretching", durationMinutes: 3),
                        notes: "Pain should be improving by end of Week 2"
                    ),
                    SessionTemplate(
                        sessionIndex: 2,
                        sessionType: "core",
                        title: "Hip Strengthening Progression",
                        description: "Increase reps and difficulty of hip strengthening.",
                        targetMinutes: 27,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Side-Lying Clamshell",
                                sets: 3,
                                reps: "12 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Increase reps from Week 1. Feel glute activation.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Side-Lying Hip Abduction",
                                sets: 3,
                                reps: "15 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Progress reps. Can add slight pause at top.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Prone Hip External Rotation",
                                sets: 3,
                                reps: "12 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Progress from Week 1. Key exercise for IT band.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Single-Leg Glute Bridge",
                                sets: 2,
                                reps: "8 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Progress to single-leg. More challenging.",
                                loggingType: "strength"
                            ),
                            ExerciseTemplate(
                                name: "Quadruped Hip Abduction",
                                sets: 3,
                                reps: "15 per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Progress reps from Week 1.",
                                loggingType: "strength"
                            ),
                        ],
                        warmup: WarmupCooldown(description: "Dynamic mobility warm-up", durationMinutes: 3),
                        cooldown: WarmupCooldown(description: "Stretching", durationMinutes: 3),
                        notes: "Increase hip strength to prevent recurrence"
                    ),
                    SessionTemplate(
                        sessionIndex: 3,
                        sessionType: "mobility",
                        title: "Stretching and Recovery",
                        description: "Comprehensive stretching routine.",
                        targetMinutes: 22,
                        targetDistance: nil,
                        paceZone: nil,
                        structure: nil,
                        exercises: [
                            ExerciseTemplate(
                                name: "Supine IT Band Stretch",
                                sets: 2,
                                reps: "60 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Increase duration from Week 1.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Piriformis Stretch",
                                sets: 2,
                                reps: "60 seconds per side",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Progress stretch duration.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Quad Stretch",
                                sets: 2,
                                reps: "40 seconds per leg",
                                restSeconds: 30,
                                weight: nil,
                                tips: "Increase duration.",
                                loggingType: "mobility"
                            ),
                            ExerciseTemplate(
                                name: "Child's Pose Hold",
                                sets: 1,
                                reps: "45 seconds",
                                restSeconds: 0,
                                weight: nil,
                                tips: "Extended relaxation pose.",
                                loggingType: "mobility"
                            ),
                        ],
                        warmup: nil,
                        cooldown: WarmupCooldown(description: "Breathing and relaxation", durationMinutes: 3),
                        notes: "Continue recovery focus"
                    ),
                ]
            ),
            // Weeks 3+ defined in full version
        ]
    )
}
