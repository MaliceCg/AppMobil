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
      }
  }
  
  func fetchFestivalData() {

      let festivalURL = "\(url)festival-module/\(idFestival)"
      print(festivalURL)

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
            print(decodedFestival)
            DispatchQueue.main.async {
                self.objectWillChange.send()
                self.state.festival = decodedFestival
                print("festival : ", self.state.festival)
            }


        } catch {
            print("Error decoding response: \(error)")
        }

      }

      task.resume()
  }
  

}

