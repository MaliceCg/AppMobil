//
//  GameModel.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 27/03/2024.
//

import Foundation

struct Game: Codable, Identifiable {
    let idJeux: Int
    let NomJeu: String
    let Auteur: String
    let Editeur: String
    let NbJoueurs: String
    let AgeMin: String
    let Duree: String
    let TypePublic: String
    let LienNotice: String
    let Animation: String
    let Recu: String
    let Mecanisme: String
    let Theme: String
    let Tags: String
    let Description: String
    let LienVideoExplicative: String
    let idZoneBenevole: Int
  
    var id: Int {
      return idJeux
    }
}
