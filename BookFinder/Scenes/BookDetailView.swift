//
//  BookDetailView.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/25.
//

import SwiftUI
import Kingfisher

struct BookDetailView: View {
  let volume: Volume
  
  let noImage: some View = Image(systemName: "photo.artframe")
    .resizable()
    .aspectRatio(contentMode: .fit)
    .frame(width: 100, height: 100)
    .foregroundColor(Color(.lightGray))
    
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          KFImage.url(volume.info.smallThumbnailURL)
            .placeholder({ noImage })
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
          Spacer(minLength: 8)
          VStack(alignment: .leading) {
            Text(volume.info.title)
              .font(.title2)
              .foregroundColor(Color(.darkText))
              .padding(.bottom)
            Text(volume.info.authorsText)
              .font(.headline)
              .foregroundColor(Color(.darkGray))
            Text(volume.info.publishedDateText)
              .font(.subheadline)
              .foregroundColor(Color(.lightGray))
          }
          Spacer()
        }
        Divider()
        Text(volume.info.descriptionText)
          .font(.body)
        Spacer()
      }
      .padding(.all)
    }
    .navigationBarTitleDisplayMode(.inline)
  }
}
