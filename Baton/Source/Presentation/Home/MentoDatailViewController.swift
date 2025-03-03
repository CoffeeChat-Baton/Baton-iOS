import UIKit

extension MentoDatailViewController: BatonNavigationConfigurable {
    @objc func baseBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

class MentoDatailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bwhite
        setupNavigationBar()
    }
    
    // MARK: - NavigationBar
    private func setupNavigationBar() {
        let backButton = BatonNavigationButton.backButton(target: self, action: #selector(baseBackButtonTapped))
        setupBaseNavigationBar(title: "", backButton: backButton)
    }
}

#if DEBUG
import SwiftUI

struct MentoDatailViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MentoDatailViewController {
        return MentoDatailViewController()
    }
    
    func updateUIViewController(_ uiViewController: MentoDatailViewController, context: Context) {}
}

struct MentoDatailViewController_Previews: PreviewProvider {
    static var previews: some View {
        MentoDatailViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // 전체 화면에 맞게 표시
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
