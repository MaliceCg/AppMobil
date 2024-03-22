//
//  InscriptionViewModel.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 19/03/2024.
//

import Foundation

class InscriptionViewModel: ObservableObject{
    
  @Published var state = InscriptionState()
  
  let url: String = "https://awi-api-2.onrender.com/"
  
  @Published var idFestival: FestivalID
  
  init(idFestival: FestivalID) {
      self.idFestival = idFestival
  }
  
  
}
