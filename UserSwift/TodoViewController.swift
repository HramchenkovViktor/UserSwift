//
//  TodoViewController.swift
//  UserSwift
//
//  Created by Виктор on 28.09.2026.
//

import UIKit
import SnapKit

class TodoViewController: UIViewController {

    private let titleLabel = UILabel()
    private let completedLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        Task {
          await  loadData()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(completedLabel)
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        completedLabel.numberOfLines = 0
        completedLabel.textAlignment = .center
        completedLabel.textColor = .black
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        completedLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    func loadData() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return }
        do {
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard (200..<300).contains(httpResponse.statusCode) else { return }
            
            let todo = try JSONDecoder().decode(Todo.self, from: data)
            
            await MainActor.run {
                self.titleLabel.text = todo.title
               
                    if todo.completed {
                        self.completedLabel.text = "✅ Выполнено"
                    } else {
                        self.completedLabel.text = "❌ Не выполнено"
                    }
                }
               
            
        } catch {
            print (error)
        }
    }

}
