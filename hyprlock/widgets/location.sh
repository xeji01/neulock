#!/bin/bash

# Default API endpoint
API_URL="http://ip-api.com/json"

# Associative array for country codes
declare -A country_codes=(
    ["AFGHANISTAN"]="AF"
    ["ALBANIA"]="AL"
    ["ALGERIA"]="DZ"
    ["ANDORRA"]="AD"
    ["ANGOLA"]="AO"
    ["ARGENTINA"]="AR"
    ["ARMENIA"]="AM"
    ["AUSTRALIA"]="AU"
    ["AUSTRIA"]="AT"
    ["AZERBAIJAN"]="AZ"
    ["BAHAMAS"]="BS"
    ["BAHRAIN"]="BH"
    ["BANGLADESH"]="BD"
    ["BELGIUM"]="BE"
    ["BELIZE"]="BZ"
    ["BENIN"]="BJ"
    ["BRAZIL"]="BR"
    ["CANADA"]="CA"
    ["CHILE"]="CL"
    ["CHINA"]="CN"
    ["COLOMBIA"]="CO"
    ["COSTA RICA"]="CR"
    ["DENMARK"]="DK"
    ["EGYPT"]="EG"
    ["FINLAND"]="FI"
    ["FRANCE"]="FR"
    ["GERMANY"]="DE"
    ["GHANA"]="GH"
    ["GREECE"]="GR"
    ["HONDURAS"]="HN"
    ["HUNGARY"]="HU"
    ["INDIA"]="IN"
    ["INDONESIA"]="ID"
    ["IRELAND"]="IE"
    ["ISRAEL"]="IL"
    ["ITALY"]="IT"
    ["JAPAN"]="JP"
    ["MEXICO"]="MX"
    ["NIGERIA"]="NG"
    ["NORWAY"]="NO"
    ["PHILIPPINES"]="PH"
    ["RUSSIA"]="RU"
    ["SINGAPORE"]="SG"
    ["SOUTH AFRICA"]="ZA"
    ["SPAIN"]="ES"
    ["SWEDEN"]="SE"
    ["SWITZERLAND"]="CH"
    ["TURKEY"]="TR"
    ["UNITED KINGDOM"]="GB"
    ["UNITED STATES"]="US"
    ["VIETNAM"]="VN"
)

# Function to get city and country based on IP location
get_location() {
    local location_info
    location_info=$(curl -s --fail "$API_URL")

    # Check if curl was successful and returned a valid response
    if [ $? -ne 0 ]; then
        echo "Error retrieving location information. Please check your internet connection or the API service."
        exit 1
    fi

    # Parse the JSON response
    city=$(echo "$location_info" | jq -r '.city // empty')
    country=$(echo "$location_info" | jq -r '.country // empty')

    # Check if city and country were successfully retrieved
    if [ -z "$city" ] || [ -z "$country" ]; then
        echo "Could not determine the city or country from the response."
        echo "Full response: $location_info"
        exit 1
    fi

    # Convert country name to uppercase
    country=${country^^}
  
    # Get the country code from the associative array
    country_code="${country_codes[$country]:-$country}"  # Fallback to the country name if code not found

    # Output the city and country code in uppercase format
    printf "%s, %s\n" "${city^^}" "$country_code"
}

# Main execution
get_location
