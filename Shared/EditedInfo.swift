//
//  EditedInfo.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 27/03/2024.
//

import Foundation
struct EditedInfo: Codable,Hashable {
    var idBenevole: Int
    var pseudo: String = ""
    var prenom: String = ""
    var nom: String = ""
    var email: String = ""
    var adresse: String = ""
    var ville: String = ""
    var telephone: String = ""
    var regime: String = ""
    var tailletTShirt: String = ""
    var statutHebergement: String = ""
    var jeuPrefere: String = ""
}

