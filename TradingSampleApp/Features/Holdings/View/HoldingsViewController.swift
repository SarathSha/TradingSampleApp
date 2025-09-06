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
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let viewModel: HoldingViewModelProtocol
    
    init(viewModel: HoldingViewModelProtocol = HoldingsViewModel()) {
        self.viewModel = viewModel
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
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            // Table view
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HoldingsTableViewCell.self, forCellReuseIdentifier: HoldingsTableViewCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func loadData() {
        viewModel.loadHoldings()
    }
    
    private func setupViewModel() {
        viewModel.onStateChange = { [weak self] in
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        switch viewModel.viewState {
        case .loading:
            break
        case .loaded:
            showLoadedState()
        }
    }
    
    private func showLoadedState() {
        tableView.reloadData()
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
