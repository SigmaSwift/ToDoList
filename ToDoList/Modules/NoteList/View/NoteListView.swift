//
//  NoteListView.swift
//  ToDoList
//
//  Created by Khachatur Sargsyan on 25.07.25.
//

import UIKit

final class NoteListView: UIViewController {
    var presenter: INoteListPresenter?
    
    private let tableView: UITableView = .init()
    private let searchBarView: SearchBarView = .init()
    private let totalLabel: UILabel = .init()
    private let blurView: UIVisualEffectView = .init()
    private var contextMenuView: ContextMenuView = .init()
    
    private let footerViewHeight: CGFloat = 100
    
    enum Section: Hashable {
        case main
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, Note>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureHeader()
        configureTableView()
        configureDataSource()
        configureFooter()
        
        presenter?.viewDidLoaded()
    }
        
    private func configureHeader() {
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBarView)
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        searchBarView.textDidChanged = { [weak self] input in
            guard let self else { return }
            
            presenter?.filterNotes(with: input)
        }
    }
    
    private func configureFooter() {
        let addNoteButton = UIButton(type: .system)
        addNoteButton.setImage(.init(systemName: "square.and.pencil"), for: .normal)
        addNoteButton.tintColor = DesignSystem.Color.darkYellow
        addNoteButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        
        totalLabel.textColor = DesignSystem.Color.primaryWhite
        totalLabel.font = .systemFont(ofSize: 22)
        
        let spacer = UIView()
        let hStack = UIStackView(arrangedSubviews: [ spacer, totalLabel, addNoteButton ])
        hStack.axis = .horizontal
        hStack.distribution = .equalCentering
        
        let footerView = UIView()
        footerView.backgroundColor = DesignSystem.Color.primaryGray
        footerView.addSubview(hStack)
        
        view.addSubview(footerView)
        
        [ footerView, hStack ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let padding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            footerView.heightAnchor.constraint(equalToConstant: footerViewHeight),
            footerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            footerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hStack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: padding),
            hStack.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -padding),
            hStack.topAnchor.constraint(equalTo: footerView.topAnchor, constant: padding)
        ])
    }
    
        
    private func configureTableView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        
        tableView.register(NoteCellView.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .init(top: 10, left: 20, bottom: 10, right: 20)
        tableView.backgroundColor = DesignSystem.Color.primaryBlack
        tableView.separatorColor = DesignSystem.Color.secondaryGray
        tableView.rowHeight = UITableView.automaticDimension
        tableView.addGestureRecognizer(longPress)
        
        
        view.addSubview(tableView)
   
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -footerViewHeight)
        ])
    }
    
    //MARK: - Table view DataSource and Snapshot -
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Note>(tableView: tableView) { tableView, indexPath, note in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteCellView else { return NoteCellView() }
                    
            cell.configure(with: note)
            
            return cell
        }
    }
    
    private func applySnapshot(notes: [Note], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        snapshot.appendSections([.main])
        snapshot.appendItems(notes)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func showContextMenu(on note: Note) {
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = .zero
        blurView.frame = view.frame
        view.addSubview(blurView)
        
        contextMenuView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contextMenuView)
                        
        contextMenuView.update(note)
    
        let padding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            contextMenuView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -padding),
            contextMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contextMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contextMenuView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        contextMenuView.alert.didTap = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .edit:
                presenter?.didTapOn(note, isEditable: true)
                hideContextMenu()
            case .delete:
                presenter?.delete(note.id)
                hideContextMenu()
            case .share:
                // No need to implemeted
                print("Share")
            }
        }
        
        blurView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(hideContextMenu)
        ))
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            
            [ blurView, contextMenuView ].forEach { $0.alpha = 1 }
        }
    }
    
    // MARK: - Actions -
    
    @objc
    private func addNoteTapped() {
        presenter?.addNoteDidTap()
    }
    
    @objc
    private func hideContextMenu() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            
            [ blurView, contextMenuView ].forEach { $0.alpha = 0 }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            
            [ blurView, contextMenuView ].forEach { $0.removeFromSuperview() }
        }
    }
    
    @objc
    private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if let note = dataSource.itemIdentifier(for: indexPath) {
                    showContextMenu(on: note)
                }
            }
        }
    }
}

extension NoteListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let note = dataSource.itemIdentifier(for: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            presenter?.didTapOn(note, isEditable: false)
        }
    }
}

extension NoteListView: INoteListView {
    func show(_ notes: [Note]) {
        applySnapshot(notes: notes)
        self.totalLabel.text = "Notes: \(notes.count)"
    }
    
    func update(_ notes: [Note]) {
        applySnapshot(notes: notes, animatingDifferences: true)
        self.totalLabel.text = "Notes: \(notes.count)"
    }
}

struct DesignSystem {
    enum Color {
        static let primaryGray = UIColor(hex: "#272729")
        static let secondaryGray = UIColor(hex: "#4D555E")
        
        static let primaryWhite = UIColor(hex: "#F4F4F4")
        static let primaryBlack = UIColor(hex: "#040404")
        
        static let darkYellow = UIColor(hex: "#FED702")
    }
}
