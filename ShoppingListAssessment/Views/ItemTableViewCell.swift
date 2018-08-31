//
//  ItemTableViewCell.swift
//  ShoppingListAssessment
//
//  Created by Cody on 8/31/18.
//  Copyright © 2018 Cody Adcock. All rights reserved.
//

import UIKit

protocol ItemTableViewCellDelegate: class{
    func togglePurchased(cell: ItemTableViewCell)
    func textFieldChanged(cell: ItemTableViewCell, newItem: String)
}

class ItemTableViewCell: UITableViewCell {
    
    //IBOutlets
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var purchasedButton: UIButton!
    
    weak var delegate: ItemTableViewCellDelegate?
    
    var item: Item?{
        didSet{
            updateView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        guard let newItem = textField.text else {return}
        delegate?.textFieldChanged(cell: self, newItem: newItem)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(){
        guard let item = item else {return}
        itemLabel.text = item.name
        updateButton()
    }
    
    func updateButton(){
        guard let item = item else {return}
        
        if item.isPurchased{
            purchasedButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        }else{
            purchasedButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }
    
    //Checkmark button tapped - use delegate
    @IBAction func purchasedButtonTapped(_ sender: Any) {
        delegate?.togglePurchased(cell: self)
    }
}
