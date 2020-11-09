//
//  ShopModelType.swift
//  Backit
//
//  Created by Ivan Nikitin on 23/09/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

protocol ShopModelType: class {
    
    func addToFavorite(store currentStore: Store, completion: @escaping ((Store?)->()))
    func deleteFromFavorite(store currentStore: Store, completion: @escaping ((Store?)->()))

}

protocol ShopsFavoriteBehaviour: ShopModelType {
    func changeFavouriteStatus(index: Int, to like: Bool, completion: @escaping ((IndexPath?)->()))
}

extension ShopModelType {
    
    private func addFavouriteStore(by id: Int) {
        CoreDataStorageContext.shared.addFavorite(id: id)
        Session.shared.timeOfTableFavorites = Date()
    }
    
    private func deleteFavoriteStore(by id: Int) {
        CoreDataStorageContext.shared.removeFavorite(id: id)
        Session.shared.timeOfTableFavorites = Date()
    }
    
    private func dislike(currentStore store: Store) -> Store {
        store.isFavorite = false
        return store
    }
    
    private func like(currentStore store: Store) -> Store {
        store.isFavorite = true
        return store
    }
    
    func addToFavorite(store currentStore: Store, completion: @escaping ((Store?)->())) {
        ShopApiClient.addToFavorite(forShopId: currentStore.id) { [weak self] (result) in
            switch result {
            case .success(_):
                guard let strongSelf = self else { completion(nil); return }
                let changedStore = strongSelf.like(currentStore: currentStore)
                strongSelf.addFavouriteStore(by: changedStore.id)
                completion(changedStore)
                break
            case .failure(let error):
                Alert.showErrorToast(by: error)
                completion(nil)
                break
            }
        }
    }
    
    func deleteFromFavorite(store currentStore: Store, completion: @escaping ((Store?)->())) {
        ShopApiClient.deleteFromFavorite(forShopId:  currentStore.id) { [weak self] (result) in
            switch result {
            case .success(_):
                guard let strongSelf = self else { completion(nil); return }
                let changedStore = strongSelf.dislike(currentStore: currentStore)
                strongSelf.deleteFavoriteStore(by: changedStore.id)
                completion(changedStore)
                break
            case .failure(let error):
                Alert.showErrorToast(by: error)
                completion(nil)
                break
            }
        }
    }
        
}
