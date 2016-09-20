
struct Constants {
    struct SpotifyAuth{
        static let ClientID = "a51a09dafb0f42d8a2c293afa7bc2981"
        static let AuthCallback = "musicsafari://"
        static let SessionDefaultKey = "SpotifySession"
    }
    
    static let JSONPathDelimiter = NSCharacterSet(charactersInString: ".")
    static let SpotifyLoggedInPrefKey = "SPOTIFY_LOGGED_IN"
    
    struct APIURL {
        static let AlbumTrackURL = "https://api.spotify.com/v1/albums/%@/tracks"
    }
}
