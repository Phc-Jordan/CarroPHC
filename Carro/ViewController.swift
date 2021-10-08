//
//  ViewController.swift
//  Carro
//
//  Created by 彭汉昌 on 2021/10/8.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Carro"
    }

    @IBAction func onClick() {
        let vc = CountrySelectVC()
        vc.backCountryCode = { [weak self] country, area in
            self?.countryLabel.text = country
            self?.areaLabel.text = area
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

