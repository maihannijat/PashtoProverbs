//
//  CategoryViewController.swift
//  Pashto Proverbs
//
//  Created by Maihan Nijat on 2017-12-26.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerAd: GADBannerView!
    
    //MARK: - Properties
    var db: DatabaseManager?
    var categories: [String]?
    var categoriesDic: [String:Int]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate Database and get categories
        db = DatabaseManager()
        if let categoriesDic = db?.selectCategories() {
            categories = Array(categoriesDic.keys).sorted(by: <)
            self.categoriesDic = categoriesDic
        }
        
        // set table row height
        tableView.rowHeight = 100
        
        // Set font to UINavigation Title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BahijUthmanTaha-Bold", size: 24)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // Load Ad
        let ad = Banner(adView: bannerAd, parentController: self)
        ad.loadAd(testing: false)
    }
    
    // Number of rows in section
    // 0 if categories is nil
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    // Assign text to the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryViewCell
        if let categoryText = categories?[indexPath.row] {
            cell.categoryLabel?.text = categoryText
            if let countText = categoriesDic?[categoryText] {
                cell.countLabel?.text = String(countText)
            }
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
    
    // Open Proverbs View Controller when tapped
    // Pass category
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "proverbs" {
            let proverbsViewController = segue.destination as! ProverbsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                proverbsViewController.category = categories?[indexPath.row]
            }
        }
    }
}
