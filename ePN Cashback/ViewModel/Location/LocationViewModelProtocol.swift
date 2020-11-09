//
//  LocationViewModelProtocol.swift
//  Backit
//
//  Created by Elina Batyrova on 14.08.2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation
import RxSwift

protocol LocationViewModelProtocol {
    
    // MARK: - Instance Properties
    
    var title: String { get }
    var backButtonTitle: String { get }
    var searchTextFieldPlaceholder: String { get }
    var emptyStateViewTitle: String { get }
    var isLoading: Observable<Bool> { get }
    var isEmptyData: Observable<Bool> { get }
    var tableData: Observable<[LocationCellData]> { get }
    var error: Observable<Error> { get }
    
    // MARK: - Instance Methods
    
    func loadData()
    func didSelect(data: LocationCellData)
    func goBack()
    func searchData(text: String)
}
