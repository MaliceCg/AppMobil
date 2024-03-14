//
//  RegisterViewModel.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 13/03/2024.
//

import Foundation
class RegisterViewModel: ObservableObject {

    @Published var state = RegisterState()
    @Published var isRegister = false

    private var intent: RegisterIntent?

    func send(intent: RegisterIntent) {
        self.intent = intent
        processIntents()
    }

    private func processIntents() {
        guard let intent = intent else { return }
        switch intent {
        case .enteredPseudo(let pseudo):
            state.pseudo = pseudo
        case .enteredEmail(let email):
            state.email = email
        case .enteredPassword(let password):
            state.password = password
        case .enteredConfirmPassword(let confirmPassword):
                state.confirmPassword = confirmPassword
                state.PasswordMatch = state.password == confirmPassword
        case .submitTapped:
                if state.PasswordMatch {
                    state.isLoading = true
                    postRequest()
                } else {
                    state.error = "Passwords do not match"
                }
            }
        self.intent = nil
    }
    
    private func postRequest() {
        let url = URL(string: "https://awi-api-2.onrender.com/authentication-module/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let parameters: [String: Any] = [
            "Pseudo": state.pseudo,
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
                self.isRegister = true
                let str = String(data: data, encoding: .utf8)
                print("Received data:\n\(str ?? "")")
                
            }
        }
        task.resume()
    }
}

