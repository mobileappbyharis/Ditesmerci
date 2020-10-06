//
//  Extensions.swift
//  Ditesmerci
//
//  Created by 7k04 on 10/06/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}

extension UIColor {
    static var mainPink = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
    static var mainBlue = UIColor(red: 68/255, green: 133/255, blue: 232/255, alpha: 1)
    static var mainBlueAlpha = UIColor(red: 68/255, green: 133/255, blue: 232/255, alpha: 0.3)
    
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "seconde"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "minute"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "heure"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "jour"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "semaine"
        } else if secondsAgo < year {
            quotient = secondsAgo / month
            if (quotient != 1){
                unit = "moi"
            } else {
                unit = "mois"
            }
        } else {
            quotient = secondsAgo / year
            unit = "année"
        }
        return "il y a \(quotient) \(unit)\(quotient == 1 ? "" : "s")"
    }
}



extension UIButton {
    
    func animatePressButton(){
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIButton.animate(withDuration: 2.0,
                         delay: 0,
                         usingSpringWithDamping: CGFloat(0.20),
                         initialSpringVelocity: CGFloat(6.0),
                         options: UIButton.AnimationOptions.allowUserInteraction,
                         animations: {
                            self.transform = CGAffineTransform.identity
        },
                         completion: { Void in()  }
        )
        
    }
    
    func pulsate(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}

extension UIViewController {
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func isAValideFrenchPhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "^(?:(?:\\+|00)33|0)\\s*[6-7](?:[\\s.-]*\\d{2}){4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func displayAlertErrorUI(title: String, message: String, answer: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: answer, style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayWaitSpinner(alertController: UIAlertController){
        let spinnerIndicator = UIActivityIndicatorView(style: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
    }
    
    
    
    func returnGoodPhoneNumber(phoneNumber: String) -> String {
        print("it's a valide phone number")
        if(phoneNumber.prefix(1) == "0"){
            print("write 0")
            let subPhoneNumber = phoneNumber.dropFirst()
            let stringPhoneNumber = String(subPhoneNumber)
            let validePhoneNumber = "+33" + stringPhoneNumber
            print("subPhoneNumber : \(subPhoneNumber)")
            print("stringPhoneNumber : \(stringPhoneNumber)")
            print("validePhoneNumber : \(validePhoneNumber)")
            return validePhoneNumber
        }
        return phoneNumber
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
