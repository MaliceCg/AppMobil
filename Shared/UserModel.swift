//
//  UserModel.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 26/03/2024.
//


import Foundation

struct User: Codable, Hashable {
    let idBenevole: Int
    let pseudo: String
    let nom: String
    let prenom: String
    let email: String
    let password: String
    let role: String
    let tailletTShirt: String
    let regime: String
    let statutHebergement: String
    let nombreEditionPrecedente: Int?
    let adresse: String
    let ville: String
    let codePostal: Int?
    let telephone: String
    let jeuPrefere: String
    let idAssociation: Int?
}
