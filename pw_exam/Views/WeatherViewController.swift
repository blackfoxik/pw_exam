//
//  WeatherViewController.swift
//  pw_exam
//
//  Created by Антон Лисицын on 02.04.2026.
//

import UIKit
import Combine
import CoreLocation

enum WeatherSection: Hashable, CaseIterable {
    case current
    case hourly
    case daily
    case loading
    case error
}

enum WeatherItem: Hashable {
    case current(CurrentWeatherResponse)
    case hourly(hour: Hour)
    case daily(day: ForecastDay)
    case loading
    case error(String)
}

// MARK: - WeatherViewController

class WeatherViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<WeatherSection, WeatherItem>!
    private let viewModel = WeatherViewModel()
    private let locationService = LocationService()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupCollectionView()
        setupDataSource()
        bindViewModel()
        setupLocation()
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.applySnapshot(for: state)
            }
            .store(in: &cancellables)
    }
    
    private func setupLocation() {
        locationService.locationPublisher
            .sink { [weak self] location in
                Task { await self?.viewModel.loadWeatherForecast(lat: location.coordinate.latitude,
                                                                 lon: location.coordinate.longitude,
                                                                 days: 3) }
            }
            .store(in: &cancellables)
        
        locationService.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                Task {
                    await self?.viewModel.loadWeatherForDefaultLocation()
                }
            }
            .store(in: &cancellables)
        
        locationService.requestLocation()
    }
    
    // MARK: - CollectionView
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        view.addSubview(collectionView)
        
        collectionView.register(CurrentWeatherCell.self)
        collectionView.register(HourlyWeatherCell.self)
        collectionView.register(DailyWeatherCell.self)
        collectionView.register(LoadingCell.self)
        collectionView.register(ErrorCell.self)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch self?.viewModel.state {
            case .loading, .error: return self?.fullScreenSectionLayout()
            default: break
            }
            
            guard let sectionType = WeatherSection.allCases[safe: sectionIndex] else { return nil }
            
            switch sectionType {
            case .current: return self?.currentSectionLayout()
            case .hourly: return self?.hourlySectionLayout()
            case .daily: return self?.dailySectionLayout()
            case .loading, .error: return self?.fullScreenSectionLayout()
            }
        }
    }
    
    private enum LayoutConstants {
        
        enum Current {
            static let height: CGFloat = 200
        }
        
        enum Hourly {
            static let itemWidth: CGFloat = 60
            static let itemHeight: CGFloat = 100
            static let groupWidthFraction: CGFloat = 0.9
            static let verticalInset: CGFloat = 16
        }
        
        enum Daily {
            static let itemHeight: CGFloat = 40
            static let inset: CGFloat = 16
        }
        
        enum FullScreen {
            static let widthFraction: CGFloat = 1.0
            static let heightFraction: CGFloat = 1.0
        }
    }
    
    private func currentSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(LayoutConstants.Current.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    private func hourlySectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(LayoutConstants.Hourly.itemWidth),
            heightDimension: .absolute(LayoutConstants.Hourly.itemHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(LayoutConstants.Hourly.groupWidthFraction),
            heightDimension: .absolute(LayoutConstants.Hourly.itemHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: LayoutConstants.Hourly.verticalInset,
            leading: 0,
            bottom: LayoutConstants.Hourly.verticalInset,
            trailing: 0
        )
        
        return section
    }
    
    private func dailySectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(LayoutConstants.Daily.itemHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: LayoutConstants.Daily.inset,
            leading: LayoutConstants.Daily.inset,
            bottom: LayoutConstants.Daily.inset,
            trailing: LayoutConstants.Daily.inset
        )
        
        return section
    }
    
    private func fullScreenSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(LayoutConstants.FullScreen.widthFraction),
            heightDimension: .fractionalHeight(LayoutConstants.FullScreen.heightFraction)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    // MARK: - Diffable Data Source
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<WeatherSection, WeatherItem>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .current(let model):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.reuseID, for: indexPath) as! CurrentWeatherCell
                cell.configure(with: model)
                return cell
            case .hourly(let hour):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCell.reuseID, for: indexPath) as! HourlyWeatherCell
                cell.configure(with: hour)
                return cell
            case .daily(let day):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCell.reuseID, for: indexPath) as! DailyWeatherCell
                cell.configure(with: day)
                return cell
            case .loading:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseID, for: indexPath) as! LoadingCell
                cell.activityIndicator.startAnimating()
                return cell
            case .error(let error):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCell.reuseID, for: indexPath) as! ErrorCell
                cell.configure(with: error) { [weak self] in
                    Task {
                        await self?.viewModel.loadWeatherForDefaultLocation()
                    }
                    self?.locationService.requestLocation()
                }
                return cell
            }
        }
    }
    
    private func applySnapshot(for state: WeatherViewState) {
        var snapshot = NSDiffableDataSourceSnapshot<WeatherSection, WeatherItem>()
        
        switch state {
        case .loading:
            snapshot.appendSections([.loading])
            snapshot.appendItems([.loading])
            collectionView.setCollectionViewLayout(createLayout(), animated: true)
        case .error(let error):
            snapshot.appendSections([.error])
            snapshot.appendItems([.error(error)])
            collectionView.setCollectionViewLayout(createLayout(), animated: true)
        case .loaded((let current, let forecast)):
            snapshot.appendSections([.current, .hourly, .daily])
            snapshot.appendItems([.current(current)], toSection: .current)
            
            let hour = Calendar.current.component(.hour, from: .now)
            let remainingHours = forecast.forecast.forecastday[0].hour.suffix(from: hour)
            let tomorrowHours = forecast.forecast.forecastday[1].hour
            let hoursItems: [WeatherItem] = remainingHours.map { .hourly(hour: $0) } + tomorrowHours.map { .hourly(hour: $0) }
            snapshot.appendItems(hoursItems, toSection: .hourly)
            
            snapshot.appendItems(forecast.forecast.forecastday.map { .daily(day: $0) }, toSection: .daily)
            
            collectionView.setCollectionViewLayout(createLayout(), animated: true)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


