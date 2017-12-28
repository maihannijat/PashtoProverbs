//
//  ViewController.swift
//  Pashto Proverbs
//
//  Created by Maihan Nijat on 2017-12-16.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var proverbLabel: UILabel!
    @IBOutlet weak var bannerAd: GADBannerView!
    
    //MARK: - Properties
    var db: DatabaseManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Navigation bar background
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.451, green: 0.6353, blue: 0.0863, alpha: 1.0)

        db = DatabaseManager()
        
        // Generate random number // There are 7500 proverbs.
        // Avoid counting the rows, help performance
        let randomNumber = arc4random_uniform(7500) + 1;
        
        // Get proverb
        let proverb = db?.getProverb(proverbId: Int(randomNumber))
        if proverb != nil {
            proverbLabel.text = proverb?.proverb
        } else {
            proverbLabel.text = "په يوه ګل نه پسرلی کيږي"
        }
        
        // Load Ad
        let ad = Banner(adView: bannerAd, parentController: self)
        ad.loadAd(testing: false)
    }

}

