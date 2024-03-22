//
//  ActiviteState.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 19/03/2024.
//

import Foundation
struct ActiviteState {
   
    var postes: [Position] = []
    var selectedPoste: String = ""
    var hasActivities: Bool = false
    var userId: String = ""
    var idFestival: String = ""
    var loading: Bool = true
}
