//
//  Festival.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 14/03/2024.
//

import Foundation
struct FestivalID: Identifiable, Hashable {
    var id: Int

    static func == (lhs: FestivalID, rhs: FestivalID) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
struct Festival: Identifiable, Decodable {
    let id: Int
    let nomFestival: String
    let dateDebut: Date
    let dateFin: Date
    let ville: String?

    enum CodingKeys: String, CodingKey {
        case id = "idFestival"
        case nomFestival = "NomFestival"
        case dateDebut = "DateDebut"
        case dateFin = "DateFin"
        case ville = "Ville"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        nomFestival = try container.decode(String.self, forKey: .nomFestival)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateDebut = try dateFormatter.date(from: try container.decode(String.self, forKey: .dateDebut)) ?? Date()
        dateFin = try dateFormatter.date(from: try container.decode(String.self, forKey: .dateFin)) ?? Date()
        ville = try container.decodeIfPresent(String.self, forKey: .ville)
    }
  
    func dureeFestival() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: dateDebut, to: dateFin)
        return (components.day ?? 0) + 1
    }
}
