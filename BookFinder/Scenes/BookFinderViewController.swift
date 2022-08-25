//
//  BookFinderViewController.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/25.
//

import UIKit
import SwiftUI
import SnapKit
import Then

class BookFinderViewController: UIViewController {
  
  let tableView = UITableView().then {
    $0.register(BookCell.self)
    $0.rowHeight = UITableView.automaticDimension
    $0.clearsContextBeforeDrawing = true
  }
  
  let searchController = UISearchController().then {
    $0.searchBar.placeholder = "Search books"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
   
    setupViews()
    setupConstraints()
  }
}

extension BookFinderViewController {
  func setupViews() {
    navigationItem.searchController = searchController
    navigationItem.title = "Book Finder"
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationController?.navigationBar.prefersLargeTitles = true
    
    tableView.dataSource = self
    tableView.delegate = self
    
    view.addSubview(tableView)
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.leading.top.bottom.trailing.equalTo(view)
    }
  }
}

extension BookFinderViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as BookCell
    
    return cell
  }
}

extension BookFinderViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let view = BookDetailView()
    let vc = UIHostingController(rootView: view)
    navigationController?.pushViewController(vc, animated: true)
  }
}
