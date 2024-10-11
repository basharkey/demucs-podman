#!/usr/bin/env bash
set -e

album_dir=$1
stem_type=$2

if ! ([[ -n "$album_dir" ]] && [[ -d "$album_dir" ]] && [[ "$stem_type" =~ ^(vocals|drums|bass|other)$ ]]); then
    echo "Removes the specified stem from songs in an album"
    echo
    echo "Usage: $0 <album dir> (vocals|drums|bass|other)"
    echo "e.g. $0 ~/Music/artists/Good \\Game/Good\\ Game\\ -\\ Get\\ Good/ vocals"
    echo
    exit 1
fi

artist_name="$(basename "$(dirname "$album_dir")")"
album_name="$(basename "$album_dir")"
stem_dir=~/Music/stems/"$artist_name"/"$album_name"

mkdir -p "$stem_dir"
podman run --rm -it -v "$album_dir":/input -v "$stem_dir":/output demucs:latest \
       "demucs /input/*.@(flac|mp3|m4a) --out /output -d cpu --mp3 --two-stems "$stem_type""

cp -r "$stem_dir"/htdemucs/* "$stem_dir"
rm -r "$stem_dir"/htdemucs

