//
//  PapersTableCell.swift
//  BytePad
//
//  Created by Utkarsh Bansal on 17/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit

class PapersTableCell: UITableViewCell {

    @IBOutlet weak var paperNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
//    @IBOutlet weak var downloadSpinner: UIActivityIndicatorView!
    
    func initCell(paperName: String, detail: String)  {
        self.paperNameLabel.text = paperName
        self.detailLabel.text = detail
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
