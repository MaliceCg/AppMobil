//
//  FestivalPicker.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 18/03/2024.
//

import SwiftUI
struct FestivalPicker: View {
    @Binding var selectedFestivalId: FestivalID

    var festivals: [Festival]

    var selectedFestivalName: String {
        festivals.first(where: { $0.id == selectedFestivalId.id })?.nomFestival ?? "Sélectionner un festival"
    }

    var body: some View {
            Menu {
                ForEach(festivals) { festival in
                    Button(action: {
                        selectedFestivalId = FestivalID(id: festival.id)
                    }) {
                        Text(festival.nomFestival)
                    }
                }
            } label: {
                Text(selectedFestivalName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ajouter un frame avec alignment: .leading
            }
        }
}
