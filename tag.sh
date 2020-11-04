
#!/bin/sh

function err { echo "Usage:
	tag [OPTIONS] file
Options:
	-a: artist/author
	-t: song/chapter title
	-A: album/book title
	-n: track/chapter number
	-y: year of publication
	-g: genre
	-c: clear cover
You will be prompted for title, artist, album and track if not given." && exit 1 ;
}

function printtag {
	echo "title=$title"
	echo "artist=$artist"
	echo "album=$album"
	echo "track=$track"
	echo "genre=$genre"
	echo "year=$year"
}

while getopts "a:t:A:n:y:g:f:c" o; do
	case "${o}" in
		a) artist="${OPTARG}" ;;
		t) title="${OPTARG}" ;;
		A) album="${OPTARG}" ;;
		n) track="${OPTARG}" ;;
		y) year="${OPTARG}" ;;
		g) genre="${OPTARG}" ;;
		f) file="${OPTARG}" ;;
		c) clear=1 ;;
		*) printf "Invalid option: -%s\\n" "$OPTARG" && err ;;
	esac
done

shift $((OPTIND - 1))

file="$1"
[ ! -f "$file" ] && echo "Provide file to tag." && err

[ -z "$title" ] && echo "Enter a title." && read -r title
[ -z "$artist" ] && echo "Enter an artist." && read -r artist
[ -z "$album" ] && echo "Enter an album." && read -r album
[ -z "$year" ] && echo "Enter album year of publication." && read -r year
[ -z "$track" ] && echo "Enter a track number." && read -r track
[ -z "$genre" ] && echo "Enter genre." && read -r genre

temp="${file%.*}.temp.${file##*.}"

[ ${clear+x} ] && ffmpeg -i "$file" -map 0:a -codec:a copy -map_metadata -1 "$temp" && mv -f "$temp" "$file"

ffmpeg -i "$file" -map 0 -y		\
	-codec copy -write_id3v2 1	\
	-metadata "title=$title" 		\
	-metadata "artist=$artist"	\
	-metadata "album=$album"		\
	-metadata "track=$track"		\
	-metadata "genre=$genre"		\
	-metadata "year=$year"			\
	"$temp"											\
	&& mv -f "$temp" "$file"

exit 0
