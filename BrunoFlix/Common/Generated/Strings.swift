// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum Localization {
  /// Add
  internal static let btnAdd = Localization.tr("Localizable", "BTN_ADD")
  /// Cancel
  internal static let btnCancel = Localization.tr("Localizable", "BTN_CANCEL")
  /// click to select movie cover
  internal static let btnImgCover = Localization.tr("Localizable", "BTN_IMG_COVER")
  /// Remove
  internal static let btnRemove = Localization.tr("Localizable", "BTN_REMOVE")
  /// Nova categoria
  internal static let btnSaveMovie = Localization.tr("Localizable", "BTN_SAVE_MOVIE")
  /// Trailer
  internal static let btnTrailer = Localization.tr("Localizable", "BTN_TRAILER")
  /// Detail Movie
  internal static let detailMovieTitle = Localization.tr("Localizable", "DETAIL_MOVIE_TITLE")
  /// Edit Movie
  internal static let editMovieTitle = Localization.tr("Localizable", "EDIT_MOVIE_TITLE")
  /// There is no genres, please add a new genre
  internal static let emptyTableGenres = Localization.tr("Localizable", "EMPTY_TABLE_GENRES")
  /// There is no movies, please add a new movie
  internal static let emptyTableMovies = Localization.tr("Localizable", "EMPTY_TABLE_MOVIES")
  /// Genres
  internal static let genresTitle = Localization.tr("Localizable", "GENRES_TITLE")
  /// Auto Play Trailer
  internal static let lblAutoPlay = Localization.tr("Localizable", "LBL_AUTO_PLAY")
  /// Black
  internal static let lblBlack = Localization.tr("Localizable", "LBL_BLACK")
  /// Blue
  internal static let lblBlue = Localization.tr("Localizable", "LBL_BLUE")
  /// Camera
  internal static let lblCamera = Localization.tr("Localizable", "LBL_CAMERA")
  /// Choose where to retrieve your photo
  internal static let lblChoseImage = Localization.tr("Localizable", "LBL_CHOSE_IMAGE")
  /// Green
  internal static let lblGreen = Localization.tr("Localizable", "LBL_GREEN")
  /// Movie Cover
  internal static let lblMovieCover = Localization.tr("Localizable", "LBL_MOVIE_COVER")
  /// Photo Library
  internal static let lblPhotoLibrary = Localization.tr("Localizable", "LBL_PHOTO_LIBRARY")
  /// Pink
  internal static let lblPink = Localization.tr("Localizable", "LBL_PINK")
  /// System Color
  internal static let lblSystemColor = Localization.tr("Localizable", "LBL_SYSTEM_COLOR")
  /// Movies
  internal static let moviesTitle = Localization.tr("Localizable", "MOVIES_TITLE")
  /// It's time to watch your movie!!!
  internal static let msgScheduleMovie = Localization.tr("Localizable", "MSG_SCHEDULE_MOVIE")
  /// New Movie
  internal static let newMovieTitle = Localization.tr("Localizable", "NEW_MOVIE_TITLE")
  /// Genres
  internal static let placeholderGenre = Localization.tr("Localizable", "PLACEHOLDER_GENRE")
  /// Genre Name
  internal static let placeholderGenreName = Localization.tr("Localizable", "PLACEHOLDER_GENRE_NAME")
  /// Movie Title
  internal static let placeholderMovieTitle = Localization.tr("Localizable", "PLACEHOLDER_MOVIE_TITLE")
  /// Release Date
  internal static let placeholderReleaseDate = Localization.tr("Localizable", "PLACEHOLDER_RELEASE_DATE")
  /// Settings
  internal static let settingsTitle = Localization.tr("Localizable", "SETTINGS_TITLE")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
