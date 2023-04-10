//
//  GPTTile.swift
//  ChatWithGPT
//
//  Created by Shubhayu Shrestha on 4/9/23.
//

import SwiftUI

struct GPTTile: View {
    var name = "Edward"
    
    var body: some View {
        VStack(){
            HStack(spacing: 20) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                    .padding(10)
                
                VStack(alignment: .center) {
                    Text("E")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                    HStack(){
                        Text(name)
                            .fontWeight(.light)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: "video")
                    .foregroundColor(.blue)
                    .padding(10)
            }
            .padding()
            
            Divider()
             .frame(height: 1)
             .padding(.horizontal, 30)
             .background(Color.gray.opacity(0.1))
        }
       
    }
}

struct GPTTile_Previews: PreviewProvider {
    static var previews: some View {
        GPTTile()
            .background(Color("Peach"))
    }
}
