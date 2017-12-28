//
//  DetailViewController.swift
//  Pashto Proverbs
//
//  Created by Maihan Nijat on 2017-12-26.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DetailViewController: UIViewController, GADInterstitialDelegate {
    
    //MARK: -IBOutlets
    @IBOutlet weak var proverbLabel: UILabel!
    @IBOutlet weak var bannerAd: GADBannerView!
    
    //MARK: - Properties
    var proverbObj: Proverb?
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if proverbObj != nil {
            proverbLabel.text = proverbObj?.proverb
        }
        
        // Set font to UINavigation Title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BahijUthmanTaha-Bold", size: 24)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // Load Ad
        let ad = Banner(adView: bannerAd, parentController: self)
        ad.loadAd(testing: false)
        
        // Full screen add
        interstitialAd()
    }
    
    // Load full screen ad
    func interstitialAd(){
        let request = GADRequest()
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6404264627814552/7112581800")
        //request.testDevices = ["b285e2de2a9acf7444baa910e45c61e5"]
        interstitial.load(request)
        interstitial.delegate = self
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    @IBAction func addFavorite(_ sender: UIBarButtonItem) {
        
        let db = DatabaseManager()
        if proverbObj != nil {
            db.updateFavorite(proverb: proverbObj!, value: 1)
            let alert = UIAlertController(title: "Successfully Added!", message: "The proverb is successfully added to the favorite list", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        guard let proverb = proverbObj?.proverb else {return}
        let textToShare = ["\(String(describing: proverb))"]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
}
