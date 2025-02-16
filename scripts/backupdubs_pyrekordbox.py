#!/usr/bin/env python3

# from pyrekordbox.config import write_db6_key_cache
from pyrekordbox import show_config
from pyrekordbox import Rekordbox6Database

show_config()

db = Rekordbox6Database()

print("Listing tracks ...")

for content in db.get_content():
    print(content.Title)

print("Listing tracks done.")   


print("List Playlist")
playlists = db.get_playlist()
for playlist in playlists:
    print("===========Playlist============")
    print("ID:", playlist.ID)
    print("===============================")
    print("Name::", playlist.Name)
    for song in playlist.Songs:
        # print(song.Content)
        print("\t", song.Content.Title)
    print("=======End of Playlist========")
