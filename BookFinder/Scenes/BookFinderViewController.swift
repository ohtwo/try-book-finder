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
import Alamofire
import RxSwift
import RxCocoa

class BookFinderViewController: UIViewController {
  
  let tableView = UITableView().then {
    $0.register(BookCell.self)
    $0.rowHeight = UITableView.automaticDimension
    $0.clearsContextBeforeDrawing = true
  }
  
  let searchController = UISearchController().then {
    $0.searchBar.placeholder = "Search books"
    $0.searchBar.searchTextField.autocapitalizationType = .none
  }
    
  let viewModel = BookViewModel()
  
  private var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
   
    setupViews()
    setupConstraints()
    bindUIs()
  }
}

extension BookFinderViewController {
  func setupViews() {
    navigationItem.searchController = searchController
    navigationItem.title = "Book Finder"
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationController?.navigationBar.prefersLargeTitles = true
    
    view.addSubview(tableView)
  }
  
  func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view)
    }
  }
  
  func bindUIs() {
    viewModel.volumes.asDriver()
      .drive(tableView.rx.items(cellIdentifier: BookCell.reuseIdentifier, cellType: BookCell.self),
             curriedArgument: configureCell)
      .disposed(by: disposeBag)
    
    tableView.rx.itemSelected.asDriver()
      .drive(onNext: deselectRow)
      .disposed(by: disposeBag)
      
    tableView.rx.modelSelected(Volume.self).asDriver()
      .drive(onNext: showDetail)
      .disposed(by: disposeBag)
    
    tableView.rx.prefetchRows
      .compactMap(\.last?.row)
      .subscribe(onNext: prefetchRows)
      .disposed(by: disposeBag)
    
    searchController.searchBar.rx.text
      .orEmpty
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .`do`(onNext: viewModel.reset)
      .subscribe(onNext: viewModel.search)
      .disposed(by: disposeBag)
    
    func configureCell(row: Int, volume: Volume, cell: BookCell) {
      cell.configure(volume)
    }
    
    func deselectRow(at indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showDetail(of volume: Volume) {
      let view = BookDetailView()
      let vc = UIHostingController(rootView: view)
      navigationController?.pushViewController(vc, animated: true)
    }
    
    func prefetchRows(row: Int) {
      guard row == viewModel.volumes.value.count - 1 else { return }
      guard let text = searchController.searchBar.text else { return }
      
      viewModel.search(for: text)
    }
  }
}
