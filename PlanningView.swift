//
//  PlanningView.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 14/03/2024.
//

import SwiftUI

struct PlanningView: View {
    @ObservedObject var viewModel: PlanningViewModel

    var body: some View {
        VStack {
            if let festival = viewModel.state.festival {
                Text(festival.nomFestival)
                    .font(.largeTitle)
            } else {
                Text("Chargement...")
            }
        }
        .onAppear {
            self.viewModel.send(intent: .fetchFestivalData)
        }
    }
}



