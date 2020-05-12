//
//  TreeResultNode.swift
//  SwiftChallengeProject
//
//  Created by Michael Galliers on 5/11/20.
//  Copyright © 2020 Michael Galliers. All rights reserved.
//

import SwiftUI

struct TreeResultNode: View {
    var text: String
    var scaleFactor: CGFloat
    
    var body: some View {
        Text(text)
            .foregroundColor(.black)
            .font(.system(size: 15 * scaleFactor))
            .padding(6)
            .frame(width: 40 * scaleFactor * (CGFloat(text.count) / 6.7) + 20, height: 30 * scaleFactor)
            .background(Rectangle().stroke(Color.black))
            .background(Rectangle().fill(Color.white))
            .padding(2)
            .padding(.vertical, 8)
//            .scaleEffect(scaleFactor)
    }
}

struct TreeResultNode_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TreeResultNode(text: "A, B, C, D, E, F", scaleFactor: 1)
        }
        .frame(width: 500, height: 500)
        .background(Color.white)
    }
}
