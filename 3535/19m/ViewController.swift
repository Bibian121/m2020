//
//  ViewController.swift
//  19m
//
//  Created by Matilda Davydov on 26.10.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var artist:Artist?
    

    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var birthText: UITextField!
    
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var occupationText: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var lastnameText: UITextField!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let artist = artist {
            birthText.text = artist.birth
            occupationText.text = artist.occupation
            countryText.text = artist.country
            lastnameText.text = artist.lastname
            nameText.text = artist.name
        }
        birthText.delegate = self
    }
    
    @IBAction func saveData() {
        artist?.name = nameText.text
        artist?.lastname = lastnameText.text
        artist?.country = countryText.text
        artist?.occupation = occupationText.text
        artist?.birth = birthText.text
        
        try? artist?.managedObjectContext?.save()
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if (birthText.text?.contains("+7"))! {
    guard NSCharacterSet(charactersIn: "+0123456789").isSuperset(of: NSCharacterSet(charactersIn: string) as CharacterSet) else {
    return false
    }
  }
    return true
    }
}


