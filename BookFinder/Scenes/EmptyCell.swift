//
//  EmptyCell.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/25.
//

import UIKit
import SnapKit
import Then

class EmptyCell: UITableViewCell, Reusable {

  let titleLabel = UILabel().then {
    $0.text = "No search result :("
    $0.font = .preferredFont(forTextStyle: .headline)
    $0.textColor = .lightGray
    $0.textAlignment = .center
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    
    contentView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.edges.equalTo(self)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
