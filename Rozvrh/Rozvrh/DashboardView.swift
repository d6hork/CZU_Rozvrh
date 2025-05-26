//
//  DashboardView.swift
//  Rozvrh
//
//  Created by Dominik Horký on 24.10.2024.
//

import SwiftUI
import WebKit

struct DashboardView: View {
    @State private var subjects: [String] = []
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                
                if isLoading {
                    ProgressView("Načítání...")
                } else {
                    List(groupedSubjects, id: \.self) { group in
                        Text(group)
                    }
                }
            }
            .onAppear(perform: loadSubjects)
            .navigationTitle("Předměty")
        }
    }

    private var groupedSubjects: [String] {
        let filteredSubjects = subjects.dropFirst(8).dropLast(2)
        
        var result: [String] = []
        for (index, _) in filteredSubjects.enumerated() {
            if index % 3 == 0 {
                let nextTwoSubjects = filteredSubjects.dropFirst(index).prefix(3)
                result.append(nextTwoSubjects.joined(separator: ", "))
            }
        }
        return result
    }

    private func loadSubjects() {
      
        // Simulovaná data pro náhled v Canvasu
        subjects = ["Matematika", "Fyzika", "Biologie", "Chemie", "Angličtina", "Historie", "Zeměpis", "Programování"]
        isLoading = false
     
        guard let url = URL(string: "https://is.czu.cz/auth/katalog/rozvrhy_view.pl?rozvrh_student_obec=1?zobraz=1;format=html;rozvrh_student=259591;zpet=../student/moje_studium.pl?_m=3110,studium=339644,obdobi=1230") else {
            print("Neplatná URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Chyba: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Nebyly nalezeny žádné data.")
                return
            }

            guard let htmlString = String(data: data, encoding: .utf8) else {
                print("Nepodařilo se převést data na HTML string.")
                return
            }

            let pattern = "<a href=\"[^\"]*\">([^<]*)</a>"
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: htmlString.utf16.count)
            let results = regex?.matches(in: htmlString, options: [], range: range)

            subjects = results?.compactMap { result in
                guard let range = Range(result.range(at: 1), in: htmlString) else { return nil }
                return String(htmlString[range])
            } ?? []

            DispatchQueue.main.async {
                isLoading = false
            }
        }

        task.resume()
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
