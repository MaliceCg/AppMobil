//
//  PlanningView.swift
//  AppMobile (iOS)
//
//  Created by Pain des bites on 14/03/2024.
//

import SwiftUI


struct PlanningView: View {
    @Binding var festivalId: FestivalID
    /*
    
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
                ForEach(Array(zip(viewModel.state.timeSlots, viewModel.inscriptionColors[index])), id: \.0) { timeSlot, inscriptionColor in
                    Text(timeSlot)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(inscriptionColor ?? Color.clear)
                                .frame(height: 40)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0)
                                .frame(height: 40)
                        )
                        .padding(.bottom, 36)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 8)
        }
    }


*/
    var body: some View {
        VStack {
            /*
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
             */
    }

    
}
}





