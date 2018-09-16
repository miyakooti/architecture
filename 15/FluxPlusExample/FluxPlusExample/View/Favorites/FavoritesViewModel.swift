//
//  FavoritesViewModel.swift
//  FluxPlusExample
//
//  Created by 鈴木大貴 on 2018/08/13.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import GitHub
import RxCocoa
import RxSwift

final class FavoritesViewModel {
    
    let favorites: Property<[GitHub.Repository]>

    let reloadData: Observable<Void>
    let showRepositoryDetail: Observable<Void>

    private let _selectedIndexPath = PublishRelay<IndexPath>()
    private let disposeBag = DisposeBag()

    init(viewDidAppear: Observable<Void>,
         viewDidDisappear: Observable<Void>,
         flux: Flux) {
        let selectedStore = flux.selectedRepositoryStore
        let selectedActionCreator = flux.selectedRepositoryActionCreator
        let favoriteStore = flux.favoriteRepositoryStore

        self.favorites = favoriteStore.repositories

        self.reloadData = favorites.asObservable()
            .map { _ in }

        self.showRepositoryDetail = Observable.merge(viewDidAppear.map { _ in true },
                                                     viewDidDisappear.map { _ in false })
            .flatMapLatest { canSubscribe -> Observable<GitHub.Repository?> in
                if canSubscribe {
                    return selectedStore.repository.changed
                } else {
                    return .empty()
                }
            }
            .flatMap { favorite -> Observable<Void> in
                favorite == nil ? .empty() : .just(())
            }

        _selectedIndexPath
            .withLatestFrom(favorites.asObservable()) { $1[$0.row] }
            .subscribe(onNext: { repository in
                selectedActionCreator.setSelectedRepository(repository)
            })
            .disposed(by: disposeBag)
    }

    func selectedIndexPath(_ indexPath: IndexPath) {
        _selectedIndexPath.accept(indexPath)
    }
}

