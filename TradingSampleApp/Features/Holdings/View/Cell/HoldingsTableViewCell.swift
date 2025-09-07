//
//  HoldingsTableViewCell.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//
import UIKit

final class HoldingsTableViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .titleFont
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .captionFont
        label.textColor = .secondaryLabel
        label.text = "Qty:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityValueLabel: UILabel = {
        let label = UILabel()
        label.font = .captionFont
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ltpLabel: UILabel = {
        let label = UILabel()
        label.font = .captionFont
        label.textColor = .secondaryLabel
        label.text = "LTP:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ltpValueLabel: UILabel = {
        let label = UILabel()
        label.font = .priceFont
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pnlLabel: UILabel = {
        let label = UILabel()
        label.font = .captionFont
        label.textColor = .secondaryLabel
        label.text = "P&L:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pnlValueLabel: UILabel = {
        let label = UILabel()
        label.font = .priceFont
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static var identifier: String {
        String(describing: type(of: self))
    }
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(containerView)
        containerView.addSubviews(
            symbolLabel,
            quantityLabel,
            quantityValueLabel,
            ltpLabel,
            ltpValueLabel,
            pnlLabel,
            pnlValueLabel
        )

        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // Symbol label
            symbolLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            symbolLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            // Quantity label
            quantityLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 16),
            quantityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            // Quantity value
            quantityValueLabel.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            quantityValueLabel.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 4),
            
            // LTP value
            ltpValueLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            ltpValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // LTP label
            ltpLabel.centerYAnchor.constraint(equalTo: ltpValueLabel.centerYAnchor),
            ltpLabel.trailingAnchor.constraint(equalTo: ltpValueLabel.leadingAnchor, constant: -4),

            // P&L Value
            pnlValueLabel.topAnchor.constraint(equalTo: ltpLabel.bottomAnchor, constant: 16),
            pnlValueLabel.trailingAnchor.constraint(equalTo: ltpValueLabel.trailingAnchor),
            
            // P&L Label
            pnlLabel.centerYAnchor.constraint(equalTo: pnlValueLabel.centerYAnchor),
            pnlLabel.trailingAnchor.constraint(equalTo: pnlValueLabel.leadingAnchor, constant: -4)
        ])
    }
    
    // MARK: - Configuration
    func configure(with data: HoldingsCellData) {
        symbolLabel.text = data.symbol
        quantityValueLabel.text = data.quantity
        ltpValueLabel.text = data.lastTradedPrice
        pnlValueLabel.text = data.pnl
        pnlValueLabel.textColor = data.pnlColor
    }
}
