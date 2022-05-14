//
//  MainTableViewCell.swift
//  UsefulConnections + MVP + Realm
//
//  Created by Vasily on 12.05.2022.
//

import UIKit
import SwiftUI

class MainTableViewCell: UITableViewCell {

    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    let accountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "/10"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(ratingLabel)
        contentView.addSubview(numberLabel)
        
        let verticalStackView = UIStackView(arrangedSubviews: [emailLabel, accountLabel])
        verticalStackView.spacing = 0
        verticalStackView.distribution = .fillProportionally
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
          
        contentView.addSubview(verticalStackView)
        verticalStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: ratingLabel.leftAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 10, width: 200, height: 60, enableInsets: false)
        ratingLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: numberLabel.leftAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 0, width: 30, height: 60, enableInsets: false)
        numberLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 15, width: 30, height: 60, enableInsets: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
