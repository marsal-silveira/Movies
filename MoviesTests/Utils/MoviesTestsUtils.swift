//
//  MoviesTestsUtils.swift
//  MoviesTests
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation

@testable import Movies

enum JSONRepository {
    
    static var error: JSON {
        return ["status_code": 404, "status_message": "Not Found"]
    }
    
    static var movies: [JSON] {
        return [
            ["id": 351286, "title": "Jurassic World: Fallen Kingdom", "poster_path": "/c9XxwwhPHdaImA2f1WEfEsbhaFB.jpg", "backdrop_path": "/gBmrsugfWpiXRh13Vo3j0WW55qD.jpg", "release_date": "2018-06-06", "overview": "A volcanic eruption threatens the remaining dinosaurs on the island of Isla Nublar, where the creatures have freely roamed for several years after the demise of an animal theme park known as Jurassic World. Claire Dearing, the former park manager, has now founded the Dinosaur Protection Group, an organization dedicated to protecting the dinosaurs. To help with her cause, Claire has recruited Owen Grady, a former dinosaur trainer who worked at the park, to prevent the extinction of the dinosaurs once again.", "genre_ids": [28, 12, 878], "vote_average": 0.0],
            ["id": 447332, "title": "A Quiet Place", "poster_path": "/nAU74GmpUk7t5iklEp3bufwDq4n.jpg", "backdrop_path": "/roYyPiQDQKmIKUEhO912693tSja.jpg", "release_date": "2018-04-05", "overview": "A family is forced to live in silence while hiding from creatures that hunt by sound.", "genre_ids": [18, 27, 53, 878, 10751], "vote_average": 7.3],
            ["id": 460019, "title": "Truth or Dare", "poster_path": "/zbvziwnZa91AJD78Si0hUb5JP5X.jpg", "backdrop_path": "/eQ5xu2pQ5Kergubto5PbbUzey28.jpg", "release_date": "2018-04-12", "overview": "A harmless game of “Truth or Dare” among friends turns deadly when someone—or something—begins to punish those who tell a lie—or refuse the dare.", "genre_ids": [53, 27], "vote_average": 5.9],
            ["id": 371608, "title": "The Strangers: Prey at Night", "poster_path": "/vdxLpPsZkPZdFrREp7eSeSzcimj.jpg", "backdrop_path": "/aUtLuEvTI1Z0vItORUYho4UiU6z.jpg", "release_date": "2018-03-07", "overview": "A family's road trip takes a dangerous turn when they arrive at a secluded mobile home park to stay with some relatives and find it mysteriously deserted. Under the cover of darkness, three masked psychopaths pay them a visit to test the family's every limit as they struggle to survive.", "genre_ids": [27, 53], "vote_average": 5.5]
        ]
    }
    
    static var upcomingMovies: JSON {
        return [
            "page": 1,
            "total_pages": 1,
            "total_results": 4,
            "results": JSONRepository.movies
        ]
    }
    
    static var genres: [JSON] {
        return [
            ["id": 28, "name": "Action"],
            ["id": 12, "name": "Adventure"],
            ["id": 16, "name": "Animation"],
            ["id": 35, "name": "Comedy"],
            ["id": 80, "name": "Crime"],
            ["id": 99, "name": "Documentary"],
            ["id": 18, "name": "Drama"],
            ["id": 10751, "name": "Family"],
            ["id": 14, "name": "Fantasy"],
            ["id": 36, "name": "History"],
            ["id": 27, "name": "Horror"],
            ["id": 10402, "name": "Music"],
            ["id": 9648, "name": "Mystery"],
            ["id": 10749, "name": "Romance"],
            ["id": 878, "name": "Science Fiction"],
            ["id": 10770, "name": "TV Movie"],
            ["id": 53, "name": "Thriller"],
            ["id": 10752, "name": "War"],
            ["id": 37, "name": "Western"]
        ]
    }
}
