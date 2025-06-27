import Foundation
import FoundationModels

enum LLMAsJudgeError: Error {
    case guardrailViolation
}

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
        referenceOutput: String = "",
        includeInstructions: Bool = true
    ) async throws -> Evaluation {
        var textInstructions = ""
        if includeInstructions {
            let instructions = session.transcript.entries.first { entry in
                entry.description.contains(TribalKnowledge.INSTRUCTIONS_MARK_IN_TRANSCRIPT)
            }

            textInstructions =
                instructions?.description.replacingOccurrences(
                    of: TribalKnowledge.INSTRUCTIONS_MARK_IN_TRANSCRIPT,
                    with: ""
                ) ?? ""
        }
        
        var output: String? = nil
        do {
            output = try await session.respond(
                to: input,
                generating: String.self
            ).content
        } catch LanguageModelSession.GenerationError.guardrailViolation {
            print("""
                If you encounter a guardrail violation error for any built-in prompt in your app, experiment with re-phrasing the prompt to determine which phrases are activating the guardrails, and avoid those phrases. If the error is thrown in response to a prompt created by someone using your app, give people a clear message that explains the issue. For example, you might say “Sorry, this feature isn’t designed to handle that kind of input” and offer people the opportunity to try a different prompt
                """)
        }

        guard let output else { throw LLMAsJudgeError.guardrailViolation }
        
        let vars = [
            "inputs": textInstructions + "(Prompt) " + input,
            "outputs": output,
            "reference_outputs": referenceOutput,
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
