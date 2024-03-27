//
//  UserModel.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 26/03/2024.
//


import Foundation

struct User: Codable,Hashable {
    var idBenevole: Int
    var Pseudo: String
    var Prenom: String?
    var Nom: String?
    var Email: String
    var Adresse: String?
    var Ville: String?
    var Telephone: String?
    var Regime: String?
    var TailletTShirt: String?
    var StatutHebergement: String?
    var JeuPrefere: String?
}
