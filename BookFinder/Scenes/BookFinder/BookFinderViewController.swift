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

protocol BookFinderViewable: AnyObject {
  func displayFetchedBooks(viewModel: ViewModel)
}

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
    
  var interactor: BookFinderInteractable?
  
  var items = BehaviorRelay<[ViewModel.Item]>(value: [])
  var totalItems = BehaviorRelay<String?>(value: nil)
  
  private var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
   
    setupViews()
    setupConstraints()
    setupVIPs()
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
  
  func setupVIPs() {
    let viewer = self
    let interactor = BookFinderInteractor()
    let presentor = BookFinderPresenter()
    
    viewer.interactor = interactor
    interactor.presenter = presentor
    presentor.viewer = viewer
  }
  
  func bindUIs() {
    totalItems.asDriver()
      .drive(navigationItem.rx.prompt)
      .disposed(by: disposeBag)

    items.asDriver()
      .drive(tableView.rx.items, curriedArgument: configureCell)
      .disposed(by: disposeBag)

    tableView.rx.itemSelected.asDriver()
      .drive(onNext: deselectRow)
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(ViewModel.Item.self).asDriver()
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
      .`do`(onNext: prepareForFetch)
      .subscribe(onNext: fetchBooks)
      .disposed(by: disposeBag)
        
    func configureCell(tableView: UITableView, row: Int, item: ViewModel.Item) -> UITableViewCell {
      let indexPath = IndexPath(row: row, section: 0)
      
      switch item {
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
    
    func showDetail(of state: ViewModel.Item) {
      guard case .result(let volume) = state else { return }
      
      let view = BookDetailView(volume: volume)
      let vc = UIHostingController(rootView: view)
      navigationController?.pushViewController(vc, animated: true)
    }
    
    func prefetchRows(row: Int) {
      guard row == items.value.count - 1 else { return }
      guard let text = searchController.searchBar.text else { return }
      fetchBooks(text: text)
    }
  }
}

extension BookFinderViewController: BookFinderViewable {
  func prepareForFetch(_: String) {
    interactor?.prepareForFetch()
  }
  
  func fetchBooks(text: String) {
    let request = Request(searchText: text)
    interactor?.fetchBooks(request: request)
  }
  
  func displayFetchedBooks(viewModel: ViewModel) {
    items.accept(viewModel.items)
    totalItems.accept(viewModel.totalItems)
  }
}
