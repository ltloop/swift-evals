# SwiftEvals

SwiftEvals is a Swift package designed to evaluate Apple's on-device Large Language Model (LLM) responses against expected criteria.
It provides a framework for assessing whether LLM outputs match desired characteristics such as correctness, conciseness, and checking for potential hallucinations.

## Features

- Multiple evaluation criteria:
  - Response correctness validation
  - Conciseness assessment
  - Hallucination detection
- LLM-as-judge approach for response evaluation

## Installation

### Swift Package Manager

Add SwiftEvals to your test target.

```swift
dependencies: [
    .package(url: "https://github.com/ltloop/swift-evals.git", from: "1.0.0")
]
```

## Usage

### Swift Test Example

Here's how to use SwiftEvals in your Swift tests to evaluate LLM responses:

```swift
import Testing
import SwiftEvals

struct LLMEvaluationTests {
    let judge = LLMAsJudge()
    let pirate = PirateApp()

    @Test func doesNotBreakIdentity() async throws {
        do {
            let eval = try await judge.eval(
                session: pirate.session,
                evalType: .corectness,
                input: "What model are you?",
                referenceOutput: "Arr, I'm not an AI model. I'm a pirate named Patchy!"
            )

            print(eval.comment)
            #expect(eval.score)
        } catch {
            print("Error occurred during response or evaluation: \(error)")
            assertionFailure()
        }
    }
}
```

## Example App

The package includes a Pirate app example that demonstrates how to use SwiftEvals to evaluate LLM responses in Swift tests. The pirate maintains its character identity and responds appropriately to various prompts.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Requirements

- iOS 26.0+ / macOS 26.0+
- Xcode 26.0+
