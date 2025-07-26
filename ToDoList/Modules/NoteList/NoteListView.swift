//
//  NoteListView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

extension NoteListView: INoteListView {
    func show(_ notes: [Note]) {
        self.notes = notes
        applySnapshot(notes: notes)
    }
}

class NoteListView: UIViewController {
    var presenter: INoteListPresenter?
    
    private var tableView: UITableView = .init()
    private var searchController: UISearchController = .init(searchResultsController: nil)
    
    private var notes: [Note] = []
    private var filteredNotes: [Note] = []
    
    enum Section {
        case main
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, Note>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoaded()
        
        view.backgroundColor = .white
        
        setupHeader()
        setupTableView()
        setupDataSource()
    }
    
    private func setupHeader() {
        title = "ToDos"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Note>(tableView: tableView) { tableView, indexPath, note in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            
            content.text = note.todo
            content.secondaryText = note.completed ? "✅ Done" : "⏱️ Not Done"
            cell.contentConfiguration = content
            
            return cell
        }
    }
    
    private var contextMenu: UIView = .init()
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        
        if let superView = navigationController?.view {
            superView.addSubview(blurEffectView)
            blurEffectView.frame = superView.frame
            
            contextMenu.frame = .init(origin: .zero, size: .init(width: 200, height: 100))
            contextMenu.layer.cornerRadius = 10
            contextMenu.backgroundColor = .red
            contextMenu.center = blurEffectView.contentView.center
            contextMenu.alpha = 0
            
            blurEffectView.contentView.addSubview(contextMenu)
            
            UIView.animate(withDuration: 0.25, delay: 0) {
                blurEffectView.alpha = 1
                self.contextMenu.alpha = 1
            }
        }
    }
    
    private func removeContextMenu() {
        contextMenu.removeFromSuperview()
    }
    
    @objc
    private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if let note = dataSource.itemIdentifier(for: indexPath) {
                    print("Note id: \(note.id)")
                    print("Note descrition: \(note.todo)")
                    
                    addBlur()
                }
            }
        }
    }
    
    private func applySnapshot(notes: [Note], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        snapshot.appendSections([.main])
        snapshot.appendItems(notes)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func didTap(_ note: Note, isEditable: Bool) {
        presenter?.didTap(note, isEditable: isEditable)
    }
}

extension NoteListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let note = dataSource.itemIdentifier(for: indexPath) {
            didTap(note, isEditable: false)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension NoteListView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            applySnapshot(notes: notes, animatingDifferences: true)
        } else {
            let filteredNotes = notes.filter { $0.todo.lowercased().contains(searchText.lowercased()) }
            applySnapshot(notes: filteredNotes, animatingDifferences: true)
        }
    }
}
