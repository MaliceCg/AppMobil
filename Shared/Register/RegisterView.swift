//
//  RegisterView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 13/03/2024.
//

import SwiftUI

struct RegisterView: View {

    @ObservedObject var viewModel: RegisterViewModel
    @ObservedObject var LogViewModel = LoginViewModel()

    var body: some View {
        VStack {
            Text("S'inscrire")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            TextField("Pseudo", text: $viewModel.state.pseudo)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onChange(of: viewModel.state.pseudo) { newValue in
                    viewModel.send(intent: .enteredPseudo(newValue))
                }
            TextField("Email", text: $viewModel.state.email)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onChange(of: viewModel.state.email) { newValue in
                    viewModel.send(intent: .enteredEmail(newValue))
                }
            
            SecureField("Password", text: $viewModel.state.password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onChange(of: viewModel.state.password) { newValue in
                    viewModel.send(intent: .enteredPassword(newValue))
                }
            SecureField("Confirm Password", text: $viewModel.state.confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onChange(of: viewModel.state.confirmPassword) { newValue in
                    viewModel.send(intent: .enteredConfirmPassword(newValue))
                }
            Button(action: {
                viewModel.send(intent: .submitTapped)
            }) {
                Text("Register")
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
            if !viewModel.state.PasswordMatch {
                Text("Passwords do not match")
                    .foregroundColor(.red)
            }
            NavigationLink(destination: LoginView(viewModel: LogViewModel)) {
                Text("Se connecter")
                   
            }
        }
    
        .padding()
    }
}
