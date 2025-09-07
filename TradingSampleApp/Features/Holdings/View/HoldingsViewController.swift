//
//  HoldingViewController.swift
//  TradingSampleApp
//
//  Created by Sarath Sha on 06/09/25.
//

import UIKit

final class HoldingsViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let portfolioSummaryView: PortfolioSummaryView = {
        let view = PortfolioSummaryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .primaryBlue
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let errorView = HoldingsErrorView()

    private let viewModel: HoldingViewModelProtocol
    private let portfolioViewModel: PortfolioViewModelProtocol

    
    init(viewModel: HoldingViewModelProtocol = HoldingsViewModel(),
         portfolioViewModel: PortfolioViewModelProtocol = PortfolioViewModel()) {
        self.viewModel = viewModel
        self.portfolioViewModel = portfolioViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupViewModel()
        loadData()
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Portfolio"
        view.addSubviews(tableView, portfolioSummaryView, loadingView, errorView)
        tableView.pinToEdges(of: view)
        NSLayoutConstraint.activate([
            // Portfolio summary view
            portfolioSummaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            portfolioSummaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            portfolioSummaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        errorView.pinToEdges(of: view)
        loadingView.centerInSuperview()
        
        // Initially hide error view
        errorView.isHidden = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HoldingsTableViewCell.self, forCellReuseIdentifier: HoldingsTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        
        // Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func loadData() {
        viewModel.loadHoldings()
    }
    
    private func setupViewModel() {
        viewModel.onStateChange = { [weak self] in
            self?.updateUI()
        }
        
        portfolioViewModel.onStateChange = { [weak self] in
            self?.updatePortfolioSummary()
        }
    }
    
    private func updateUI() {
        switch viewModel.viewState {
        case .loading:
            showLoadedState()
        case .loaded:
            showLoadedState()
        case .error(let error):
            showErrorState(error: error)
        }
    }
    
    private func showLoadingState() {
        tableView.isHidden = true
        errorView.isHidden = true
        loadingView.startAnimating()
    }
    private func showLoadedState() {
        loadingView.stopAnimating()
        tableView.refreshControl?.endRefreshing()
        
        tableView.reloadData()
        
        // Update Portfolio summary
        portfolioViewModel.updatePortfolioSummary(from: viewModel.holdingsList)
        
        tableView.isHidden = false
        errorView.isHidden = true
    }

    private func showErrorState(error: Error) {
        loadingView.stopAnimating()
        tableView.refreshControl?.endRefreshing()
        
        tableView.isHidden = true
        errorView.isHidden = false
        
        errorView.configure(with: error)
        errorView.onRetryTapped = { [weak self] in
            self?.refreshData()
        }
    }
    @objc private func refreshData() {
        viewModel.refresh()
    }
    // MARK: - Portfolio Summary Updates
    
    private func updatePortfolioSummary() {
        guard let summary = portfolioViewModel.portfolioSummary else { return }
        portfolioSummaryView.configure(with: summary, isExpanded: portfolioViewModel.viewState.isExpanded)
    }
}

extension HoldingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.holdingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HoldingsTableViewCell.identifier) as? HoldingsTableViewCell else {
            return UITableViewCell()
        }
        let holding = viewModel.holdingsList[indexPath.row]
        let cellData = HoldingsCellData(from: holding)
        cell.configure(with: cellData)
        return cell
    }
}

extension HoldingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
