//
//  TableViewCell.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/8/4.
//

import Foundation
import UIKit

class FPDemoTableViewCell: UITableViewCell , FPBaseView
{
    private lazy var nameLabel = UILabel()
    private lazy var subNameLabel = UILabel()
    
    private weak var viewModel: ViewModel?
    private weak var item: MVVMItem?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        do {
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.font = UIFont.systemFont(ofSize: 20)
            nameLabel.adjustsFontForContentSizeCategory = true
            nameLabel.numberOfLines = 0
            nameLabel.isAccessibilityElement = true
            
            contentView.addSubview(nameLabel)
        }
        
        do {
            subNameLabel.translatesAutoresizingMaskIntoConstraints = false
            subNameLabel.font = UIFont.systemFont(ofSize: 12)
            subNameLabel.adjustsFontForContentSizeCategory = true
            subNameLabel.numberOfLines = 0
            subNameLabel.isAccessibilityElement = true
            
            contentView.addSubview(subNameLabel)
        }
        
        NSLayoutConstraint.activate([
            // subview
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: subNameLabel.topAnchor, constant: -4),
            
            // name
            subNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -4),
            subNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            subNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 16),
            subNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func bindViewModel(viewModel: AnyObject?) {
        self.viewModel = viewModel as? ViewModel
    }
    
    func updateViewWith(item: AnyObject?) {
        let i = item as? MVVMItem
        nameLabel.text = i?.name ?? ""
        subNameLabel.text = i?.subName ?? ""
    }
}
