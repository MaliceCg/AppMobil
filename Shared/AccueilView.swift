//
//  AccueilView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 13/03/2024.
//

import SwiftUI

struct AccueilView: View {
    @State private var festivals: [Festival] = []
    @State private var selectedFestivalId: Int? = nil

    var body: some View {
        NavigationView {
            VStack {
                if festivals.isEmpty {
                    Text("Il n’y a pas de festival prévu pour le moment.")
                        .font(.largeTitle)
                        .padding()
                } else {
                    List(festivals) { festival in
                        Button(action: {
                            self.selectedFestivalId = festival.id
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(festival.nomFestival)
                                        .font(.headline)
                                    Text("Du \(formatDate(festival.dateDebut)) au \(formatDate(festival.dateFin))")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Choisir un festival")
            .onAppear {
                self.fetchFestivals()
            }
        }
    }

    private func fetchFestivals() {
        guard let url = URL(string: "https://awi-api-2.onrender.com/festival-module") else {
            print("URL invalide")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Erreur lors de la récupération des données : \(error)")
                return
            }

            guard let data = data else {
                print("Pas de données reçues")
                return
            }

            do {
                let decodedFestivals = try JSONDecoder().decode([Festival].self, from: data)
                DispatchQueue.main.async {
                    print(decodedFestivals)
                    self.festivals = decodedFestivals
                }
            } catch {
                print("Erreur lors du décodage des données : \(error)")
            }
        }

        task.resume()
    }
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
