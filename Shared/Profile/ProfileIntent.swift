//
//  ProfileIntent.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 27/03/2024.
//

import Foundation
enum ProfileIntent {
    case fetchUserData
    case logout
    case updateUserData([String: Any])
}
