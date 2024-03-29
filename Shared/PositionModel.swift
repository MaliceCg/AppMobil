//
//  PositionModel.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 15/03/2024.
//

import Foundation

struct Position: Codable, Identifiable, Hashable {
    let idPoste: Int
    let nomPoste: String
    let description: String
    let capacite: Int

    var id: Int {
        return idPoste
    }
}


