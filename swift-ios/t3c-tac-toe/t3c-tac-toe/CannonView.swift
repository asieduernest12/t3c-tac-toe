//
//  CannonView.swift
//  t3c-tac-toe
//
//  Created by mcman on 9/2/24.
//

import SwiftUI
import ConfettiSwiftUI



struct CannonView: View {
    @ObservedObject var confettiModel: ConfettiModel

    var body: some View {
        VStack(alignment: .center) {
            Button("🎉 \(confettiModel.count)"){
                confettiModel.increment()
                }
            .confettiCannon(counter: $confettiModel.count, repetitions: 3, repetitionInterval: 0.4)
            
        }
    }

    
   
}



class ConfettiModel : ObservableObject {
    @Published var count = 0
    
    func increment() {
        count += 1
    }
}


