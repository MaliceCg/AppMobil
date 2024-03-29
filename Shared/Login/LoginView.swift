//
//  LoginView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 13/03/2024.
//

import Foundation
import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var RegisViewModel = RegisterViewModel()

    var body: some View {
        if viewModel.isLoggedIn{
            AccueilView()
        }
        else {
        VStack {
            Text("Se connecter")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
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
            NavigationLink(destination: RegisterView(viewModel: RegisViewModel)) {
                Text("S'inscrire")
            }
        }
        .padding()
    }
    }
}
