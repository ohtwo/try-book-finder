//
//  LoadingCell.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/29.
//

import UIKit
import SnapKit
import Then
import SkeletonView

class LoadingCell: BookCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
    self.isSkeletonable = true
    
    pictureView.isSkeletonable = true
    titleLabel.isSkeletonable = true
    authorLabel.isSkeletonable = true
    dateLabel.isSkeletonable = true
    
    self.showAnimatedGradientSkeleton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
