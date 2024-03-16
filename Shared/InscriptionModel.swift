//
//  InscriptionModel.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 15/03/2024.
//

import Foundation

struct Inscription: Codable{
      let idBenevole: Int
      let idZoneBenevole: Int?
      let idPoste: Int
      let Creneau: String
      let Jour: String
      let isPresent: Bool
}
