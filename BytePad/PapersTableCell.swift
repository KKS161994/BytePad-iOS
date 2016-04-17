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
    @IBOutlet weak var examTypeLabel: UILabel!
    
    func initCell(paperName: String, examType: String)  {
        self.paperNameLabel.text = paperName
        self.examTypeLabel.text = examType
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
