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
  @Published var flexiblePosition: [Position]?
  @Published var zoneSelected: Zone?
  @Published var zones: [Zone]?
  @Published var inscriptionUser: [Inscription]?
  @Published var games: [Game]?
  
  let url: String = "https://awi-api-2.onrender.com/"
  let userId = UserDefaults.standard.integer(forKey: "id")

  
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
        fetchUserInscription()
      
      case .navigateToInscriptionZoneView:
        fetchZonePoste()
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
  
  func fetchUserInscription(){
    let urlInscription = "\(url)inscription-module/volunteer/\(userId)"
      guard let url = URL(string: urlInscription) else {
          print("Invalid URL")
          return
      }
      print(url)
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
              let inscriptionsUser = try decoder.decode([Inscription].self, from: data)
              print("InscriptionUser : ", inscriptionsUser)
              DispatchQueue.main.async {
                  self.inscriptionUser = inscriptionsUser
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
  
  func postInscription(timeSlot: String, date: Date, completion: @escaping (Result<Bool, Error>) -> Void) {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      let dateString = formatter.string(from: date)
    
      let inscriptionData: [String: Any]
    
      if let zone = zoneSelected{
        inscriptionData = [
            "idBenevole": userId,
            "idZoneBenevole": zone.idZoneBenevole,
            "idPoste": selectedPosition?.idPoste ?? 0,
            "Creneau": timeSlot,
            "Jour": dateString,
            "isPresent": false
        ]
      } else {
        inscriptionData = [
            "idBenevole": userId,
            "idZoneBenevole": selectedPosition?.idPoste ?? 0,
            "idPoste": selectedPosition?.idPoste ?? 0,
            "Creneau": timeSlot,
            "Jour": dateString,
            "isPresent": false
        ]
      }
    
      

      guard let url = URL(string: "\(url)inscription-module") else {
          print("Invalid URL")
          return
      }

      let jsonData = try? JSONSerialization.data(withJSONObject: inscriptionData)

      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = jsonData

      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                // Mettez à jour l'état ou effectuez d'autres actions en fonction de la réponse
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            }
        }

        task.resume()
  }

  func fetchZonePoste() {
      guard let selectedPosition = selectedPosition else {
          print("Selected position is nil")
          return
      }

      let urlString = "\(url)volunteer-area-module/\(idFestival.id)/\(selectedPosition.idPoste)"
    
      print(urlString)

      guard let url = URL(string: urlString) else {
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
              let decodedZones = try decoder.decode([Zone].self, from: data)
              print("DecodedZone : ", decodedZones)
              DispatchQueue.main.async {
                  self.zones = decodedZones
              }
          } catch {
              print("Error decoding response: \(error)")
          }
      }

      task.resume()
  }
  
  func fetchGamesForZone(idZone: Int) {
      let urlString = "\(url)game-module/zoneBenevole/\(idZone)"

      guard let url = URL(string: urlString) else {
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
              let decodedGames = try decoder.decode([Game].self, from: data)
              DispatchQueue.main.async {
                  self.games = decodedGames
              }
          } catch {
              print("Error decoding response: \(error)")
          }
      }

      task.resume()
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

  func isUserAlreadyRegistered(timeSlot: String, date: Date) -> Bool {
      guard let inscriptionUser = inscriptionUser else { return false }

      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

      let filteredInscriptions = inscriptionUser.filter { inscription in
          let inscriptionDate = formatter.date(from: inscription.Jour)!
          return inscription.Creneau == timeSlot && Calendar.current.isDate(inscriptionDate, inSameDayAs: date)
      }

      return !filteredInscriptions.isEmpty
  }

  

  
  
}
