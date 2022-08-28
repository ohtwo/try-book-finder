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
    $0.register(LoadingCell.self)
    $0.register(EmptyCell.self)
    $0.rowHeight = UITableView.automaticDimension
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
    viewModel.resultText.asDriver()
      .drive(navigationItem.rx.prompt)
      .disposed(by: disposeBag)
    
    viewModel.items.asDriver()
      .drive(tableView.rx.items, curriedArgument: configureCell)
      .disposed(by: disposeBag)
        
    tableView.rx.itemSelected.asDriver()
      .drive(onNext: deselectRow)
      .disposed(by: disposeBag)
      
    tableView.rx.modelSelected(BookViewModel.Item.self).asDriver()
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
        
    func configureCell(tableView: UITableView, row: Int, state: BookViewModel.Item) -> UITableViewCell {
      let indexPath = IndexPath(row: row, section: 0)
      
      switch state {
      case let .result(volume):
        let cell = tableView.dequeueReusableCell(for: indexPath) as BookCell
        cell.configure(volume)
        return cell
        
      case .loading:
        return tableView.dequeueReusableCell(for: indexPath) as LoadingCell
        
      case .empty:
        return tableView.dequeueReusableCell(for: indexPath) as EmptyCell
      }
    }
    
    func deselectRow(at indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showDetail(of state: BookViewModel.Item) {
      guard case .result(let volume) = state else { return }
      
      let view = BookDetailView(volume: volume)
      let vc = UIHostingController(rootView: view)
      navigationController?.pushViewController(vc, animated: true)
    }
    
    func prefetchRows(row: Int) {
      guard row == viewModel.items.value.count - 1 else { return }
      guard let text = searchController.searchBar.text else { return }
      
      viewModel.search(for: text)
    }
  }
}
