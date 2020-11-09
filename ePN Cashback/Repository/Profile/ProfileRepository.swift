//
//  ProfileRepository.swift
//  Backit
//
//  Created by Ivan Nikitin on 10/03/2020.
//  Copyright © 2020 Ivan Nikitin. All rights reserved.
//

import Foundation

class ProfileRepository: RepositoryProtocol {
    
    let networkManager: ProfileNetworkManager
    static let shared = ProfileRepository()
    
    private init() {
        networkManager = ProfileNetworkManager()
    }
    
    func loadProfile(completion: @escaping (Result<ProfileResponse,Error>)->()) {
        ProfileApiClient.profile { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func saveProfile(_ profile: Profile, completion: @escaping (Result<ChangeProfileResponse, Error>)->()) {
        ProfileApiClient.editProfile(fullName: profile.fullName, birthday: profile.birthday, gender: profile.gender, language: profile.language, profileImage: profile.profileImage, onBoardWatched: nil) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func sendAvatar(file: SupportMessageFile, changeProgress: @escaping (Double)->() , completion: @escaping (Result<String, Error>)->()) {
        CdnApiClient.uploadFile(data: file.file, type: "image", name: file.fileName, visibility: "public", changeProgress: { (progress) in
            changeProgress(progress)
        }) { (result) in
            switch result {
            case .success(let response):
                if response.data.count <= 0 {
                    completion(.failure(NSError(domain: "", code: 500029, userInfo: nil)))
                    return
                }
                let fileLink = response.data[0].attributes?.url ?? ""
                ProfileApiClient.saveAvatar(imageUrlString: fileLink) { (result) in
                    switch result {
                    case .success(let avatarResponse):
                        completion(.success(avatarResponse.data.attributes.link))
                        break
                    case .failure(let error):
                        completion(.failure(error))
                        break
                    }
                }
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func updateLocation(countryCode: String, regionCode: String?, cityID: Int? , completion: @escaping (Result<Bool, Error>) -> Void) {
        networkManager.updateGeo(countryCode: countryCode, regionCode: regionCode, cityId: cityID, completion: completion)
    }
    
    func deleteAvatar(completion: @escaping (Result<CommonProfileResponse,Error>)->()) {
        ProfileApiClient.deleteAvatar { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func deleteProfile(secretCode: String, completion: @escaping (NSError?)->()) {
        networkManager.deleteProfile(secretValue: secretCode) { (result) in
            switch result {
            case .success(let deleted):
                print("Profile: The profile has been deleted - \(deleted)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    func getCountries(completion: @escaping (Result<[CountryData], Error>) -> Void) {
        ProfileApiClient.getCountries(completion: { result in
            switch result {
            case .success(let response):
                let data = response.data
                
                var countryDataList: [CountryData] = []
                var priorityCountryList: [CountryData] = []
                
                for elem in data {
                    if let name = elem.attributes?.name, let countryCode = elem.attributes?.countryCode {
                        let countryData = CountryData(countryCode: countryCode, title: name)
                        
                        if countryCode == "RU" || countryCode == "UA" {
                            priorityCountryList.append(countryData)
                        } else {
                            countryDataList.append(countryData)
                        }
                    }
                }
                
                let resultList = priorityCountryList + countryDataList
                
                completion(.success(resultList))
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func getRegions(countryCode: String, completion: @escaping (Result<[RegionData], Error>) -> Void) {
        ProfileApiClient.getRegions(countryCode: countryCode, completion: { result in
            switch result {
            case .success(let response):
                let data = response.data ?? []
            
                var regionDataList: [RegionData] = []
                
                for element in data {
                    let regionData = RegionData(regionCode: element.attributes.code, title: element.attributes.name)
                    
                    regionDataList.append(regionData)
                }
                
                completion(.success(regionDataList))
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func getCities(countryCode: String, regionCode: String?, completion: @escaping (Result<[CityData], Error>) -> Void) {
        ProfileApiClient.getCities(countryCode: countryCode, regionCode: regionCode, completion: { result in
            switch result {
            case .success(let response):
                let data = response.data ?? []
                
                var cityDataList: [CityData] = []
                
                for element in data {
                    let cityData = CityData(cityID: element.id, title: element.attributes.name)
                    
                    cityDataList.append(cityData)
                }
                
                completion(.success(cityDataList))
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
