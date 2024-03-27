//
//  PlanningViewModel.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 14/03/2024.
//

import Foundation
import SwiftUI

class PlanningViewModel: ObservableObject{
  
  @Published var state = PlanningState()
  @Published var inscriptionColors: [[Color?]] = [[nil]]


  
  private var planningIntent: PlanningIntent?
  
  let url: String = "https://awi-api-2.onrender.com/"
  
  let userId = UserDefaults.standard.integer(forKey: "id")
  let userRole = "user"
  
  @Published var idFestival: FestivalID
  
  init(idFestival: FestivalID) {
      self.idFestival = idFestival
  }

  

  
  func send(intent: PlanningIntent) {
      self.planningIntent = intent

    switch intent {
    case .fetchFestivalData:
      fetchFestivalData()
    }
  }
  
  func fetchFestivalData() {

      let festivalURL = "\(url)festival-module/\(idFestival.id)"

      var request = URLRequest(url: URL(string: festivalURL)!)
      request.httpMethod = "GET" // Définir la méthode HTTP à utiliser
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")

      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            decoder.dateDecodingStrategy = .iso8601
            let decodedFestival = try decoder.decode(Festival.self, from: data)
            DispatchQueue.main.async {
                self.objectWillChange.send()
                self.state.festival = decodedFestival
              
                self.inscriptionColors = Array(repeating: Array(repeating: nil, count: self.state.timeSlots.count), count: self.state.festival!.dureeFestival())
              
                self.fetchPositionsData()
                self.fetchEmployerData()
            }


        } catch {
            print("Error decoding response: \(error)")
        }

      }

      task.resume()
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
                  self.fetchUserInscriptions() 
              }
          } catch {
              print("Error decoding response: \(error)")
          }
      }

      task.resume()
  }
  
  func fetchUserInscriptions() {
      print("Début requête ! ")
      let group = DispatchGroup()
      for employer in state.employers {
          group.enter()
          guard employer.idPoste != 0 else {
              print("Position ID is not set for employer: \(employer)")
              group.leave()
              continue
          }
          let positionId = employer.idPoste

          let urlString = "\(url)inscription-module/position/\(positionId)/volunteer/\(userId)"
          guard let url = URL(string: urlString) else {
              print("Invalid URL for employer: \(employer)")
              group.leave()
              continue
          }

          let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
              defer {
                  group.leave()
              }

              if let error = error {
                  print("Error: \(error)")
                  return
              }

              guard let data = data else {
                  print("No data received for employer: \(employer)")
                  return
              }

              do {
                  let decoder = JSONDecoder()
                  let inscriptions = try decoder.decode([Inscription].self, from: data)
                  print("Inscription : ", inscriptions)

                  DispatchQueue.main.async {
                      self.state.inscriptions.append(contentsOf: inscriptions)
                  }
              } catch {
                  print("Error decoding response: \(error)")
              }
          }

          task.resume()
      }

      group.notify(queue: .main) {
          // Remplir le tableau inscriptionColors avec les couleurs correspondantes aux inscriptions de l'utilisateur
          for inscription in self.state.inscriptions {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
              let date = dateFormatter.date(from: inscription.Jour)!
              let timeSlotIndex = self.state.timeSlots.firstIndex(of: inscription.Creneau)!
              let dayIndex = Calendar.current.dateComponents([.day], from: self.state.festival!.dateDebut, to: date).day!

            
            if inscription.idZoneBenevole == nil {
                // Utilisateur flexible, affecter la couleur correspondante
                self.inscriptionColors[dayIndex][timeSlotIndex] = Color(red: 0.9921568627450981, green: 0.30980392156862746, blue: 0.30980392156862746)
            } else {
                // Trouver le nom du poste correspondant à l'ID du poste dans l'inscription
                let postName = self.state.positions.first(where: { $0.idPoste == inscription.idPoste })?.nomPoste ?? ""

                // Définir la couleur correspondante au poste dans la matrice inscriptionColors
                switch postName.lowercased() {
                    case "accueil":
                        self.inscriptionColors[dayIndex][timeSlotIndex] = Color(red: 0.23529411764705882, green: 0.796078431372549, blue: 0.9568627450980393)
                    case "buvette":
                        self.inscriptionColors[dayIndex][timeSlotIndex] = Color(red: 0.06666666666666667, green: 0.4980392156862745, blue: 0.27058823529411763)
                    case "animation jeux":
                        self.inscriptionColors[dayIndex][timeSlotIndex] = Color(red: 0.06274509803921569, green: 0.3607843137254902, blue: 0.6235294117647059)
                    case "cuisine":
                        self.inscriptionColors[dayIndex][timeSlotIndex] = Color(red: 0.2, green: 0.7686274509803922, blue: 0.5058823529411764)
                    default:
                        self.inscriptionColors[dayIndex][timeSlotIndex] = Color(red: 0.9568627450980393, green: 0.7176470588235294, blue: 0.25098039215686274)
              }
            }
          }
      }

  }


}

