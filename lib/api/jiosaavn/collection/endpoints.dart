const endpoints = (
  modules: 'webapi.getLaunchData',
  search: (
    all: 'autocomplete.get',
    topSearch: 'content.getTopSearches',
    songs: 'search.getResults',
    albums: 'search.getAlbumResults',
    artists: 'search.getArtistResults',
    playlists: 'search.getPlaylistResults',
  ),
  songs: (
    id: 'song.getDetails',
    link: 'webapi.get',
    reco: 'reco.getreco',
    artistOtherTopSongs: 'search.artistOtherTopSongs',
    trending: 'content.getTrending'
  ),
  albums: (
    id: 'content.getAlbumDetails',
    reco: 'reco.getAlbumReco',
    trendingAlbum: 'content.getTrending',
    topAlbumsoftheYear: 'search.topAlbumsoftheYear'
  ),
  playlists: (
    id: 'playlist.getDetails',
    reco: 'reco.getPlaylistReco',
    trending: 'content.getTrending'
  ),
  artists: (
    id: 'artist.getArtistPageDetails',
    songs: 'artist.getArtistMoreSong',
    albums: 'artist.getArtistMoreAlbum',
    topSongs: 'search.artistOtherTopSongs',
  ),
  lyrics: 'lyrics.getLyrics',
  module: (
    link: 'webapi.getLaunchData',
    charts: "content.getCharts",
    artistRecos: 'social.getTopArtists',
    newAlbums: 'content.getAlbums',
    newTranding: "content.getTrending",
    radio: 'webradio.getFeaturedStations',
    topPlaylist: 'content.getFeaturedPlaylists',
    tagMixes: 'content.getTagMixes'
  ),
);
