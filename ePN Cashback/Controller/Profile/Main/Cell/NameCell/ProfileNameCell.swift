//
//  ProfileNameCell.swift
//  Backit
//
//  Created by Александр Кузьмин on 02/04/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol ProfileNameCellDelegate: class {
    func textDidChanged(newText: String)
}

class ProfileNameCell: UITableViewCell {

    weak var delegate: ProfileNameCellDelegate?
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomSeparatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(name: String) {
        selectionStyle = .none
        nameTextField.font = .medium15
        nameTextField.textColor = .moscow
        nameTextField.text = name
        nameTextField.placeholder = NSLocalizedString("Enter name", comment: "")
        nameTextField.delegate = self
        
        bottomSeparatorView.backgroundColor = .montreal
    }
    
    @IBAction func nameTextFieldChanged(_ sender: Any) {
        delegate?.textDidChanged(newText: nameTextField.text ?? "")
    }
    
    @IBAction func textFieldEndEditing(_ sender: Any) {
        bottomSeparatorView.backgroundColor = .montreal
    }
    
    @IBAction func textFieldBeginEditing(_ sender: Any) {
        bottomSeparatorView.backgroundColor = .vilnius
    }
    
    
}

extension ProfileNameCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
