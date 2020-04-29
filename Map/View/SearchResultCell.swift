//
//  SearchResultCell.swift
//  Map
//
//  Created by Rodrigo Buendia Ramos on 4/26/20.
//  Copyright © 2020 Rodrigo Buendia Ramos. All rights reserved.
//
import UIKit

class SearchResultCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Handlers
    func configure(title: String) {
        titleLabel.text = title
    }
}
