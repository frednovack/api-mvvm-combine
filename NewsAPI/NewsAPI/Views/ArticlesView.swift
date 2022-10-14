//
//  ViewController.swift
//  NewsAPI
//
//  Created by Frederico Novack on 10/14/22.
//

import UIKit
import SDWebImage
import Combine

class ArticlesView: UIViewController {

    private var viewModel: ArticlesViewModel = ArticlesViewModel()
    @IBOutlet weak var tableView: UITableView!
    private let cellID = "articleCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ArticleCell", bundle: Bundle.main), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        viewModel.getBrazilianBusinessHeadlines()
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        viewModel.$articles.sink { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.store(in: &viewModel.subscriptions)
    }

}

extension ArticlesView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? ArticleCell ?? ArticleCell(style: .default, reuseIdentifier: cellID)
        let article = viewModel.articles[indexPath.row]
        cell.authorLabel.text = article.author ?? ""
        cell.articleTitleLabel.text = article.title ?? ""
        cell.articleImageView.sd_setImage(with: URL(string:article.urlToImage ?? ""))
        cell.descriptionLabel.text = article.description ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}

