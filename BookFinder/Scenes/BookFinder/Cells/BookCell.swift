//
//  BookCell.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class BookCell: UITableViewCell, Reusable {
  
  let pictureView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .lightGray
  }
  let titleLabel = UILabel().then {
    $0.font = .preferredFont(forTextStyle: .title3)
    $0.textColor = .darkText
    $0.numberOfLines = 2
    $0.adjustsFontSizeToFitWidth = true
    $0.minimumScaleFactor = 0.9
  }
  let authorLabel = UILabel().then {
    $0.font = .preferredFont(forTextStyle: .headline)
    $0.textColor = .darkGray
  }
  let dateLabel = UILabel().then {
    $0.font = .preferredFont(forTextStyle: .subheadline)
    $0.textColor = .lightGray
  }
  let placeholder = UIImage(systemName: "photo.artframe")

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupViews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    pictureView.kf.cancelDownloadTask()
    pictureView.kf.setImage(with: URL(string: ""))
    pictureView.image = nil
  }
}

extension BookCell {
  func setupViews() {
    accessoryType = .disclosureIndicator
    
    contentView.addSubview(pictureView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(authorLabel)
    contentView.addSubview(dateLabel)
  }
  
  func setupConstraints() {
    let insets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 8)
    let padding = 8
    
    pictureView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(insets.top)
      $0.leading.equalToSuperview().offset(insets.left)
      $0.bottom.equalToSuperview().offset(-insets.bottom)
      $0.width.height.equalTo(100)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(pictureView.snp.top)
      $0.leading.equalTo(pictureView.snp.trailing).offset(padding)
      $0.trailing.equalToSuperview().offset(-insets.right)
    }
    
    authorLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(padding)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalTo(titleLabel.snp.trailing)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(authorLabel.snp.bottom).offset(padding)
      $0.leading.equalTo(authorLabel.snp.leading)
      $0.trailing.equalTo(authorLabel.snp.trailing)
      $0.bottom.equalTo(pictureView.snp.bottom)
    }
  }
}

extension BookCell {
  func configure(_ volume: Volume) {
    titleLabel.text = volume.info.title
    authorLabel.text = volume.info.authorsText
    dateLabel.text = volume.info.publishedDateText
    
    pictureView.kf.setImage(with: volume.info.smallThumbnailURL, placeholder: placeholder) { [weak self] result in
      guard let self = self else { return }
      guard case .success = result else { return }
      self.setNeedsLayout()
      self.layoutIfNeeded()
    }
  }
  
  func configure(_ volume: ViewModel.Volume) {
    titleLabel.text = volume.title
    authorLabel.text = volume.authors
    dateLabel.text = volume.publishedDate
    
    pictureView.kf.setImage(with: volume.imageURL, placeholder: placeholder) { [weak self] result in
      guard let self = self else { return }
      guard case .success = result else { return }
      self.setNeedsLayout()
      self.layoutIfNeeded()
    }
  }
}
