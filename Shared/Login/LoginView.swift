//
//  LoginView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 13/03/2024.
//

import Foundation
struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.state.email)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onChange(of: viewModel.state.email) { newValue in
                    viewModel.send(intent: .enteredEmail(newValue))
                }
            TextField("Pseudo", text: $viewModel.state.pseudo)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onChange(of: viewModel.state.pseudo) {newValue in
                    viewModel.send(intent: .enteredPseudo(newValue))
                }
            SecureField("Password", text: $viewModel.state.password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onChange(of: viewModel.state.password) { newValue in
                    viewModel.send(intent: .enteredPassword(newValue))
                }
            Button(action: {
                viewModel.send(intent: .submitTapped)
            }) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.state.isLoading)
            if viewModel.state.error != nil {
                Text(viewModel.state.error!)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
