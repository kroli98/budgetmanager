import SwiftUI
import CoreData
import UIKit
import VisionKit
import Vision

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @State private var itemName = ""
    @State private var itemCategory = ""
    @State private var itemPrice = ""
    @State private var itemQuantity = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var imagePath: String = ""
    @State private var selectedCategoryIndex = 0
    @State private var selectedIncomeTypeIndex = 0
    let incomeTypes = ["Kiadás", "Bevétel"]
    @State var selectedDate: Date
    @State private var categories: [String] = []

    init(selectedDate: Date) {
        _selectedDate = State(initialValue: selectedDate)
        if let savedCategories = UserDefaults.standard.array(forKey: "categories") as? [String] {
            self.categories = savedCategories
        }
    }
    private func loadCategories() {
        if let savedCategories = UserDefaults.standard.array(forKey: "categories") as? [String] {
            self.categories = savedCategories
        }
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Név")) {
                    TextField("Adj meg egy nevet", text: $itemName)
                }

                Section(header: Text("Kategória")) {
                    Picker(selection: $selectedCategoryIndex, label: Text("Válassz kategóriát")) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(self.categories[index]).tag(index)
                        }
                    }.onAppear {
                        loadCategories()
                    }
                }

                Section(header: Text("Összeg")) {
                    TextField("Adj meg egy összeget", text: $itemPrice)
                        .keyboardType(.decimalPad)
                }
                

                Section(header: Text("Mennyiség")) {
                    TextField("Adj meg egy mennyiséget", text: $itemQuantity)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Típus")) {
                    Picker("Válassz típust", selection: $selectedIncomeTypeIndex) {
                        ForEach(0..<incomeTypes.count, id: \.self) { index in
                            Text(self.incomeTypes[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Kép")) {
                    if let image = inputImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Text("Válassz egy képet")
                        }
                    }
                }
            }
            .navigationBarTitle("Tétel hozzáadása")
            .navigationBarItems(
                leading:
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Mégsem")
                    },
                trailing:
                    Button(action: {
                        addItem()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Mentés")
                    }
                    .disabled(!isValidForm())
            )
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
        }
    }

    private func loadImage() {
        guard let inputImage = inputImage else { return }
        imagePath = saveImageToDocumentsDirectory(inputImage)
        
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
           
            let price = extractPrice(from: observations)
            DispatchQueue.main.async {
                itemPrice = price
            }
        }
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["hu-HU"]
        
     
        let handler = VNImageRequestHandler(cgImage: inputImage.cgImage!, options: [:])
        try? handler.perform([request])
    }

   
    private func extractPrice(from observations: [VNRecognizedTextObservation]) -> String {
        var price = ""

      
        let fullText = observations
            .flatMap { $0.topCandidates(1) }
            .map { $0.string }
            .joined(separator: "\n")
        print(fullText)
        

        if let osszesenRange = fullText.range(of: "ÖSSZESEN", options: .regularExpression) {
            let remainingText = String(fullText[osszesenRange.upperBound...])
            let regexPattern = #"(\d+)\s*Ft"#
            
            if let regex = try? NSRegularExpression(pattern: regexPattern, options: []) {
                let matches = regex.matches(in: remainingText, options: [], range: NSRange(remainingText.startIndex..., in: remainingText))
                
                if let firstMatch = matches.first {
                    let numberRange = Range(firstMatch.range(at: 1), in: remainingText)!
                    let number = Int(remainingText[numberRange])!
                    print(number)
                    price = String(number)
                }
            }
        }
        return price
    }





    private func addItem() {
        let newItem = ListItem(context: viewContext)
        newItem.name = itemName
        let categories = UserDefaults.standard.array(forKey: "categories") as? [String] ?? [String]()
        newItem.category = categories[selectedCategoryIndex]
        var itemPriceDouble = Double(itemPrice) ?? 0.0
        if selectedIncomeTypeIndex == 0 { // "Kiadás" is selected
            itemPriceDouble = -itemPriceDouble
        }
        newItem.price = itemPriceDouble
        newItem.quantity = Int16(itemQuantity) ?? 0
        newItem.imagePath = imagePath
        newItem.date = selectedDate

        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }



    private func isValidForm() -> Bool {
        !itemName.isEmpty && selectedCategoryIndex >= 0 && selectedCategoryIndex < (UserDefaults.standard.array(forKey: "categories") as? [String] ?? []).count && !itemPrice.isEmpty && !itemQuantity.isEmpty
    }


    private func saveImageToDocumentsDirectory(_ image: UIImage) -> String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL)
        }
        return fileName
    }
}
struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(selectedDate: Date())
                   .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
           }
}
