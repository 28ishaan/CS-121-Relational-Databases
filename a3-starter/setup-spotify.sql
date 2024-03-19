-- [Problem 1]
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS playlists;

-- Table artists: provides information about the artist.
CREATE TABLE artists (
    -- artist_uri (exactly 22 chars).
    artist_uri CHAR(22) NOT NULL,
    -- artist_name (250 char limit).
    artist_name VARCHAR(250) NOT NULL,
    PRIMARY KEY (artist_uri)
);

-- Table albums: provides information about the album.
CREATE TABLE albums (
    -- artist_uri (exactly 22 chars).
    album_uri CHAR(22) NOT NULL,
    -- album_name (250 char limit).
    album_name VARCHAR(250) NOT NULL,
    -- release_date (date/time format).
    release_date DATE NOT NULL,
    PRIMARY KEY (album_uri)
);

-- Table playlists: provides information about the playlist.
CREATE TABLE playlists (
    -- playlist_uri (exactly 22 chars).
    playlist_uri CHAR(22) NOT NULL,
    -- playlist_name (250 char limit).
    playlist_name VARCHAR(250) NOT NULL,
    PRIMARY KEY (playlist_uri)
);

-- Table tracks: provides information about the track.
CREATE TABLE tracks (
    -- track_uri (exactly 22 chars).
    track_uri CHAR(22) NOT NULL,
    -- playlist_uri (exactly 22 chars).
    playlist_uri CHAR(22) NOT NULL,
    -- track_name (250 char limit).
    track_name VARCHAR(250) NOT NULL,
    -- artist_uri (exactly 22 chars).
    artist_uri CHAR(22) NOT NULL,
    -- album_uri (exactly 22 chars).
    album_uri CHAR(22) NOT NULL,
    -- duration_ms (integer).
    duration_ms INT NOT NULL,
    -- preview_url (250 char limit).
    preview_url VARCHAR(250) NULL,
    -- popularity (integer).
    popularity INT NOT NULL,
    -- added_at (date/time format).
    added_at TIMESTAMP NOT NULL,
    -- added_by (250 char limit).
    added_by VARCHAR(250) NULL,
    PRIMARY KEY (track_uri, playlist_uri),
    FOREIGN KEY (artist_uri)
        REFERENCES artists(artist_uri)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    FOREIGN KEY (album_uri)
        REFERENCES albums(album_uri)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    FOREIGN KEY (playlist_uri)
        REFERENCES playlists(playlist_uri)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);
