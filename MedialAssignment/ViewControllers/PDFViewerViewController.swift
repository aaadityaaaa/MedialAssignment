//
//  PDFViewerViewController.swift
//  MedialAssignment
//
//  Created by Aaditya Singh on 11/07/23.
//

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {
    
    private lazy var pdfView: PDFView = {
        let view = PDFView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }

}

extension PDFViewerViewController {
    
    private func setupViews() {
        
    }
}

