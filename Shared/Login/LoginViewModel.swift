import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {

    @Published var state = LoginState()

    private var intent: LoginIntent?

    func send(intent: LoginIntent) {
        self.intent = intent
        processIntents()
    }

    private func processIntents() {
        guard let intent = intent else { return }
        switch intent {
        case .enteredEmail(let email):
            state.email = email
        case .enteredPassword(let password):
            state.password = password
        case .submitTapped:
            print("cc")
            state.isLoading = true
            postRequest()
        }
        self.intent = nil
    }

    private func postRequest() {
        let url = URL(string: "https://awi-api-2.onrender.com/authentication-module/signin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let parameters: [String: Any] = [
            "Email": state.email,
            "Password": state.password
        ]
        print(parameters)

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error: \(error)")
            return
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let str = String(data: data, encoding: .utf8)
                print("Received data:\n\(str ?? "")")
            }
        }
        task.resume()
    }
}
