import FoundationModels

@Generable
public enum EvalType {
    case conciseness
    case corectness
    case custom(String)
    var value: String {
        switch self {
        case .conciseness:
            CONCISENESS_PROMPT
        case .corectness:
            CORRECTNESS_PROMPT
        case let .custom(prompt):
            prompt
        }
    }
}
