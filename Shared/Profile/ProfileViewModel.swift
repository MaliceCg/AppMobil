//
//  ProfileViewModel.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 27/03/2024.
//
import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var state: ProfileState = ProfileState()
    private var cancellables = Set<AnyCancellable>()
    var didFetchUserData = false
    var isUpdateCompleted = false

    func sendIntent(intent: ProfileIntent) {
        switch intent {
        case .fetchUserData:
            fetchUserData()
        case .logout:
            logout()
        case .updateUserData(let editedInfo):
                updateUserData(editedInfo: editedInfo)

        }
    }

    private func fetchUserData() {
        state.loading = true // Mettez loading à true avant d'effectuer la requête réseau

        guard let idBenevole = UserDefaults.standard.string(forKey: "id") else {
            state.loading = false
            return
        }

        let url = URL(string: "https://awi-api-2.onrender.com/authentication-module/\(idBenevole)")!

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                print(data)
                return data
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finish")
                    break
                case .failure(let error):
                    print("Error fetching user data: \(error)")
                }
                self.state.loading = false // Mettez loading à false dans tous les cas de figure
                print(self.state.loading)
            }, receiveValue: { userData in
                self.state.userData = userData
                print(userData)
                self.didFetchUserData = true // Définissez la propriété sur true une fois que les données de l'utilisateur ont été récupérées avec succès
            })
            .store(in: &cancellables)
    }


    private func logout() {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "token")
        state.isLoggedIn = false
    }
    private func updateUserData(editedInfo: [String: Any]) {
        state.loading = true

        guard let idBenevole = UserDefaults.standard.string(forKey: "id") else {
            state.loading = false
            return
        }

        let url = URL(string: "https://awi-api-2.onrender.com/authentication-module/\(idBenevole)/update-account")!

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: editedInfo)

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) throws -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finish")
                    break
                case .failure(let error):
                    print("Error updating user data: \(error)")
                }
                self.state.loading = false
                self.isUpdateCompleted = true
            }, receiveValue: { _ in
                // La réponse n'est pas utilisée, vous pouvez mettre à jour votre état ici si nécessaire
                print("User data updated successfully")
            })
            .store(in: &cancellables)
    }

}
