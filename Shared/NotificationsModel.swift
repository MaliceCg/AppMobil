//
//  NotificationsModel.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 19/03/2024.
//
import Foundation

struct Notifications: Codable {
    let idNotif: Int
    let idFestival: Int
    let TexteNotification: String
    let Typee: String
    let dateEnvoi: Date

    enum CodingKeys: String, CodingKey {
        case idNotif
        case idFestival
        case TexteNotification = "TexteNotification"
        case Typee = "Type"
        case dateEnvoi = "DateEnvoi"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idNotif = try container.decode(Int.self, forKey: .idNotif)
        idFestival = try container.decode(Int.self, forKey: .idFestival)
        TexteNotification = try container.decode(String.self, forKey: .TexteNotification)
        Typee = try container.decode(String.self, forKey: .Typee)

        let dateString = try container.decode(String.self, forKey: .dateEnvoi)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Ajustez ce format en fonction de la chaîne de date reçue de votre backend
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateEnvoi = dateFormatter.date(from: dateString) ?? Date()
    }
}
