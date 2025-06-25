import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var modelOutput: String = ""
    @State var pirate = PirateApp()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Pirate App")
            TextField("Enter text", text: $inputText)
                .textFieldStyle(.roundedBorder)
                .padding([.horizontal])
                .onSubmit { runFoundationModel() }
            Button("Submit") {
                runFoundationModel()
            }
            .padding(.top, 8)
            if !pirate.output.isEmpty {
                Text(pirate.output)
                    .padding(.top, 12)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }

    func runFoundationModel() {
        Task {
            try? await pirate.talk(recipeName: inputText)
        }
    }
}

#Preview {
    ContentView()
}
