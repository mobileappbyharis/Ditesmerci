////
////  AddCreditCard.swift
////  Ditesmerci
////
////  Created by 7k04 on 11/02/2020.
////  Copyright © 2020 mobileappbyharis. All rights reserved.
////
//
//import UIKit
//import SwiftUI
//import Stripe
//
//
//class AddCreditCardViewController : UIViewController, UITextFieldDelegate {
//    lazy var profileImageView: RoundedImageView = {
//        let imageView = RoundedImageView()
//        imageView.image = UIImage(named: "user")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.isUserInteractionEnabled = true
//        return imageView
//    }()
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "FirstName Name"
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.textColor = .black
//        return label
//    }()
//
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Informations financières"
//        label.font = UIFont.systemFont(ofSize: 17)
//        label.textColor = .gray
//
//        return label
//    }()
//
//    let enterDigitsLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Entrer les numéros"
//        label.font = UIFont.boldSystemFont(ofSize: 17)
//        label.textColor = .purpleMerci
//        return label
//    }()
//
//    let dividerLineView: UIView = {
//        let divider = UIView()
//        divider.backgroundColor = .purpleMerci
//        divider.translatesAutoresizingMaskIntoConstraints = false
//        return divider
//    }()
//
//    let textfieldsView : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
//
//    let creditCardDigitsLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "N° DE CARTE"
//        label.font = UIFont.boldSystemFont(ofSize: 17)
//        label.textColor = .black
//        return label
//    }()
//
//    let creditCardDigitsTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = "**** **** **** ****"
//        textField.layer.borderColor = UIColor.black.cgColor
//        textField.layer.borderWidth = 1
//        textField.borderStyle = UITextField.BorderStyle.roundedRect
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.keyboardType = UIKeyboardType.numberPad
//        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        textField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
//
//        return textField
//    }()
//
//    @objc func didChangeText(textField:UITextField) {
//        textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
//    }
//
//    let expiredDateLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "DATE D'EXPIRATION"
//        label.font = UIFont.boldSystemFont(ofSize: 17)
//        label.textColor = .black
//        return label
//    }()
//
//    let expiredDateTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = "MM/AA"
//        textField.layer.borderColor = UIColor.black.cgColor
//        textField.layer.borderWidth = 1
//        textField.borderStyle = UITextField.BorderStyle.roundedRect
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.keyboardType = UIKeyboardType.alphabet
//        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        return textField
//    }()
//
//    let cryptoLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "CRYPTO"
//        label.font = UIFont.boldSystemFont(ofSize: 17)
//        label.textColor = .black
//        return label
//    }()
//
//    let cryptoTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = "000"
//        textField.layer.borderColor = UIColor.black.cgColor
//        textField.layer.borderWidth = 1
//        textField.borderStyle = UITextField.BorderStyle.roundedRect
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.keyboardType = UIKeyboardType.numberPad
//        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        return textField
//    }()
//
//
//
//    var alertController: UIAlertController?
//
//    private var datePicker: UIDatePickerCreditCard?
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
//        view.backgroundColor = .white
//
//        creditCardDigitsTextField.delegate = self
//        cryptoTextField.delegate = self
//
//        datePicker = UIDatePickerCreditCard()
//        expiredDateTextField.inputView = datePicker
//
//
//        setupViews()
//    }
//
//    @objc func dateChanged(datePicker: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/yyyy"
//
//        expiredDateTextField.text = dateFormatter.string(from: datePicker.date)
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let newLength = (textField.text ?? "").count + string.count - range.length
//        if(textField == creditCardDigitsTextField) {
//            return newLength <= 19
//        }
//        if(textField == cryptoTextField) {
//            return newLength <= 3
//        }
//        return true
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if(textField == creditCardDigitsTextField){
//            return
//        }
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
//
//        })
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if(textField == creditCardDigitsTextField){
//            if (textField.attributedText?.length != 19) {
//                textField.layer.borderColor = UIColor.red.cgColor
//            } else {
//                textField.layer.borderColor = UIColor.black.cgColor
//            }
//            return
//        }
//        // Keyboard up
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width:self.view.frame.size.width, height:self.view.frame.size.height);
//
//        })
//
//        if(textField == cryptoTextField){
//            if (textField.attributedText?.length != 3) {
//                textField.layer.borderColor = UIColor.red.cgColor
//            }
//        }
//
//    }
//
//
//
//    func modifyCreditCardString(creditCardString : String) -> String {
//        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
//
//        let arrOfCharacters = Array(trimmedString)
//        var modifiedCreditCardString = ""
//
//        if(arrOfCharacters.count > 0) {
//            for i in 0...arrOfCharacters.count-1 {
//                modifiedCreditCardString.append(arrOfCharacters[i])
//                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
//                    modifiedCreditCardString.append(" ")
//                }
//            }
//        }
//        return modifiedCreditCardString
//    }
//
//    func setupViews() {
//        view.addSubview(profileImageView)
//        view.addSubview(nameLabel)
//        view.addSubview(titleLabel)
//        view.addSubview(enterDigitsLabel)
//        view.addSubview(textfieldsView)
//        textfieldsView.addSubview(creditCardDigitsLabel)
//        textfieldsView.addSubview(creditCardDigitsTextField)
////        textfieldsView.addSubview(expiredDateLabel)
////        textfieldsView.addSubview(expiredDateTextField)
////        textfieldsView.addSubview(cryptoLabel)
////        textfieldsView.addSubview(cryptoTextField)
////
//
//        NSLayoutConstraint.activate([
//        creditCardDigitsLabel.topAnchor.constraint(equalTo: textfieldsView.topAnchor),
//        creditCardDigitsLabel.leadingAnchor.constraint(equalTo: textfieldsView.leadingAnchor),
//        creditCardDigitsLabel.widthAnchor.constraint(equalToConstant: 30),
//        creditCardDigitsLabel.heightAnchor.constraint(equalToConstant: 30),
//        ])
//
//        NSLayoutConstraint.activate([
//        creditCardDigitsTextField.topAnchor.constraint(equalTo: textfieldsView.topAnchor),
//        creditCardDigitsTextField.leadingAnchor.constraint(equalTo: creditCardDigitsLabel.leadingAnchor),
//        ])
//
//        NSLayoutConstraint.activate([
//        textfieldsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        textfieldsView.topAnchor.constraint(equalTo: enterDigitsLabel.topAnchor, constant: 30),
//        textfieldsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
//        textfieldsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
//        ])
//
//
//        NSLayoutConstraint.activate([
//            profileImageView.topAnchor.constraint(equalTo: view.topAnchor),
//            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
//            profileImageView.widthAnchor.constraint(equalToConstant: 100),
//            profileImageView.heightAnchor.constraint(equalToConstant: 100),
//            ])
//
//        let constraintNameLabel = NSLayoutConstraint(item: nameLabel,
//                                                          attribute: .centerX,
//                                                          relatedBy: .equal,
//                                                          toItem: view,
//                                                          attribute: .centerX,
//                                                          multiplier: 1.2,
//                                                          constant: 0)
//        constraintNameLabel.identifier = "nameLabel placement X"
//        view.addConstraint(constraintNameLabel)
//
//        NSLayoutConstraint.activate([
//            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
//            ])
//
//        let constrainTitleLabel = NSLayoutConstraint(item: titleLabel,
//                                                     attribute: .centerX,
//                                                     relatedBy: .equal,
//                                                     toItem: view,
//                                                     attribute: .centerX,
//                                                     multiplier: 1.4,
//                                                     constant: 0)
//        constrainTitleLabel.identifier = "titleLabel placement X"
//        view.addConstraint(constrainTitleLabel)
//
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
//            ])
//
//
//        NSLayoutConstraint.activate([
//        enterDigitsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        enterDigitsLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30)
//        ])
//    }
//}
//
//struct AddCreditCardIntegratedController: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> AddCreditCardViewController {
//        return AddCreditCardViewController()
//    }
//    func updateUIViewController(_ uiViewController: AddCreditCardViewController, context: Context) {
//
//    }
//}
//
//
//struct AddCreditCard: View {
//    var body: some View {
//        //HeadingProfil()
//        AddCreditCardIntegratedController()
//    }
//}
//
//struct AddCreditCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(["iPhone 11 Pro"], id: \.self) { deviceName in
//            AddCreditCard()
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//        }
//    }
//}
