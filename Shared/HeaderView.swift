//
//  HeaderView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 18/03/2024.
//
import SwiftUI

struct HeaderView: View {
    @Binding var selectedFestivalId: FestivalID
    @Binding var currentPage: String
    @State private var festivals: [Festival] = []

    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.05882352941, green: 0.3529411765, blue: 0.6196078431, alpha: 1)), Color(#colorLiteral(red: 0.2274509804, green: 0.7843137255, blue: 0.9411764706, alpha: 1))]), startPoint: .top, endPoint: .bottom)
    }
    var body: some View {
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text(getH3Text())
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(getH1Text())
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        FestivalPicker(selectedFestivalId: $selectedFestivalId, festivals: festivals)
                            .frame(width: 250, height: 30)
                            .clipped()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                    Spacer()
                }
            }
            .frame(height: 180)
            .background(gradient)
            .foregroundColor(.white)
            .onAppear {
                self.fetchFestivals()
            }
        }
    
    private func getH3Text() -> String {
            switch currentPage {
            case "dashboard":
                return "Bienvenue sur votre"
            case "profile":
                return "Vous êtes sur votre"
            case "inscription":
                return "Ici vous pouvez vous"
            case "notifications":
                return "Ici vous pouvez retrouver vos"
            case "planning":
                return "Voici votre"
            case "activites":
                return "Voici vos"
            default:
                return "Titre par défaut"
            }
        }

        private func getH1Text() -> String {

            switch currentPage {
            case "dashboard":
                return "Tableau de bord"
            case "profile":
                return "Profil utilisateur"
            case "inscription":
                return "Inscrire à une activité"
            case "notifications":
                return "Notifications"
            case "planning":
                return "Planning"
            case "activites":
                return "Activités Choisies"
            default:
                return "Titre par défaut"
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

}
