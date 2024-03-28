//
//  AccueilView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 13/03/2024.
//

import SwiftUI
struct AccueilView: View {
    @State private var festivals: [Festival] = []
    @State private var selectedFestivalId : FestivalID? //oblige d'etre optionnel pour le depart avant le choix
    @State private var selectedFestival : Festival?

    


    var body: some View {
        VStack {
                    if festivals.isEmpty {
                        Text("Il n’y a pas de festival prévu pour le moment.")
                            .font(.largeTitle)
                            .padding()
                    } else {
                        List(festivals) { festival in
                            Button(action: {
                                self.selectedFestivalId = FestivalID(id: festival.id)
                                self.selectedFestival = festival
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
                        if let selectedFestivalId = selectedFestivalId, let selectedFestival = selectedFestival {
                            NavigationLink(destination: TabBarView(festivalId: selectedFestivalId, festival: selectedFestival), isActive: Binding<Bool>(
                                                                    get: { selectedFestivalId != nil },
                                                                    set: { _ in }
                                                                )) {
                                EmptyView()
                            }
                        }
                    }
                }
                .navigationBarTitle("Choisir un festival")
                .onAppear {
                    self.fetchFestivals()
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


