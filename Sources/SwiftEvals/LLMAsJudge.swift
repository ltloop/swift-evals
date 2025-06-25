import Foundation
import FoundationModels

public struct LLMAsJudge {
    let session: LanguageModelSession

    public init() {
        self.session = LanguageModelSession(model: .default)
        self.session.prewarm()
    }

    public func eval(
        session: LanguageModelSession,
        evalType: EvalType = .corectness,
        input: String,
        referenceOutput: String? = nil
    ) async throws -> Evaluation {
        let instructions = session.transcript.entries.first { entry in
            entry.description.contains(TribalKnowledge.INSTRUCTIONS_MARK_IN_TRANSCRIPT)
        }

        let textInstructions =
            instructions?.description.replacingOccurrences(
                of: TribalKnowledge.INSTRUCTIONS_MARK_IN_TRANSCRIPT,
                with: ""
            ) ?? ""

        let output = try await session.respond(
            to: input,
            generating: String.self
        ).content

        let vars = [
            "inputs": textInstructions + "(Prompt) " + input,
            "outputs": output,
            "reference_outputs": referenceOutput ?? "",
        ]
        let hydrated = evalType.value.hydrate(vars)

        print("~~~To be judged~~~\n\(hydrated)")

        return try await self.session.respond(
            to: hydrated,
            generating: Evaluation.self,
            options: .init(temperature: 0)
        ).content
    }
}
