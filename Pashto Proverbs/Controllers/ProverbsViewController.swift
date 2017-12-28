//
//  ProverbsViewController.swift
//  Pashto Proverbs
//
//  Created by Maihan Nijat on 2017-12-26.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ProverbsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: -IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerAd: GADBannerView!
    
    //MARK: - Properties
    var db: DatabaseManager?
    var category: String?
    var proverbs: [Proverb]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all proverbs of the category
        db = DatabaseManager()
        if category != nil {
            proverbs = db?.selectProverbs(condition: category!)
        }
        
        // Set tableView row height
        tableView.rowHeight = 160
        
        // Set font to UINavigation Title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BahijUthmanTaha-Bold", size: 24)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // Load Ad
        let ad = Banner(adView: bannerAd, parentController: self)
        ad.loadAd(testing: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proverbs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProverbViewCell
        if let proverb = proverbs?[indexPath.row] {
            cell.proverbLabel?.text = proverb.proverb
        }
        return cell
    }
    
    //Mark: - Display Cell Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Set initial value
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proverbDetailView" {
            let detailViewController = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailViewController.proverbObj = proverbs?[(indexPath.row)]
            }
        }
    }
}
