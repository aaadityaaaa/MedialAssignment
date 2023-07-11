//
//  PDFViewerViewController.swift
//  MedialAssignment
//
//  Created by Aaditya Singh on 11/07/23.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers

class PDFViewerViewController: UIViewController, PDFViewDelegate {
    
    private lazy var pdfView: PDFView = {
        let view = PDFView()
        view.delegate = self
        view.backgroundColor = .systemBackground
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.title = "PDF Viewer"
        view.backgroundColor = .secondarySystemBackground
    }
}

extension PDFViewerViewController {
    
    private func setupViews() {
        view.addSubview(pdfView)
        pdfView.pin(edges: .leading(padding: 0), .trailing(padding: 0), .bottom(padding: 0), .safeAreaTop(padding: 0))
        
        let importButton: UIBarButtonItem
        importButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importButtonTapped(_ :)))
        navigationItem.rightBarButtonItem = importButton

    }
    
    @objc private func importButtonTapped(_ sender: UIButton) {
        showDocumentPicker()
    }
    
    private func showDocumentPicker() {
        let documentPicker: UIDocumentPickerViewController
        let pdfType = "com.adobe.pdf"
        
        if #available(iOS 14.0, *) {
            let documentTypes = UTType.types(tag: "pdf", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
        } else {
            documentPicker = UIDocumentPickerViewController(documentTypes: [pdfType], in: .import)
        }
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    private func displayPDF(url: URL) {
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Failed to load the PDF document.")
            return
        }
        pdfView.document = pdfDocument
        pdfView.autoScales = true
    }
    
}


extension PDFViewerViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        displayPDF(url: url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
