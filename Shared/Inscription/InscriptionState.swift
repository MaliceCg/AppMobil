//
//  InscriptionState.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 19/03/2024.
//

import Foundation

class InscriptionState: ObservableObject {
    @Published var festival: Festival? = nil
    
    var loading: Bool = true
}
