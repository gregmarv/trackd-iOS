import Foundation

/// Manages program enrollment, session resolution, and progression through training phases.
/// Uses canonical types from Models/ and Data/.
final class ProgramEngine {
    private let vdotPaceTable: VDOTPaceTable

    init(vdotPaceTable: VDOTPaceTable = VDOTPaceTable()) {
        self.vdotPaceTable = vdotPaceTable
    }

    /// Resolves pace strings for a running session template using VDOT table
    func resolveSessionPaces(session: SessionTemplate, vdot: Int) -> SessionTemplate {
        guard let structure = session.structure else { return session }

        let resolvedStructure = structure.map { segment -> SegmentTemplate in
            let resolvedPace = vdotPaceTable.getPace(vdot: vdot, zone: PaceZone(rawValue: segment.paceZone) ?? .easy)
            return SegmentTemplate(
                label: segment.label,
                minutes: segment.minutes,
                paceZone: segment.paceZone,
                type: segment.type,
                details: segment.details,
                resolvedPace: resolvedPace
            )
        }

        return SessionTemplate(
            sessionIndex: session.sessionIndex,
            sessionType: session.sessionType,
            title: session.title,
            description: session.description,
            targetMinutes: session.targetMinutes,
            targetDistance: session.targetDistance,
            paceZone: session.paceZone,
            structure: resolvedStructure,
            exercises: session.exercises,
            warmup: session.warmup,
            cooldown: session.cooldown,
            notes: session.notes
        )
    }

    /// Check if all sessions in a week are complete
    func isWeekComplete(programState: ProgramState, program: ProgramDefinition) -> Bool {
        let weekTemplate = program.weekTemplates.first { $0.week == programState.currentWeek }
        guard let sessions = weekTemplate?.sessions else { return false }

        return sessions.allSatisfy { session in
            programState.completedSessions.contains {
                $0.week == programState.currentWeek && $0.sessionIndex == session.sessionIndex
            }
        }
    }

    /// Get the next uncompleted session for the current week
    func getNextSession(programState: ProgramState, program: ProgramDefinition) -> SessionTemplate? {
        let weekTemplate = program.weekTemplates.first { $0.week == programState.currentWeek }
        guard let sessions = weekTemplate?.sessions else { return nil }

        return sessions.first { session in
            !programState.completedSessions.contains {
                $0.week == programState.currentWeek && $0.sessionIndex == session.sessionIndex
            }
        }
    }
}
