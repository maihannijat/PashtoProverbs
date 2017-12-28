//
//  Proverb.swift
//  Pashto Proverbs
//
//  Created by Maihan Nijat on 2017-12-17.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

class Proverb {
    var id: Int?
    var category: String?
    var proverb: String?
    var fav: Bool?
    
    init(id: Int, category: String, proverb: String, fav: Int) {
        self.id = id
        self.category = category
        self.proverb = proverb
        if fav == 1 { self.fav = true } else { self.fav = false}
    }
}
