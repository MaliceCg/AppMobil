//
//  ProfileView.swift
//  AppMobile (iOS)
//
//  Created by Marine Cantaloube girona on 18/03/2024.
//

import SwiftUI

struct ProfileView: View {
    @State var selectedFestivalId: FestivalID

    var body: some View {
        Text("ProfileView avec le Festival ID : \(selectedFestivalId.id)")
    }
}
