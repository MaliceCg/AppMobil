//
//  ActiviteIntent.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 19/03/2024.
//

import Foundation
enum ActiviteIntent {
    case fetchPostes
    case fetchInscription
    case setSelectedPoste(String)
    case unsubscribe(String, String, String, String)
}
