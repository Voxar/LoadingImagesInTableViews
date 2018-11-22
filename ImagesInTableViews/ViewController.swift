import UIKit

class Model {
    let placeHolderImage = UIImage(named: "placeholder")
    
    var imageDidChange: (IndexPath) -> () = {_ in }
    
    let images = [
        URL(string: "https://i.imgur.com/8EjEjZd_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/azTNdMg_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/2hdJcAU_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/ssv5LZz_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/8YKaqeZ_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/jeMQFFU_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/W1vKObA_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/A4qhpIg_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/WUO0Wkg_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/8qzJCHP_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/lFFQtvK_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/HqEUeO3_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/QA77fev_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/9O74cYT_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/Xpb85PK_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/dzExAC6_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/8l0ahXf_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/FbRmKJS_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/ZXTdEfh_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/7fNu64g_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/gF2LUIz_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/Xgwavb0_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/tbcNeFN_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/hRFGyiv_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/9LcoWAu_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/as8ACWw_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/EkqC1hl_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/bO3qqpb_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/NLHDmew_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/2mS6TyI_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/nf4yGk8_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
        URL(string: "https://i.imgur.com/xQfhLe5_d.jpg?maxwidth=520&shape=thumb&fidelity=high")!,
    ]
    
    struct ImageTask {
        var url: URL
        var task: URLSessionTask?
        var image: UIImage = UIImage(named: "placeholder")!
    }
    
    var cache: [IndexPath: ImageTask] = [:]
    
    func title(at indexPath: IndexPath) -> String? {
        return cache[indexPath] == nil ? "Loading..." : images[indexPath.row].lastPathComponent
    }
    
    func image(at indexPath: IndexPath) -> UIImage? {
        if let task = cache[indexPath] {
            return task.image
        }
        
        let url = images[indexPath.row]
        let task = URLSession.shared.dataTask(with: images[indexPath.row]) { data, _, _ in
            if let data = data {
                if let image = UIImage(data: data) {
                    self.cache[indexPath] = ImageTask(url: url, task: nil, image: image)
                    
                    // delay a bit to simulate a bit slow network
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
                        self.imageDidChange(indexPath)
                    })
                }
                // if image load fails we stick with the default placeholder image
            }
        }
        task.resume()
        
        return placeHolderImage
    }
}

class ViewController: UITableViewController {
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.imageDidChange = { indexPath in
            // either just tell tableview to reload, will trigger cellForRowAt
//            self.tableView.reloadRows(at: [indexPath], with: .fade)
            
            // or find and update the cell
            if let cell = self.tableView.cellForRow(at: indexPath) {
                cell.imageView?.image = self.model.image(at: indexPath)
                cell.textLabel?.text = self.model.title(at: indexPath)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        
        cell.imageView?.image = model.image(at: indexPath)
        cell.textLabel?.text = model.title(at: indexPath)
        
        return cell
    }

}

