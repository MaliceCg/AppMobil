//
//  InscriptionViewModel.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 19/03/2024.
//

import Foundation
import SwiftUI

class InscriptionViewModel: ObservableObject{
    
  @Published var state = InscriptionState()
  
  @Published var selectedPosition: Position?
  
  let url: String = "https://awi-api-2.onrender.com/"
  
  @Published var idFestival: FestivalID
  @Published var festival : Festival
  
  var timeSlots: [String] = ["09-11", "11-14", "14-17", "17-20", "20-22"]
  
  
  init(idFestival: FestivalID, festival: Festival) {
      self.idFestival = idFestival
      self.festival = festival
  }
  
  private var inscriptionIntent: InscriptionIntent?
  
  func send(intent: InscriptionIntent) {
      self.inscriptionIntent = intent

    switch intent {
      case .fetchPositionFestival:
        fetchPositionsData()
        fetchEmployerData()
        getPositionsForFestival()
      
      case .navigateToInscriptionCreneauView:
        print("Coucou")
    }
    
    
  }
  
  func fetchPositionsData() {
      let url = "\(url)position-module"
    
      guard let url = URL(string: url) else {
          print("Invalid URL")
          return
      }

      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          if let error = error {
              print("Error: \(error)")
              return
          }

          guard let data = data else {
              print("Error: No data received")
              return
          }

          do {
              let decoder = JSONDecoder()
              let decodedPositions = try decoder.decode([Position].self, from: data)
              print("data2 : ", decodedPositions)
              DispatchQueue.main.async {
                  self.state.positions = decodedPositions
              }
          } catch {
              print("Error decoding response: \(error)")
          }
      }

      task.resume()
  }

  func fetchEmployerData() {
    let urlEmployer = "\(url)employer-module/festival/\(idFestival.id)"
      guard let url = URL(string: urlEmployer) else {
          print("Invalid URL")
          return
      }
      print("Request : ", url)
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
          if let error = error {
              print("Error: \(error)")
              return
          }

          guard let data = data else {
              print("No data received")
              return
          }

          do {
              let decoder = JSONDecoder()
              let employers = try decoder.decode([Employer].self, from: data)
              print("data : ", employers)
              DispatchQueue.main.async {
                  self.state.employers = employers
                  self.getPositionsForFestival()
              }
          } catch {
              print("Error decoding response: \(error)")
          }
      }

      task.resume()
  }

  func getPositionsForFestival() {
          // Filtre les positions employées par ce festival
    
      self.objectWillChange.send()
      self.state.filteredPositions = self.state.positions.filter { position in
            self.state.employers.contains { employer in
                employer.idPoste == position.idPoste
            }
        }
    }
  
  func getColorForPosition(position: Position) -> Color {
      switch position.nomPoste.lowercased() {
      case "accueil":
          return Color(red: 0.23529411764705882, green: 0.796078431372549, blue: 0.9568627450980393)
      case "buvette":
          return Color(red: 0.06666666666666667, green: 0.4980392156862745, blue: 0.27058823529411763)
      case "animation jeux":
          return Color(red: 0.06274509803921569, green: 0.3607843137254902, blue: 0.6235294117647059)
      case "cuisine":
          return Color(red: 0.2, green: 0.7686274509803922, blue: 0.5058823529411764)
      default:
          return Color(red: 0.9568627450980393, green: 0.7176470588235294, blue: 0.25098039215686274)
      }
  }

  
  
}
