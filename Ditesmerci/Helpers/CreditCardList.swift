////
////  ListBankCardViewSwiftUI.swift
////  Ditesmerci
////
////  Created by 7k04 on 09/02/2020.
////  Copyright © 2020 mobileappbyharis. All rights reserved.
////
//
//import SwiftUI
//import Firebase
//
//struct CreditCardList: View {
//    var profileViewController: ProfileViewController?
//
//    var body: some View {
//
//        //var items: [CreditCardInfo]
//        NavigationView {
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack {
//                    HeadingProfil()
//                    NavigationLink(destination: AddCreditCard()) {
//                                      Text("Ajouter une carte")
//                                      .foregroundColor(.white)
//                                      .padding(.all, 16)
//                                      .background(Color.init(.blueMerci))
//
//
//                    }
//
//                    List {
//                        Text("Row One")
//                        Text("Row Second")
//                        Text("Row Third")
//                        Text("Row Fourth")
//                        Text("Row Fifth")
//                    }.navigationBarTitle(Text("Cartes Bancaires"))
//                }
//            }
//        }
//    }
//}
//
//
//struct CreditCardList_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(["iPhone 11 Pro"], id: \.self) { deviceName in
//            CreditCardList()
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//        }
//    }
//}
