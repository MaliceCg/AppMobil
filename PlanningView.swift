//
//  PlanningView.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 14/03/2024.
//

import SwiftUI


struct PlanningView: View {
  
    
    @ObservedObject var viewModel: PlanningViewModel
  
    private func buildDaysView(for festival: Festival) -> some View {
        ForEach(0..<festival.dureeFestival(), id: \.self) { index in
            let date = Calendar.current.date(byAdding: .day, value: index, to: festival.dateDebut)!
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            let dayName = formatter.string(from: date)
            return Text(dayName)
                .font(.headline)
        }
    }

    var body: some View {
        VStack {
            if let festival = viewModel.state.festival {
                Text(festival.nomFestival)
                    .font(.largeTitle)
                HStack {
                    buildDaysView(for: festival)
                }
                .frame(maxWidth: .infinity)
            } else {
                Text("Chargement...")
            }
        }
        .onAppear {
            self.viewModel.fetchFestivalData()
        }
    }

    
}






