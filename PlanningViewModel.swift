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
  
  private var planningIntent: PlanningIntent?
  
  let url: String = "https://awi-api-2.onrender.com/"
  
  let userId = 1
  let userRole = "user"
  
  let idFestival: Int = 1
  
  func send(intent: PlanningIntent) {
      self.planningIntent = intent

      switch intent {
      case .fetchFestivalData:
          fetchFestivalData()
      case .fetchPositionsData:
          fetchPositionsData()
      case .fetchEmployerData:
          fetchEmployerData()
      }
  
  }
  
  func fetchFestivalData() {

      let festivalURL = "\(url)festival-module/\(idFestival)"

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
      let urlEmployer = "\(url)employer-module/festival/\(idFestival)"
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
              }
          } catch {
              print("Error decoding response: \(error)")
          }
      }

      task.resume()
  }


}

