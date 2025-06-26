import FoundationModels

@Generable
public enum EvalType {
    case conciseness
    case corectness
    case hallucination
    case custom(String)
    var value: String {
        switch self {
        case .conciseness:
            CONCISENESS_PROMPT
        case .corectness:
            CORRECTNESS_PROMPT
        case .hallucination:
            HALLUCINATION_PROMPT
        case let .custom(prompt):
            prompt
        }
    }
}
