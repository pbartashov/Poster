//
//  MockPosts.swift
//  PosterKit
//
//  Created by Павел Барташов on 19.06.2022.
//

import UIKit
import PosterKit

extension Post {
    public static var demoPosts: [Post] {
        [Post(uid: "1",
              authorId: demoUsers[0].uid,
              content: "Сублимация попыток объяснить друзьям чем отличаются классы от протоколов и почему без организации целого концерта здесь никак не обойтись.",
              //                     imageData: UIImage(named: "postImage-1")?.pngData(),
              likes: 10,
              views: 15),

         Post(uid: "2",
              authorId: demoUsers[1].uid,
              content: "Если вы нашли и читаете данную статью, значит пришли к пониманию необходимости тестов в вашем приложении, а это залог качества написанного вами кода и забота о клиентах. И всё же, зачем нужны тесты? Опишу самые, на мой взгляд, важные причины.",
              //              imageData: UIImage(named: "postImage-2")?.pngData(),
              likes: 167,
              views: 789),

         Post(uid: "3",
              authorId: demoUsers[0].uid,
              content: "Жизненный цикл UIViewController",
              //              imageData: UIImage(named: "postImage-3")?.pngData(),
              likes: 560,
              views: 861),

         Post(uid: "4",
              authorId: demoUsers[0].uid,
              content: "Нормализация сна и суточных ритмов – востребованная нынче тема. Согласитесь, удобно иметь на смартфоне приложение, способное за пару свайпов обеспечить здоровый сон, исправить суточные ритмы после перелёта или купировать эффекты, связанные с утомлением-переработкой-стрессом. Спрос рождает предложение – и вот уже YouTube ломится от разного рода «музык для релаксации», «сеансов гипноза» и «исцеления во время сна 432 Гц». А Google Play и App Store, соответственно, от генераторов белого шума, плееров с треками для засыпания, смарт-будильников, интеллектуальных светильников, сервисов для подсчёта медленноволнового сна и прочего биохакерского мусора. Есть ли в подобных приложениях рациональное зерно? Да. безусловно. Но мы не станем перелопачивать народное творчество в поисках жемчужных зёрен, а начнём с правильной постановки задачи и определения технического облика акустического стимулятора на основе имеющихся гипотез. Ведь правильно поставленный вопрос содержит в себе половину ответа, не так ли?",
              //              imageData: UIImage(named: "postImage-4")?.pngData(),
              likes: 1105,
              views: 8946)
        ]
    }

    public static var demoPostsImages: [UIImage?] {
        [UIImage(named: "postImage-1"),
         UIImage(named: "postImage-2"),
         UIImage(named: "postImage-3"),
         UIImage(named: "postImage-4")
        ]
    }

    public static var demoUsers: [User] {
        [User(uid: "tkavg7wj7CT1NBTeflpQ2mK3gqf1", lastName: "HeadHunter", avatarData: UIImage(systemName: "camera.macro")?.pngData()),
         User(uid: "WC0SErbmlSfY3rH1ZM0SUNdbjjl1", lastName: "swiftuinotes", avatarData: UIImage(systemName: "key.viewfinder")?.pngData()),
         User(uid: "tkavg7wj7CT1NBTeflpQ2mK3gqf1", lastName: "HeadHunter", avatarData: UIImage(systemName: "camera.macro")?.pngData()),
         User(uid: "WC0SErbmlSfY3rH1ZM0SUNdbjjl1", lastName: "swiftuinotes", avatarData: UIImage(systemName: "key.viewfinder")?.pngData())
        ]
    }

    public static func storeMock() {
        fatalError("Uncomment")
//        let postCloudStorage = PostCloudStorage()
//        let imageCloudStorage = ImageCloudStorage(root: Constants.Cloud.postImagesStorage)
//        let storage = CloudStorageWriter(postCloudStorage: postCloudStorage, imageCloudStorage: imageCloudStorage)
//
//        Task {
//            for (i, (post, image)) in zip(demoPosts, demoPostsImages).enumerated() {
//                do {
//                    let newPost = try await storage.createPost(authorId: demoUsers[i].uid, content: post.content, imageData: image?.pngData())
//                    //                    if let data = image?.pngData() {
//                    //                        try await imageStorage.store(imageData: data, forId: newPost.uid)
//                    //                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
    }
}
