//
//  moodCell.swift
//  Subliminal
//
//  Created by Unis Barakat on 2/14/16.
//  Copyright © 2016 Unis Barakat. All rights reserved.
//

import UIKit

class moodCell: UITableViewCell {
    
      @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
