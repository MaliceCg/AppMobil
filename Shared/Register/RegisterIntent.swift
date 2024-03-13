//
//  RegisterIntent.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 13/03/2024.
//

import Foundation
enum RegisterIntent {
    case enteredPseudo(String)
    case enteredEmail(String)
    case enteredPassword(String)
    case enteredConfirmPassword(String)
    case submitTapped
}

