//
//  ProfileBirthGenderCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 02/04/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol ProfileBirthGenderCellDelegate: class {
    func birthdayChanged(newBirthDate: String)
    func genderChange(newGender: Gender)
}

class ProfileBirthGenderCell: UITableViewCell {

    weak var delegate: ProfileBirthGenderCellDelegate?
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBOutlet weak var femaleContainerView: UIView!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var femaleCheckboxCircle: UIView!
    @IBOutlet weak var femaleCheckboxDot: UIView!
    
    
    @IBOutlet weak var maleContainerView: UIView!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var maleCheckboxCircle: UIView!
    @IBOutlet weak var maleCheckboxDot: UIView!
    
    @IBOutlet weak var separatorView: UIView!
    
    private let datePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    private var isFirstLayout = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.dateFormat = "dd.MM.yyyy"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLayout {
            isFirstLayout = false
            let femaleTapGesture = UITapGestureRecognizer(target: self, action: #selector(femaleClicked(_:)))
            let maleTapGesture = UITapGestureRecognizer(target: self, action: #selector(maleClicked(_:)))
            femaleContainerView.addGestureRecognizer(femaleTapGesture)
            maleContainerView.addGestureRecognizer(maleTapGesture)
        }
    }
    
    func setupCell(birthday: String, gender: Gender?) {
        selectionStyle = .none
        separatorView.backgroundColor = .montreal
        
        birthdayTextField.text = birthday
        birthdayTextField.textColor = .moscow
        birthdayTextField.font = .medium15
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        birthdayTextField.inputView = datePicker
        birthdayTextField.placeholder = NSLocalizedString("Date of birth", comment: "")
        setAccessoryView()
        
        femaleLabel.textColor = .sydney
        femaleLabel.font = .medium17
        femaleLabel.text = NSLocalizedString("W", comment: "")
        femaleCheckboxCircle.cornerRadius = 11
        femaleCheckboxCircle.backgroundColor = .paris
        femaleCheckboxDot.cornerRadius = 5
        femaleCheckboxDot.backgroundColor = .sydney
        femaleCheckboxDot.isHidden = gender != .some(.female)
        
        maleLabel.textColor = .london
        maleLabel.font = .medium17
        maleLabel.text = NSLocalizedString("M", comment: "")
        maleCheckboxCircle.cornerRadius = 11
        maleCheckboxCircle.backgroundColor = .paris
        maleCheckboxDot.cornerRadius = 5
        maleCheckboxDot.backgroundColor = .sydney
        maleCheckboxDot.isHidden = gender != .some(.male)
        
        if let birthdayDate = dateFormatter.date(from: birthday) {
            datePicker.date = birthdayDate
        } else {
            datePicker.date = Date(timeIntervalSince1970: 631195251)
        }
    }
    
    func setAccessoryView() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(donePressed(sender:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        birthdayTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        birthdayTextField.endEditing(true)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        delegate?.birthdayChanged(newBirthDate: dateFormatter.string(from: datePicker.date))
    }

    @objc func femaleClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.maleCheckboxDot.alpha = 0.0
            self?.maleCheckboxDot.isHidden = true
            self?.femaleCheckboxDot.alpha = 1.0
            self?.femaleCheckboxDot.isHidden = false
        }
        delegate?.genderChange(newGender: .female)
    }
    
    @objc func maleClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.maleCheckboxDot.alpha = 1.0
            self?.maleCheckboxDot.isHidden = false
            self?.femaleCheckboxDot.alpha = 0.0
            self?.femaleCheckboxDot.isHidden = true
        }
        delegate?.genderChange(newGender: .male)
    }
    
    @IBAction func textFieldEndEditing(_ sender: Any) {
        separatorView.backgroundColor = .montreal
    }
    
    @IBAction func textFieldStartEditing(_ sender: Any) {
        separatorView.backgroundColor = .vilnius
    }
    
    
}
