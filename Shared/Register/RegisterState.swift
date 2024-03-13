//
//  RegisterState.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 13/03/2024.
//

import Foundation
struct RegisterState {
    var pseudo: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword:String = ""
    var isLoading: Bool = false
    var error: String? = nil
    var PasswordMatch:Bool = true
}
