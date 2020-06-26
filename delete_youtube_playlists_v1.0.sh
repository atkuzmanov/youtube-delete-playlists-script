#!/bin/bash

## Uncomment line below if you want it to clear the screen each time the script runs.
# clear

usage="Please run the script with the required parameters as follows: ./delete_youtube_playlists_[VERSION].sh --file [FILE-LOCATION] --api_key [API-KEY] --authorization [AUTHORIZATION_TOKEN]"

while [ -n "$1" ]; do
	case "$1" in

	-f | --file )			shift
							filename="$1"
							;;
	-ak | --api_key )		shift
							api_key="$1"
							;;
	-au | --authorization )	shift
							authorization="$1"
							;;
	-h | --help)			echo ${usage}
							exit 1
							;;
	--)
		shift ## The double dash makes everything passed after it a parameter
		break
		;;

	*) echo ${usage} ;;

	esac
	shift
done

echo ">. Running delete_youtube_playlists_1.sh script..."

## Parsing the ids of the YouTube playlists which are to be deleted and storing them in a variable.
## Parsing using jq with -r specified for "raw" output to avoid quotes around the ids.
youtube_playlist_ids=$( cat ${filename} | jq -r '.items[].id' )

for id in ${youtube_playlist_ids}
do
	CURL1=$(curl \
		'https://content.googleapis.com/youtube/v3/playlists?id='"${id}"'&key='"${api_key}"'' \
		-X DELETE \
		-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:77.0) Gecko/20100101 Firefox/77.0' \
		-H 'Accept: */*' \
		-H 'Accept-Language: en-GB,en;q=0.5' --compressed \
		-H 'X-ClientDetails: appVersion=5.0%20(Macintosh)&platform=MacIntel&userAgent=Mozilla%2F5.0%20(Macintosh%3B%20Intel%20Mac%20OS%20X%2010.14%3B%20rv%3A77.0)%20Gecko%2F20100101%20Firefox%2F77.0' \
		-H 'Authorization: '"${authorization}"'' \
		-H 'X-Requested-With: XMLHttpRequest' \
		-H 'X-JavaScript-User-Agent: apix/3.0.0 google-api-javascript-client/1.1.0' \
		-H 'X-Origin: https://explorer.apis.google.com' \
		-H 'X-Referer: https://explorer.apis.google.com' \
		-H 'X-Goog-Encode-Response-If-Executable: base64' \
		-H 'Origin: https://content.googleapis.com' \
		-H 'Connection: keep-alive' \
		-H 'Referer: https://content.googleapis.com/static/proxy.html?usegapi=1&jsh=m%3B%2F_%2Fscs%2Fapps-static%2F_%2Fjs%2Fk%3Doz.gapi.en_GB.iWyQuFdbWzA.O%2Fam%3DwQc%2Fd%3D1%2Fct%3Dzgms%2Frs%3DAGLTcCOyhlEmBby7qWoiftyYszJcOof1oQ%2Fm%3D__features__'
		)

	echo $CURL1

	sleep 1
done

echo "Done."



