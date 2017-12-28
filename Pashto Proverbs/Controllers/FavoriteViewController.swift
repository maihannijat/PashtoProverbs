//
//  FavoriteViewController.swift
//  Pashto Proverbs
//
//  Created by Maihan Nijat on 2017-12-26.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerAd: GADBannerView!
    
    //MARK: - Properties
    var db: DatabaseManager?
    var proverbs: [Proverb]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all proverbs of the category
        db = DatabaseManager()
        if db != nil {
            proverbs = db!.selectProverbs(condition: nil)
        }
        
        // Set font to UINavigation Title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BahijUthmanTaha-Bold", size: 24)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // Load Ad
        let ad = Banner(adView: bannerAd, parentController: self)
        ad.loadAd(testing: false)
        
        // Set tableView row height
        tableView.rowHeight = 160
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if db != nil {
                guard let proverb = proverbs?[indexPath.row] else {return}
                db!.updateFavorite(proverb: proverb, value: 0)
                proverbs?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
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
