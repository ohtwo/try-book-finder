//
//  BookDetailView.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/25.
//

import SwiftUI

struct BookDetailView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          Rectangle()
            .fill(.gray)
            .frame(width: 100, height: 100)
          VStack(alignment: .leading) {
            Text("Book Title")
              .font(.title)
              .foregroundColor(Color(.darkText))
              .padding(.bottom)
            Text("Author")
              .font(.headline)
              .foregroundColor(Color(.darkGray))
            Text("Published Date")
              .font(.subheadline)
              .foregroundColor(Color(.lightGray))
          }
          Spacer()
        }
        Divider()
        Text(description)
          .font(.body)
        Spacer()
      }
      .padding(.all)
    }
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct BookDetailView_Previews: PreviewProvider {
  static var previews: some View {
    BookDetailView()
  }
}

let description = """
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
"""
