//
//  DetailsView.swift
//  budgetmanager
//
//  Created by Kiss Roland on 2023. 05. 30..
//
import SwiftUI

struct DetailView: View {
    
    func loadImageFromDisk(with fileName: String) -> UIImage {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image ?? UIImage(systemName: "photo")!
        }
        return UIImage(systemName: "photo")!
    }

    let listItem: ListItem

    var body: some View {
        VStack(alignment: .leading) {
            Text("Név: \(listItem.name ?? "")")
            Text("Kategória: \(listItem.category ?? "")")
            Text("Összeg: \(Int(listItem.price)) Ft")
            Text("Darabszám: \(Int(listItem.quantity))")
            Image(uiImage: loadImageFromDisk(with: listItem.imagePath ?? ""))
                           .resizable()
                           .scaledToFit()
        }
        .padding()
        .navigationTitle("Tétel részletek")
    }
}


