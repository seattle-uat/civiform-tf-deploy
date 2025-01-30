#! /usr/bin/env bash

# DOC: Test seattle gis servers

pushd "$(git rev-parse --show-toplevel)" > /dev/null

set -e
set +x

function test_url {
    local url="${1}"
    local jq_array_path="${2}"
    local expected_array_size="${3}"
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local NC='\033[0m'

    response="$(curl \
        --silent \
        "${url}")"

    if ! jq --exit-status . >/dev/null 2>&1 <<<"${response}"; then
        printf "${RED}Failed to parse response${NC}\n"
        echo "--------------------------------------------------------------------"
        echo "${response}"
        exit 1
    else
        printf "${GREEN}Valid JSON${NC}\n"
    fi
    
    actual_array_size="$(jq "${jq_array_path} | length" <<<"${response}")"

    if [[ "${expected_array_size}" != "${actual_array_size:0:1}" ]]; then
        printf "${RED}Did not get the expected result count. Expected |${expected_array_size}|. Actual |${actual_array_size}|${NC}\n"
        echo "--------------------------------------------------------------------"
        echo "${response}" | jq
        exit 1
    else
        printf "${GREEN}General array counts match${NC}\n"
    fi
}

echo "Test findAddressCandidates"
findAddressCandidatesUrl="https://gisdata.seattle.gov/cosgis/rest/services/locators/AddressPoints/GeocodeServer/findAddressCandidates?Address=700+5th+Ave&City=Seattle&Region=WA&Postal=98101&f=pjson"
test_url "${findAddressCandidatesUrl}" ".candidates" 3

echo "Test serviceArea"
serviceAreaUrl="https://gisdata.seattle.gov/server/rest/services/COS/Seattle_City_Limits/MapServer/1/query?geometryType=esriGeometryPoint&outFields=*&returnGeometry=false&f=json&inSR=2926&maxLocations=3&geometry={''x'':1271253,''y'':224277,''spatialReference'':2926}"
test_url "${serviceAreaUrl}" ".fields" 8

echo "Test ssl certficate"
echo | openssl s_client -servername gisdata.seattle.gov -connect gisdata.seattle.gov:443

echo ""
