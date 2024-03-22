//
//  NotificationViewModel.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 19/03/2024.
//
import Foundation
import Combine

class NotificationViewModel: ObservableObject {
    @Published var idFestival: FestivalID
    @Published var state: NotificationState = NotificationState()
    private var notificationIntent: NotificationIntent?
    private var cancellables = Set<AnyCancellable>()

    init(idFestival: FestivalID) {
        self.idFestival = idFestival
        send(intent: .fetchNotif)
    }

    func send(intent: NotificationIntent) {
        self.notificationIntent = intent

        switch intent {
        case .fetchNotif:
            fetchNotif()
        }
    }

    private func fetchNotif() {
        print("fetching notification...")
        guard let url = URL(string: "https://awi-api-2.onrender.com/notif-module/\(idFestival.id)") else {
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
                let decodedNotifications = try JSONDecoder().decode([Notifications].self, from: data)
                let sortedNotifications = decodedNotifications.sorted { (notif1: Notifications, notif2: Notifications) -> Bool in
                    return notif1.dateEnvoi > notif2.dateEnvoi
                }
                DispatchQueue.main.async {
                    self.state.listNotif = sortedNotifications
                    self.state.loading = false
                }
            } catch {
                print("Erreur lors du décodage des données : \(error)")
            }
        }

        task.resume()
    }

}
