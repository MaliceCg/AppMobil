import Foundation
import SwiftUI

struct LoginResponse: Codable {
    let data: LoginData
}

struct LoginData: Codable {
    let token: String
    let id: Int
    let email: String
    let role: String
    let pseudo: String
}

class LoginViewModel: ObservableObject {

    @Published var state = LoginState()
    @Published var isLoggedIn = false

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
                do {
                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(decodedResponse.data.token, forKey:"token")
                        UserDefaults.standard.set(decodedResponse.data.role, forKey: "role")
                        UserDefaults.standard.set(decodedResponse.data.id, forKey: "id")

                        // Définir isLoggedIn à true pour déclencher une mise à jour de la vue
                        self.isLoggedIn = true
                    }
                }
                catch{
                    print("Error decoding response: \(error)")
                }
            }
        }
        task.resume()
    }
}
