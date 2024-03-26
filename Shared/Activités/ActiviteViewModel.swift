//
//  ActiviteViewModel.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 22/03/2024.
//

import Foundation
import Combine

class ActiviteViewModel: ObservableObject {
    @Published var state: ActiviteState = ActiviteState()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchPostes()
        fetchInscription()
    }

    func send(_ intent: ActiviteIntent) {
        switch intent {
        case .fetchPostes:
            fetchPostes()
        case .fetchInscription:
            fetchInscription()
        case .setSelectedPoste(let poste):
            state.selectedPoste = poste
        case .unsubscribe(let inscriptionId, let idZoneBenevole, let creneau, let jour):
            handleUnsubscribe(inscriptionId: inscriptionId, idZoneBenevole: idZoneBenevole, creneau: creneau, jour: jour)
        }
    }

    private func fetchPostes() {
        // Mettez à jour cette fonction pour récupérer les postes à partir de l'API et mettre à jour state.postes
    }

    private func fetchInscription() {
        guard let userId = UserDefaults.standard.string(forKey: "id") else {
            print("User ID non trouvé")
            return
        }

        guard let url = URL(string: "https://awi-api-2.onrender.com/inscription-module/volunteer/\(userId)") else {
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
                let decodedInscriptions = try JSONDecoder().decode([Inscription].self, from: data)
                DispatchQueue.main.async {
                    print(decodedInscriptions)
                    self.state.inscription = decodedInscriptions
                }
            } catch {
                print("Erreur lors du décodage des données : \(error)")
            }
        }

        task.resume()
    }


    private func handleUnsubscribe(inscriptionId: String, idZoneBenevole: String, creneau: String, jour: String) {
        // Mettez à jour cette fonction pour gérer la désinscription et mettre à jour l'état si nécessaire
    }
}
