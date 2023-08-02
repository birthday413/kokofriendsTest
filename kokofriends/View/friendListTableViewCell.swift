//
//  friendListTableViewCell.swift
//  kokofriends
//
//  Created by crawford on 2023/7/28.
//

import UIKit

class friendListTableViewCell: UITableViewCell {
    @IBOutlet weak var imageOfTop: UIImageView!
    @IBOutlet weak var imageOfhead: UIImageView!
    @IBOutlet weak var labelOfName: UILabel!
    @IBOutlet weak var buttonOfRemit: UIButton!
    @IBOutlet weak var LabelOfInvite: UILabel!
    
    @IBOutlet weak var imageOfhead2: UIImageView!
    @IBOutlet weak var labelOfName2: UILabel!
    @IBOutlet weak var buttonOfOK: UIButton!
    @IBOutlet weak var buttonOfCancle: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
