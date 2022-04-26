//
//  PaletteTableViewCell.swift
//  Palette
//
//  Created by Tasuku Yamamoto on 4/25/22.
//  Copyright © 2022 Cameron Stuart. All rights reserved.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {

    //MARK: - Properties
    var photo: UnsplashPhoto? {
        didSet{
            updateViews()
        }
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        addAllSubviews()
        constrainImageView()
        constrainTitleLabel()
        constrainColorPaletteView()
    }
    
    
    //MARK: - Helper Methods
    func updateViews(){
        guard let photo = photo else { return }
        fetchAndSetImage(for: photo)
        fetchAndSetcolorStack(for: photo)
        
        paletteTitleLabel.text = photo.description ?? "No description."
    }
    
    func fetchAndSetImage(for unsplashPhoto: UnsplashPhoto){
        UnsplashService.shared.fetchImage(for: unsplashPhoto) { image in
            DispatchQueue.main.async {
                self.paletteImageView.image = image
            }
        }
    }
    
    func fetchAndSetcolorStack(for unsplashPhoto: UnsplashPhoto){
        ImaggaService.shared.fetchColorsFor(imagePath: unsplashPhoto.urls.regular) { colors in
            DispatchQueue.main.async {
                guard let colors = colors else { return }
                self.colorPaletteView.colors = colors
            }
        }
    }
    
    func addAllSubviews(){
        self.addSubview(paletteImageView)
        self.addSubview(paletteTitleLabel)
        self.addSubview(colorPaletteView)
    }
    
    func constrainImageView(){
        let imageViewWidth = self.contentView.frame.width - (2 * SpacingConstants.outerHorizontalPadding)
        paletteImageView.anchor(top: self.contentView.topAnchor, bottom: nil, leading: self.contentView.leadingAnchor, trailing: self.contentView.trailingAnchor, paddingTop: SpacingConstants.outerVerticalPadding, paddingBottom: 0, paddingLeft: SpacingConstants.outerHorizontalPadding, paddingRight: SpacingConstants.outerHorizontalPadding, width: imageViewWidth, height: imageViewWidth)
    }
    
    func constrainTitleLabel(){
        paletteTitleLabel.anchor(top: paletteImageView.bottomAnchor, bottom: nil, leading: self.contentView.leadingAnchor, trailing: self.contentView.trailingAnchor, paddingTop: SpacingConstants.verticalObjectBuffer, paddingBottom: 0, paddingLeft: SpacingConstants.outerHorizontalPadding, paddingRight: SpacingConstants.outerHorizontalPadding, width: nil, height: SpacingConstants.smallElementHeight)
    }
    
    func constrainColorPaletteView(){
        colorPaletteView.anchor(top: paletteTitleLabel.bottomAnchor, bottom: self.contentView.bottomAnchor, leading: self.contentView.leadingAnchor, trailing: self.contentView.trailingAnchor, paddingTop: SpacingConstants.verticalObjectBuffer, paddingBottom: SpacingConstants.outerVerticalPadding, paddingLeft: SpacingConstants.outerHorizontalPadding, paddingRight: SpacingConstants.outerHorizontalPadding, width: nil, height: SpacingConstants.mediumElementHeight)
    }
    
    //MARK: - Views
    let paletteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let paletteTitleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let colorPaletteView: ColorPaletteView = {
        let paletteView = ColorPaletteView()
        
        return paletteView
    }()
    
}//End of class
