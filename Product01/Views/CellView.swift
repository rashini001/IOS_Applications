//
//  ColorCellView.swift
//  Product01
//
//  Created by COBSCCOMP24.2P-056 on 2026-01-17.
//

import SwiftUI

struct ColorCellView: View {
    var colorModel: ColorModel

    var body: some View {
        Rectangle()
            .fill(colorModel.isMatched || colorModel.isSelected ? colorModel.color : Color.gray)
            .frame(width: 50, height: 50)
            .border(Color.black)
            .animation(.default, value: colorModel.isMatched)
    }
}
