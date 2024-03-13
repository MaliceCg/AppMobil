//
//  LoginViewModel.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 13/03/2024.
//

import Foundation
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
        case .enteredPseudo(let pseudo):
            state.pseudo = pseudo
        case .enteredPassword(let password):
            state.password = password
        case .submitTapped:
            state.isLoading = true
            // Effectuer la requête CRUD de connexion ici
            // En cas de succès, naviguer vers l'écran suivant
            // En cas d'échec, mettre à jour l'état avec le message d'erreur
        }
        self.intent = nil
    }
}
