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
            let dayName = formatter.string(from: date).capitalized
            return VStack(alignment: .leading, spacing: 8) {
                Text(dayName)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 36)
                if index < viewModel.hasInscription.count {
                    ForEach(Array(zip(viewModel.state.timeSlots, viewModel.hasInscription[index])), id: \.0) { timeSlot, hasInscription in
                        Text(timeSlot)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 36)
                            .background(hasInscription ? Color.red : Color.clear) // Mettre en forme le créneau en fonction de la présence ou non d'une inscription
                    }
                } else {
                    ForEach(viewModel.state.timeSlots, id: \.self) { timeSlot in
                        Text(timeSlot)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 36)
                            .background(Color.clear)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 8)
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






