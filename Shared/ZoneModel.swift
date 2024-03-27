//
//  ZoneModel.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 26/03/2024.
//

import Foundation
struct Zone: Codable, Hashable, Identifiable {
    let idZoneBenevole: Int
    let nomZoneBenevole: String
    let capacite: Int
    let idFestival: Int
    let idPoste: Int

    var id: Int {
        return idFestival.hashValue ^ idPoste.hashValue ^ idZoneBenevole.hashValue
    }
}


