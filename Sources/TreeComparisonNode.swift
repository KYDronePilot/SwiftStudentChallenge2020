//
//  TreeComparisonCircle.swift
//  SwiftChallengeProject
//
//  Created by Michael Galliers on 5/11/20.
//  Copyright © 2020 Michael Galliers. All rights reserved.
//

import SwiftUI

struct TreeComparisonCircle: View {
    var text: String
    var scaleFactor: CGFloat
    
    var body: some View {
        Text(text)
            .foregroundColor(.black)
            .font(.system(size: 14 * scaleFactor))
            .frame(width: 50 * scaleFactor, height: 50 * scaleFactor)
            .background(Circle().stroke(Color.black))
            .background(Circle().fill(Color.white))
            .padding(5)
//            .scaleEffect(scaleFactor)
    }
}

struct TreeComparisonCircle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TreeComparisonCircle(text: "B > C", scaleFactor: 0.9)
        }
        .frame(width: 500, height: 500)
        .background(Color.white)
    }
}
