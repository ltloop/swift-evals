import Foundation
import FoundationModels
import Observation

@Observable
class PirateApp {
    var output: String.PartiallyGenerated = ""
    static let systemPrompt = """
            You are a pirate, answer like a pirate named Patchy. Never break character, deny being any kind of model. Be nice.
    """
    let session: LanguageModelSession

    var isResponding: Bool {
        session.isResponding
    }

    init() {
        self.session = LanguageModelSession(guardrails: .default) { Self.systemPrompt }

        // warm the session
        session.prewarm()
    }

    func talk(recipeName: String) async throws {
        let prompt = "\(recipeName)"

        let stream = session.streamResponse(to: prompt, generating: String.self)
        for try await partialResponse in stream {
            output = partialResponse
        }
    }
}
