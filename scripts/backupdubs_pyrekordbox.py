#!/usr/bin/env python3

# from pyrekordbox.config import write_db6_key_cache
from pyrekordbox import show_config
from pyrekordbox import Rekordbox6Database
import os
import shutil
import argparse

# Parse destination of export
parser = argparse.ArgumentParser(description="Copy playlist songs to destination folder")
parser.add_argument("destination", help="Destination path where playlist folders will be created")
args = parser.parse_args()

if args.destination == "" :
  print("please provide a destination folder")
  exit(1)

show_config()

db = Rekordbox6Database()

print("Listing tracks ...")

# DEBUG: list content title
# for content in db.get_content():
#    print(content.Title)

print("Listing tracks done.")   

print("List Playlist")
playlists = db.get_playlist()
for playlist in playlists:
    # Create playlist folder
    playlist_folder = os.path.join(args.destination, playlist.Name)
    os.makedirs(playlist_folder, exist_ok=True)

    print("===========Playlist============")
    print("ID:", playlist.ID)
    print("===============================")
    print("Name::", playlist.Name)
    for song in playlist.Songs:
        # print(song.Content)
        key = None
        keyObject = db.get_key(ID=song.Content.KeyID)
        if keyObject is None:
          print("No matching record found for:", song.Content.KeyID)
        else:
         key = keyObject.ScaleName
        print("\t", song.Content.Title, "\t", song.Content.BPM, key, song.Content.FolderPath)
        if os.path.exists(song.Content.FolderPath):
          shutil.copy(song.Content.FolderPath, playlist_folder)
        else:
          print(f"File not found: {song.Content.FolderPath}")
    print("=======End of Playlist========")

