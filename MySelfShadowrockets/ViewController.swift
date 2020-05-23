//
//  ViewController.swift
//  MySelfShadowrockets
//
//  Created by chenjun 黄 on 2020/3/31.
//  Copyright © 2020 chenjun 黄. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var playVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heroView: UIView!
    @IBOutlet weak var bookView: UIView!
    @IBOutlet weak var chapterCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // print
        
        scrollView.delegate = self
        chapterCollectionView.dataSource = self
        chapterCollectionView.delegate = self
        
        titleLabel.alpha = 0
        deviceImageView.alpha = 0
        playVisualEffectView.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            self.titleLabel.alpha = 1
            self.deviceImageView.alpha = 1
            self.playVisualEffectView.alpha = 1
        })
    }


    @IBAction func playButtonTapped(_ sender: Any) {
        let urlStr = "https://www.bilibili.com/video/BV1ff4y1m7J3?spm_id_from=333.851.b_7265706f7274466972737432.7"
        let url = URL(string: urlStr)
        
        let player = AVPlayer(url: url!)
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print("zhenjun")
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
        if offsetY < 0 {
            heroView.transform = CGAffineTransform(translationX: 0, y: offsetY)
            
            backgroundImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/5)
            
            playVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
            titleLabel.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
            deviceImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/4)
        }
        
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells as! [SectionCollectionViewCell] {
                let indexPath = collectionView.indexPath(for: cell)!
                let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath)!
                let frame = collectionView.convert(layoutAttributes.frame, to: view)
                let tansformX = frame.origin.x / 5
                cell.cover.transform = CGAffineTransform(translationX: tansformX, y: 0)
                print(frame)
            }
        }
    }
}

// 更新一点其他的技能
extension ViewController: UIScrollViewDelegate {
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionCollectionViewCell
        
        let section = sections[indexPath.row]
        cell.title.text = section["title"]
        cell.caption.text = section["caption"]
        cell.cover.image = UIImage(named: section["image"]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
}
