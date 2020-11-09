//
//  DynamicsVC.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 25/03/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import Charts
import ProgressHUD

class DynamicsVC: UIViewController, ChartViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var buyButton: EPNButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    private let currentPrice = UILabel()
    private let minPrice = UILabel()
    private let maxPrice = UILabel()
    
    var viewModel: DynamicViewModel?
    private let filterIdentifier = "periodFilterCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        
        ///Send event to analytic about open PriceDynamic
        PriceDynamicsAnalytics.priceDynamicsOpen()
        
        guard let viewModel = viewModel else { return }
        infoLabel.text = viewModel.infoText
        infoLabel.textColor = .sydney
        infoLabel.font = .medium13
        
        buyButton.text = viewModel.buttonInfoText
        buyButton.style = .primary
        buyButton.buttonSize = .large2
//        buyButton.fontSize = 16
        buyButton.handler = { (button) in
            ProgressHUD.show()
            viewModel.openStore { (url) in
                OperationQueue.main.addOperation {
                    ProgressHUD.dismiss()
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }
        }

        chartView.delegate = self
        setupCollection()
        setupPriceView()
        containerView.backgroundColor = .zurich
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = CommonStyle.cornerRadius
        containerView.layer.borderWidth = CommonStyle.borderWidth
        containerView.layer.borderColor = UIColor.montreal.cgColor
        
        setUpChartView(viewModel)
    }
    
    
    func setUpNavigationBar() {
        title = NSLocalizedString("Link Price dynamics", comment: "")
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "accountMenu_faq").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(hintButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupPriceView() {
        currentView.backgroundColor = .zurich
        currentView.layer.masksToBounds = true
        currentView.layer.cornerRadius = CommonStyle.cornerRadius
        currentView.layer.borderWidth = CommonStyle.borderWidth
        currentView.layer.borderColor = UIColor.montreal.cgColor
        
        leftView.backgroundColor = .zurich
        leftView.layer.masksToBounds = true
        leftView.layer.cornerRadius = CommonStyle.cornerRadius
        leftView.layer.borderWidth = CommonStyle.borderWidth
        leftView.layer.borderColor = UIColor.montreal.cgColor
        
        rightView.backgroundColor = .zurich
        rightView.layer.masksToBounds = true
        rightView.layer.cornerRadius = CommonStyle.cornerRadius
        rightView.layer.borderWidth = CommonStyle.borderWidth
        rightView.layer.borderColor = UIColor.montreal.cgColor
        
        
        let currentPriceLabel = UILabel()
        
        currentView.addSubview(currentPriceLabel)
        currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPriceLabel.topAnchor.constraint(equalTo: currentView.topAnchor, constant: 10).isActive = true
        currentPriceLabel.leadingAnchor.constraint(equalTo: currentView.leadingAnchor, constant: 10).isActive = true
        currentPriceLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        currentPriceLabel.trailingAnchor.constraint(equalTo: currentView.trailingAnchor, constant: -10).isActive = true
        currentPriceLabel.font = .medium13
        currentPriceLabel.textColor = .sydney
        currentPriceLabel.numberOfLines = 1
        currentPriceLabel.textAlignment = .left
        currentPriceLabel.text = viewModel?.priceTodayLabel
        
        currentView.addSubview(currentPrice)
        currentPrice.translatesAutoresizingMaskIntoConstraints = false
        currentPrice.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 2).isActive = true
        currentPrice.leadingAnchor.constraint(equalTo: currentView.leadingAnchor, constant: 10).isActive = true
        currentPrice.heightAnchor.constraint(equalToConstant: 20).isActive = true
        currentPrice.trailingAnchor.constraint(equalTo: currentView.trailingAnchor, constant: -10).isActive = true
        currentPrice.bottomAnchor.constraint(equalTo: currentView.bottomAnchor, constant: -10).isActive = true
        currentPrice.font = .semibold17
        currentPrice.textColor = .sydney
        currentPrice.numberOfLines = 1
        currentPrice.textAlignment = .left
        currentPrice.text = viewModel?.priceToday()
        
        let minPriceLabel = UILabel()
        
        leftView.addSubview(minPriceLabel)
        minPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        minPriceLabel.topAnchor.constraint(equalTo: leftView.topAnchor, constant: 10).isActive = true
        minPriceLabel.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: 10).isActive = true
        minPriceLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        minPriceLabel.trailingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: -10).isActive = true
        minPriceLabel.font = .medium13
        minPriceLabel.textColor = .sydney
        minPriceLabel.numberOfLines = 1
        minPriceLabel.textAlignment = .left
        minPriceLabel.text = viewModel?.minPriceLabel
        
        leftView.addSubview(minPrice)
        minPrice.translatesAutoresizingMaskIntoConstraints = false
        minPrice.topAnchor.constraint(equalTo: minPriceLabel.bottomAnchor, constant: 2).isActive = true
        minPrice.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: 10).isActive = true
        minPrice.heightAnchor.constraint(equalToConstant: 20).isActive = true
        minPrice.trailingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: -10).isActive = true
        minPrice.bottomAnchor.constraint(equalTo: leftView.bottomAnchor, constant: -10).isActive = true
        minPrice.font = .semibold17
        minPrice.textColor = UIColor.budapest
        minPrice.numberOfLines = 1
        minPrice.textAlignment = .left
        minPrice.text = viewModel?.minPrice()
        
        let maxPriceLabel = UILabel()
        
        rightView.addSubview(maxPriceLabel)
        maxPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        maxPriceLabel.topAnchor.constraint(equalTo: rightView.topAnchor, constant: 10).isActive = true
        maxPriceLabel.leadingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: 10).isActive = true
        maxPriceLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        maxPriceLabel.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -10).isActive = true
        maxPriceLabel.font = .medium13
        maxPriceLabel.textColor = .sydney
        maxPriceLabel.numberOfLines = 1
        maxPriceLabel.textAlignment = .left
        maxPriceLabel.text = viewModel?.maxPriceLabel
        
        rightView.addSubview(maxPrice)
        maxPrice.translatesAutoresizingMaskIntoConstraints = false
        maxPrice.topAnchor.constraint(equalTo: maxPriceLabel.bottomAnchor, constant: 2).isActive = true
        maxPrice.leadingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: 10).isActive = true
        maxPrice.heightAnchor.constraint(equalToConstant: 20).isActive = true
        maxPrice.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -10).isActive = true
        maxPrice.bottomAnchor.constraint(equalTo: rightView.bottomAnchor, constant: -10).isActive = true
        maxPrice.font = .semibold17
        maxPrice.textColor = .prague
        maxPrice.numberOfLines = 1
        maxPrice.textAlignment = .left
        maxPrice.text = viewModel?.maxPrice()
    }
    
    func setupCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = false
    }
    
    func setUpChartView(_ viewModel: DynamicViewModel) {
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false

        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelTextColor = .minsk
        let maxValue = viewModel.maxValue()
        let minValue = viewModel.minValue()
        if minValue == maxValue {
            leftAxis.axisMaximum = maxValue + maxValue * 0.05
            leftAxis.axisMinimum = minValue - minValue * 0.05
        } else {
            let delta = (maxValue - minValue) * 1.5
            let maximumAxisValue = Double(String(format: "%.2f", maxValue + delta * 0.25))!
            let minimumAxisValue = Double(String(format: "%.2f", minValue - delta * 0.25))!
            leftAxis.axisMaximum = maximumAxisValue
            leftAxis.axisMinimum = minimumAxisValue
            print("minValue \(leftAxis.axisMinimum) | maxValue \(leftAxis.axisMaximum)")
        }
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularityEnabled = true
        
        chartView.rightAxis.enabled = false
        
        //MARK: Marker
        let marker = BalloonMarker(color: .paris,
                                   font: .medium10,
                                   textColor: .sydney,
                                   insets: UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7),
                                   dates: viewModel.listOfPrices().map{ Util.convertDataForDynamic($0.date) },
                                   currency: viewModel.currency())
        marker.chartView = chartView
        
        marker.minimumSize = CGSize(width: 100, height: 45)
        chartView.marker = marker
        chartView.legend.enabled = false
        chartView.animate(xAxisDuration: ((viewModel.listOfPrices().count > 2) ? 1.0 : 0.1))
        setDataCount(viewModel)
    }
    
    @objc func backButtonTapped() {
        viewModel?.goOnBack()
    }
    
    @objc func hintButtonTapped() {
        viewModel?.goOnInfoMessage()
    }

    func setDataCount(_ viewModel: DynamicViewModel) {
//        let formator = CustomBottomAxisFormatter(usingScore: viewModel.listOfPrices())
//        let xaxis = XAxis()
        let values = (0..<viewModel.listOfPrices().count).map { (i) -> ChartDataEntry in
            let val = viewModel.listOfPrices()[i].price
//            formator.stringForValue(Double(i), axis: xaxis)
            return ChartDataEntry(x: Double(i), y: val)
        }
//        xaxis.valueFormatter = formator
        let priceChart = LineChartDataSet(entries: values, label: "Price dynamics")
        priceChart.axisDependency = .left
        priceChart.drawValuesEnabled = false
        priceChart.setColor(.sydney)
        priceChart.setCircleColor(.sydney)
        priceChart.lineWidth = 2
        priceChart.circleRadius = CommonStyle.cornerRadius
        priceChart.drawCircleHoleEnabled = false
        priceChart.fillAlpha = 0.8
        priceChart.fillColor = .paris
        priceChart.drawFilledEnabled = true
//        chartView.xAxis.valueFormatter = xaxis.valueFormatter
//        chartView.xAxis.drawGridLinesEnabled = false
//        chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chartView.xAxis.enabled = false
//        chartView.xAxis.la
        let dataChart = LineChartData(dataSet: priceChart)
        dataChart.setValueTextColor(.sydney)
        dataChart.setValueFont(.medium10)
        chartView.data = dataChart
        chartView.fitScreen()
    }
}

extension DynamicsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfFilterItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterIdentifier, for: indexPath) as? FilterOfPricesDynamicCollectionViewCell, let viewModel = viewModel else { return UICollectionViewCell() }
        let cellViewModel = viewModel.filterCellViewModel(index: indexPath.row)
        cell.viewModel = cellViewModel
        cell.isSelected = cellViewModel.getStatusOfFilter()
        if cellViewModel.getStatusOfFilter() {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterOfPricesDynamicCollectionViewCell else { return CGSize.zero }
        cell.filter.sizeToFit()
        return CGSize(width: cell.filter.frame.width + 20, height: cell.filter.frame.height + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 20, bottom: 1, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterOfPricesDynamicCollectionViewCell else { return false}
        guard let viewModel = viewModel else { return false }
        if !cell.isSelected {
            for index in 0..<viewModel.numberOfFilterItems() where index != indexPath.row  {
                let deselectIndexPath = IndexPath(row: index, section: 0)
                collectionView.deselectItem(at: deselectIndexPath, animated: false)
                viewModel.switchOffTapped(indexPath: deselectIndexPath)
            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if( viewModel.getSelectedFilterIndex() == indexPath.row) {
            return
        }
        viewModel.switchOnTapped(indexPath: indexPath)
        ProgressHUD.show()
        viewModel.priceDynamics(completion: { [weak self] in
            ProgressHUD.dismiss()
            OperationQueue.main.addOperation { [weak self] in
                self?.currentPrice.text = viewModel.priceToday()
                self?.minPrice.text = viewModel.minPrice()
                self?.maxPrice.text = viewModel.maxPrice()
                self?.setUpChartView(viewModel)
            }
        }) { [weak self] in
            ProgressHUD.dismiss()
            OperationQueue.main.addOperation { [weak self] in
                self?.collectionView.deselectItem(at: indexPath, animated: true)
                self?.collectionView.reloadItems(at: [IndexPath(row: viewModel.getOldFilterIndex(), section: 0)])
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
