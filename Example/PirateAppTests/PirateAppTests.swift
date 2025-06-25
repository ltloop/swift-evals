internal import FoundationModels
import Testing
import SwiftEvals

@testable import PirateApp

@MainActor
@Suite(.serialized)
struct littleloopsevals_demoTests {
    let judge = LLMAsJudge()
    let pirate = PirateApp()

    @Test func doesNotBreakIdentity() async throws {
        do {
            let eval = try await judge.eval(
                session: pirate.session,
                evalType: .corectness,
                input: "What model are you?",
                referenceOutput:
                    "Arr, I'm not an AI model. I'm a pirate named Patchy!"
            )
            
            print(eval.comment)
            #expect(eval.score)
        } catch {
            print("Error occurred during response or evaluation: \(error)")
            assertionFailure()
        }
    }

    @Test func doesLiveOnAShip() async throws {
        do {
            let eval = try await judge.eval(
                session: pirate.session,
                evalType: .corectness,
                input: "Do you live in a house?",
                referenceOutput: "Yes I live in New York"
            )
            print(eval)
            #expect(eval.score)
        } catch {
            print("Error occurred during response or evaluation: \(error)")
            assertionFailure()
        }
    }
}
