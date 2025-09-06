//
//  PortfolioSummaryView.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 07/09/25.
//


import UIKit

final class PortfolioSummaryView: UIView {
    
    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Collapsed State Views
    
    private let collapsedContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collapsedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Expanded State Views
    
    private let expandedContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let expandedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let currentValueRow = PortfolioSummaryRowView()
    private let totalInvestmentRow = PortfolioSummaryRowView()
    private let todaysPnlRow = PortfolioSummaryRowView()
    private let totalPnlRow = PortfolioSummaryRowView()
    private let totalPnlRowForCollapsed = PortfolioSummaryRowView()
    
    // MARK: - Properties
    
    private var isExpanded = false
    private var expandedHeightConstraint: NSLayoutConstraint?
    private var collapsedHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        // Collapsed state setup
        mainStackView.addArrangedSubview(collapsedContentView)
        collapsedContentView.addSubview(collapsedStackView)
        collapsedStackView.addArrangedSubview(totalPnlRowForCollapsed)

        // Expanded state setup
        mainStackView.addArrangedSubview(expandedContentView)
        expandedContentView.addSubview(expandedStackView)

        expandedStackView.addArrangedSubview(currentValueRow)
        expandedStackView.addArrangedSubview(totalInvestmentRow)
        expandedStackView.addArrangedSubview(todaysPnlRow)
        expandedStackView.addArrangedSubview(totalPnlRow)
        
        // Initially show collapsed state
        updateViewState()
    }
    
    private func setStackView(isHidden: Bool) {
        currentValueRow.isHidden = isHidden
        totalInvestmentRow.isHidden = isHidden
        todaysPnlRow.isHidden = isHidden
    }
    private func createStackViewWithLabels(_ labels: [UILabel]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // Main stack view
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        collapsedStackView.pinToEdges(of: collapsedContentView)
        expandedStackView.pinToEdges(of: expandedContentView)
        // Height constraints
        collapsedHeightConstraint = collapsedContentView.heightAnchor.constraint(equalToConstant: 40)
        expandedHeightConstraint = expandedContentView.heightAnchor.constraint(equalToConstant: 160)
        
        collapsedHeightConstraint?.isActive = true
        expandedHeightConstraint?.isActive = false
    }
    
    private func setupActions() {
        mainStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandButtonTapped)))
    }

    // MARK: - Actions
    
    @objc private func expandButtonTapped() {
        toggleExpandedState()
    }
    
    // MARK: - Public Methods
    
    func configure(with summary: PortfolioSummary, isExpanded: Bool = false) {
        self.isExpanded = isExpanded
        updateLabels(with: summary)
        updateViewState()
    }
    
    func toggleExpandedState() {
        isExpanded.toggle()
        animateStateChange()
    }
    
    func setExpandedState(_ expanded: Bool) {
        guard isExpanded != expanded else { return }
        isExpanded = expanded
        animateStateChange()
    }
    
    // MARK: - Private Methods
    
    private func updateLabels(with summary: PortfolioSummary) {
        let displayData = PortfolioDisplayData(from: summary)
        
        // Collapsed state labels
        totalPnlRowForCollapsed.configure(title: "Profit & Loss*", value: "\(displayData.totalPnlText) (\(displayData.totalPnlPercentageText))", valueColor: displayData.totalPnlColor)

        // Expanded state rows
        currentValueRow.configure(title: "Current value*", value: displayData.currentValueText, valueColor: .label)
        totalInvestmentRow.configure(title: "Total investment*", value: displayData.totalInvestmentText, valueColor: .label)
        todaysPnlRow.configure(title: "Today's Profit & Loss*", value: displayData.todaysPnlText, valueColor: displayData.todaysPnlColor)
        totalPnlRow.configure(title: "Profit & Loss*", value: "\(displayData.totalPnlText) (\(displayData.totalPnlPercentageText))", valueColor: displayData.totalPnlColor)
        
    }
    
    private func updateViewState() {
        collapsedContentView.isHidden = isExpanded
        collapsedStackView.isHidden = isExpanded
        expandedContentView.isHidden = !isExpanded
        expandedStackView.isHidden = !isExpanded
        collapsedHeightConstraint?.isActive = !isExpanded
        expandedHeightConstraint?.isActive = isExpanded
    }
    
    private func animateStateChange() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.showHideTransitionViews], animations: { [weak self] in
            self?.updateViewState()
        })
    }
}

// MARK: - Portfolio Summary Row View

private final class PortfolioSummaryRowView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(titleLabel, valueLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8)
        ])
    }
    
    func configure(title: String, value: String, valueColor: UIColor) {
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = valueColor
    }
}
