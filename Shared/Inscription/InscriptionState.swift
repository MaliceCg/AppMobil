//
//  InscriptionState.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 19/03/2024.
//

import Foundation

class InscriptionState: ObservableObject {
  @Published var positions: [Position] = []
  @Published var employers: [Employer] = []
  @Published var filteredPositions: [Position] = []
}
