//
//  PaymentsVC.swift
//  ePN Cashback
//
//  Created by Ivan Nikitin on 29/07/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit
import ProgressHUD
import TransitionButton
import Toast_Swift

class PaymentsVC: UIViewController {

    var viewModel: PaymentsModelType!
    var ballanceIsLoaded = false
    var pursesIsLoaded = false
    
    private var withdrawButtonEnabled = false
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chooseBallanceLabel: UILabel!
    @IBOutlet weak var chooseWalletLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var purseCollectionView: UICollectionView!
    private let ballanceCellId = "paymentBallanceCellIdentifier"
    private let purseCellId = "purseCellIdentifier"
    @IBOutlet weak var addPurseLabel: UILabel!
    @IBOutlet weak var addPurseDescriptionLabel: UILabel!
    @IBOutlet weak var addNewPurseView: UIView!
    private var isFirstLayout = true
    private var indexOfCellBeforeDragging = 0
    @IBOutlet weak var addNewPurseButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    
    //Payment view fields
    @IBOutlet weak var orderPaymentView: UIView!
    @IBOutlet weak var orderBottomView: UIView!
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var paymentValueTextField: UITextField!
    @IBOutlet weak var commissionInfoLabel: UILabel!
    @IBOutlet weak var topLineView: UIView!
    private var shieldView = UIView()
    @IBOutlet weak var offerLinkLabel: EPNLinkLabel!
    @IBOutlet weak var offerLinkLabelTopSpacing: NSLayoutConstraint!
    var withdrawButton = EPNButton(style: .disabled, size: .medium)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        offerLinkLabel.style = .partly
        setupScrollViewPullToRefresh()
        subscribeNotificationCenter()
        setupNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        purseCollectionView.delegate = self
        purseCollectionView.dataSource = self
        Analytics.openEventPayment()
    }
    
    private func setupSubviews() {
        orderPaymentView.addSubview(withdrawButton)
    }
    
    private func setupConstraints() {
        withdrawButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(infoView)
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(infoView.snp.right).inset(16)
            make.width.equalTo(130)
            make.height.equalTo(45)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkMinimumAmountToWithdraw()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        paymentValueTextField.resignFirstResponder()
        paymentValueTextField.text = ""
        ProgressHUD.dismiss()
    }
    
    deinit {
        unsubscribeNotificationCenter()
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            setupView()
            ProgressHUD.show()
            loadData()
        }
    }
    
    private func setupScrollViewPullToRefresh() {
        self.scrollView.isScrollEnabled = true
        self.scrollView.alwaysBounceVertical = true
        refreshControl.tintColor = .sydney
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.scrollView.addSubview(refreshControl)
    }
    
    private func setupView() {
        self.view.backgroundColor = .zurich
        setWithdrawButtonEnable(isEnable: false)
        errorLabel.font = .medium15
        errorLabel.textColor = .prague
        collectionView.backgroundColor = .zurich
        purseCollectionView.backgroundColor = .zurich
        
        chooseBallanceLabel.font = .semibold17
        chooseBallanceLabel.textColor = .sydney
        chooseBallanceLabel.text = "1. \(viewModel.chooseBallanceTitle())"
        chooseWalletLabel.text = "2. \(viewModel.choosePurseTitle())"
        chooseWalletLabel.font = .semibold17
        chooseWalletLabel.textColor = .sydney
        
        addPurseLabel.text = viewModel.addAWalletTitle()
        addPurseLabel.font = .semibold17
        addPurseLabel.textColor = .sydney
        addPurseDescriptionLabel.text = viewModel.addAWalletDescription()
        addPurseDescriptionLabel.font = .medium15
        addPurseDescriptionLabel.textColor = .minsk
        addNewPurseView.borderColor = .sydney
        addNewPurseView.layoutIfNeeded()
        
        let addPurseViewBorder = CAShapeLayer()
        addPurseViewBorder.strokeColor = UIColor.black.cgColor
        addPurseViewBorder.lineDashPattern = [4, 4]
        addPurseViewBorder.strokeColor = UIColor.sydney.cgColor
        addPurseViewBorder.frame = addNewPurseView.bounds
        addPurseViewBorder.fillColor = nil
        addPurseViewBorder.path = UIBezierPath(roundedRect: addNewPurseView.bounds, cornerRadius: CommonStyle.cornerRadius).cgPath
        addNewPurseView.layer.addSublayer(addPurseViewBorder)
        
        withdrawButton.text = NSLocalizedString("Withdraw", comment: "")
        withdrawButton.handler = {[weak self] button in
            self?.withdrawButtonClicked()
        }
        
        paymentValueTextField.delegate = self
        commissionInfoLabel.font = .medium15
        commissionInfoLabel.textColor = .sydney
        commissionInfoLabel.text = NSLocalizedString("Without commission", comment: "")
        currencyLabel.font = .semibold17
        currencyLabel.textColor = .sydney
        paymentValueTextField.font = .medium15
        paymentValueTextField.textColor = .sydney
        topLineView.backgroundColor = .montreal
        addShieldViewToPaymentView()
    }
    
    private func setupNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .zurich
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.sydney , NSAttributedString.Key.font : UIFont.semibold17]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    private func loadData() {
        ballanceIsLoaded = false
        pursesIsLoaded = false
        loadBallance()
        loadPurses()
    }
    
    private func loadBallance() {
        viewModel.loadBallance(success: { [weak self] in
            OperationQueue.main.addOperation {
                self?.ballanceIsLoaded = true
                if (self?.ballanceIsLoaded ?? false && self?.pursesIsLoaded ?? false) {
                    self?.refreshControl.endRefreshing()
                    ProgressHUD.dismiss()
                }
                self?.collectionView.reloadData()
                self?.checkMinimumAmountToWithdraw()
            }
        }) { [weak self] () in
            OperationQueue.main.addOperation { [weak self] in
                ProgressHUD.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func loadPurses() {
        viewModel.loadPurses(success: { [weak self] in
            self?.pursesIsLoaded = true
            if (self?.ballanceIsLoaded ?? false && self?.pursesIsLoaded ?? false) {
                self?.refreshControl.endRefreshing()
                ProgressHUD.dismiss()
            }
            self?.setupPurses()
        }) { [weak self] () in
            OperationQueue.main.addOperation { [weak self] in
                ProgressHUD.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupPurses() {
        if (self.viewModel.countOfPurses() > 0) {
            self.purseCollectionView.isHidden = false
            self.addNewPurseView.isHidden = true
            self.purseCollectionView.reloadData()
            self.checkMinimumAmountToWithdraw()
        } else {
            self.purseCollectionView.isHidden = true
            self.addNewPurseView.isHidden = false
        }
    }
    
    @objc func backButtonClicked() {
        viewModel.pop()
    }
    
    @IBAction func addNewPurseClicked(_ sender: Any) {
        if viewModel.emailIsConfirmed() {
            viewModel.createNewPurse()
        } else {
            let alert = UIAlertController(title: "", message: NSLocalizedString("You can't add a wallet to withdraw", comment: ""), preferredStyle: .alert)
            let closeAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: {    (action) in    })
            closeAction.setValue(UIColor.sydney, forKey: "titleTextColor")
            alert.addAction(closeAction)
            self.present(alert, animated: true)
        }
    }
    
    private func subscribeNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.purseDidAddedEvent(notification:)), name: Notification.Name("NewPurseDidAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeNotificationCenter() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func purseDidAddedEvent(notification: Notification) {
        self.purseCollectionView.isHidden = true
        self.addNewPurseView.isHidden = true
        self.viewModel.selectPurse(index: nil)
        
        self.loadPurses()
    }
    
    @objc func refresh(sender:AnyObject)
    {
        loadData()
    }
    
    private func checkMinimumAmountToWithdraw() {
        let result = viewModel.checkPurseLimit()
        //If minimum amount limit
        if result.0 {
            errorLabel.text = "\(NSLocalizedString("The minimum withdrawal amount on the chosen wallet is", comment: "")) \(result.1)\(result.2). \(NSLocalizedString("Choose another balance or wallet", comment: ""))"
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
        }
        setWithdrawButtonEnable(isEnable: result.3)
        setComission()
    }
    
    private func setComission() {
        let result = viewModel.comission()
        //Comission percent
        if let commissionPercent = result.0 {
            commissionInfoLabel.text =
            "\(NSLocalizedString("Сommission", comment: "")) \(commissionPercent)%"
        }
        //Fixed comission
        else if let fixComission = result.1 {
            commissionInfoLabel.text = "\(NSLocalizedString("Сommission", comment: "")) \(fixComission)\(result.2 ?? ""))"
        }
        //No comission
        else {
            commissionInfoLabel.text = NSLocalizedString("Without commission", comment: "")
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                let offset =  -(endFrame?.size.height ?? 0 * -1)
                self.keyboardHeightLayoutConstraint?.constant = offset
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        addShieldViewToPaymentView()
        if let userInfo = notification.userInfo {
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            self.keyboardHeightLayoutConstraint?.constant = 0
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    private func setWithdrawButtonEnable(isEnable: Bool) {
        self.withdrawButton.style = isEnable ? .primary : .disabled
    }
    
    private func addShieldViewToPaymentView() {
        shieldView.backgroundColor = .clear
        orderPaymentView.addSubview(shieldView)
        shieldView.translatesAutoresizingMaskIntoConstraints = false
        shieldView.topAnchor.constraint(equalTo: orderPaymentView.topAnchor, constant: 0).isActive = true
        shieldView.bottomAnchor.constraint(equalTo: orderPaymentView.bottomAnchor, constant: 0).isActive = true
        shieldView.leadingAnchor.constraint(equalTo: orderPaymentView.leadingAnchor, constant: 0).isActive = true
        shieldView.trailingAnchor.constraint(equalTo: orderPaymentView.trailingAnchor, constant: 0).isActive = true
        shieldView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShieldTap)))
    }
    
    private func removeShieldViewFromPaymentView() {
        shieldView.removeFromSuperview()
    }
    
    @objc func handleShieldTap(_ sender: UITapGestureRecognizer? = nil) {
        if withdrawButton.style != .disabled {
            paymentValueTextField.becomeFirstResponder()
            removeShieldViewFromPaymentView()
        } else {
            if errorLabel.isHidden {
                showToast(message: NSLocalizedString("Choose an available balance and wallet", comment: ""))
            } else {
                showToast(message: NSLocalizedString("Choose another wallet or balance", comment: ""))
            }
        }
    }
 
    private func withdrawButtonClicked() {
        guard let doubleValue = tryParseNumber(paymentValueTextField.text ?? "") else {
            return
        }
        let checkResult = viewModel.checkPurseLimit(amount: doubleValue)
        if checkResult.0 {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: "\(NSLocalizedString("The minimum withdrawal amount on the chosen wallet is", comment: "")) \(checkResult.1)\(checkResult.2)", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: {    (action) in    })
            closeAction.setValue(UIColor.sydney, forKey: "titleTextColor")
            alert.addAction(closeAction)
            self.present(alert, animated: true)
            return
        }
        if let selectedPurseRow = viewModel.selectedPurseRow(), let selectedBalanceRow = viewModel.selectedBallanceRow() {
            let purse = viewModel.purse(forIndexPath: IndexPath(row: selectedPurseRow, section: 0))
            let balance = viewModel.ballance(forIndexPath: IndexPath(row: selectedBalanceRow, section: 0))
            if let purseNumber = purse.isCharity ? NSLocalizedString("CharityTitle", comment: "") : purse.purseCardObject?.account ?? purse.purse {
                let alert = UIAlertController(title: "", message: "\(NSLocalizedString("Send", comment: "")) \(doubleValue)\(LocalSymbolsAndAbbreviations.getSymbolOfCurrency(value: balance.id)) \(NSLocalizedString("To", comment: "")) \(purseNumber)?", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: {    (action) in    })
                closeAction.setValue(UIColor.prague, forKey: "titleTextColor")
                alert.addAction(closeAction)
                let acceptAction = UIAlertAction(title: NSLocalizedString("Send", comment: ""), style: .default, handler: {  [weak self]  (action) in
                    guard let self = self else {
                        return
                    }
                    self.withdrawButton.getTransionButton.startAnimation()
                    self.viewModel.withdraw(amount: doubleValue, success: { [weak self] in
                        OperationQueue.main.addOperation { [weak self] in
                            self?.withdrawButton.getTransionButton.stopAnimation()
                        }
                    }) { [weak self] in
                        OperationQueue.main.addOperation { [weak self] in
                            self?.withdrawButton.getTransionButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.3, completion: nil)
                        }
                    }
                })
                acceptAction.setValue(UIColor.sydney, forKey: "titleTextColor")
                alert.addAction(acceptAction)
                self.present(alert, animated: true)
                return
            }
        }
    }
    
    func tryParseNumber(_ text:String) -> Double? {
        let numberForamtter = NumberFormatter()
        numberForamtter.locale = Locale.current
        numberForamtter.numberStyle = .decimal
        numberForamtter.decimalSeparator = "."
        if let number = numberForamtter.number(from: text)?.doubleValue {
            return number
        }
        numberForamtter.decimalSeparator = ","
        if let number = numberForamtter.number(from: text)?.doubleValue {
            return number
        }
        return nil
    }
    
    private func showToast(message: String) {
        var toastStyle = ToastStyle()
        toastStyle.messageAlignment = .center
        toastStyle.messageFont = .medium15
        self.view.makeToast(message, duration: 0.6, position: .bottom, style: toastStyle)
    }
    
    private func setupOfferInfoLabel() {
        if let selectedPurseRow = viewModel.selectedPurseRow(){
            if viewModel.purse(forIndexPath: IndexPath(row: selectedPurseRow, section: 0)).isCharity {
                if offerLinkLabelTopSpacing.constant == 0 {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.offerLinkLabel.changeColorOfLink(for: NSLocalizedString("By making a donation, you accept the terms of our offer", comment: ""))
                        self?.offerLinkLabelTopSpacing.constant = 10
                        self?.view.layoutIfNeeded()
                    }
                }
            } else {
                if offerLinkLabelTopSpacing.constant != 0 {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.offerLinkLabel.text = ""
                        self?.offerLinkLabelTopSpacing.constant = 0
                        self?.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    @IBAction func offerLinkTapped(_ sender: Any) {
        guard let url = URL(string: viewModel.offerLink) else { return }
        UIApplication.shared.open(url)
    }
    
}

extension PaymentsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == purseCollectionView {
            return viewModel.countOfPurses()
        }
        return viewModel.countOfBallances()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == purseCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: purseCellId, for: indexPath) as! PurseCollectionViewCell
            if viewModel.purseCardIsRotated(forIndexPath: indexPath) {
                print("Rotated")
            }
            cell.setupCell(purse: viewModel.purse(forIndexPath: indexPath), viewModel: viewModel, selected: viewModel.selectedPurseRow() == indexPath.row, rotated: viewModel.purseCardIsRotated(forIndexPath: indexPath), purseId: viewModel.purseId(forIndexPath: indexPath))
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ballanceCellId, for: indexPath) as! PaymentBallanceCollectionViewCell
        cell.setupCell(ballance: viewModel.ballance(forIndexPath: indexPath), selected: viewModel.selectedBallanceRow() == indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == purseCollectionView {
            if indexPath.row == viewModel.selectedPurseRow() {
                return
            }
            var indexPaths = [IndexPath]()
            if let selectedIndex = viewModel.selectedPurseRow() {
                indexPaths.append(IndexPath(row: selectedIndex, section: 0))
            }
            viewModel.selectPurse(index: indexPath.row)
            indexPaths.append(indexPath)
            collectionView.reloadItems(at: indexPaths)
            checkMinimumAmountToWithdraw()
            setupOfferInfoLabel()
            return
        }
        if indexPath.row == viewModel.selectedBallanceRow() {
            return
        }
        var indexPaths = [IndexPath]()
        if let selectedIndex = viewModel.selectedBallanceRow() {
            indexPaths.append(IndexPath(row: selectedIndex, section: 0))
        }
        viewModel.selectBallance(index: indexPath.row)
        currencyLabel.text = viewModel.getCurrencyForSelectedBallance()
        indexPaths.append(indexPath)
        collectionView.reloadItems(at: indexPaths)
        checkMinimumAmountToWithdraw()
        let selectedBalance = viewModel.ballance(forIndexPath: indexPath)
        paymentValueTextField.text = String(selectedBalance.attributes.availableAmount)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == purseCollectionView {
            return CGSize(width: collectionView.frame.size.width-70, height: collectionView.frame.size.height)
        }
        return CGSize(width: (collectionView.frame.size.width-49)/2, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    private func indexOfMajorCell() -> Int {
        let collectionViewLayout = self.purseCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (collectionView.frame.size.width-40)
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(viewModel.countOfPurses() - 1, index))
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView != purseCollectionView {
            return
        }
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        let collectionViewLayout = self.purseCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < viewModel.countOfPurses() && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let indexPath = IndexPath(row: snapToIndex, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private var snapToMostVisibleColumnVelocityThreshold: CGFloat { return 0.3 }
    
}

extension PaymentsVC: UIActionSheetDelegate, PurseCollectionViewCellDelegate {
    
    func menuButtonClicked(purseId: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete the wallet", comment: ""), style: .default, handler: { [weak self] (action) in
            OperationQueue.main.addOperation {
                ProgressHUD.show()
            }
            self?.viewModel.deletePurse(purseId: purseId, success: { [weak self] in
                OperationQueue.main.addOperation {
                    self?.purseCollectionView.reloadData()
                    self?.setupPurses()
                    self?.checkMinimumAmountToWithdraw()
                    ProgressHUD.dismiss()
                }
            }, failure: {
                OperationQueue.main.addOperation {
                    ProgressHUD.dismiss()
                }
            })
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) in
            
        })
        deleteAction.setValue(UIColor.prague, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.sydney, forKey: "titleTextColor")
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true)
    }
    
}

extension PaymentsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        if newText.isEmpty {
            setWithdrawButtonEnable(isEnable: false)
            return true
        } else {
            setWithdrawButtonEnable(isEnable: withdrawButtonEnabled)
        }
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        let numberOfCommas = newText.components(separatedBy: ",").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            if let commaIndex = newText.firstIndex(of: ",") {
                numberOfDecimalDigits = newText.distance(from: commaIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
        }
        if let doubleValue = tryParseNumber(newText), let availableAmount = viewModel.getAvailableAmount() {
            if doubleValue == 0 {
                setWithdrawButtonEnable(isEnable: false)
            }
            return numberOfDots <= 1 && numberOfCommas <= 1 && numberOfDecimalDigits <= 2 && doubleValue <= availableAmount
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setWithdrawButtonEnable(isEnable: withdrawButtonEnabled)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        withdrawButtonEnabled = withdrawButton.style != .disabled
    }
    
}

