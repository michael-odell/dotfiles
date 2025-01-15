# lister is a simple library that handles command line interaction for simple linear datasets that you'd
# like to slice and dice at the command line.
#
# This isn't a tool you can run -- it's an implementation detail of other tools you might.
#
# To use it, you need to source it...
#   source lister.bash
#
# tell it what fields come out of your data
#
#   lister_fields foo bar_1 baz_extraneous_field
#
#   # optionally set a smaller set of defaults
#   lister_default_fields foo bar_1
#
#
# tell it where to cache the data it retrieves
#
#   lister_cache path/to/filename
#
#
# And implement a lister_fetch method to tell it how to do so which puts data on stdout. Each line should
# contain the full set of fields you provided in lister_fields, with spaces separating the values.
#
#   lister_fetch() {
#      echo "value1 value2 value3"
#      echo "valueA valueB valueC"
#      # A more useful implementation might, say, query this out of a cloud provider command line tool
#      # and use 'jq .query | @sh' to get the data in the right form
#   }
#
#
# Lastly, give lister the command line arguments (you can, of course, optionally pre-process them, but
# right now there's no support for adding arguments to the help text.
#
#    lister "${@}"
#

# LIMITATIONS:
#
#  - field names must use underscores, not hyphens, but both are treated equally in options on the
#    command line
#
#  - both field names and values must be "safe" for bash, which means very little punctuation is allowed,
#    and definitely no spaces
#
#  - I _think_ fields cannot be empty
#
#  - This is sourced into your process, so any state you change could affect this tool.  Try to avoid
#    causing problems by doing things like changing directory.
#
#  - There's no extension path around help text right now.

set -euo pipefail

lister_cache_file() {
    CACHE_FILE=$1
}

lister_fields() {
    FIELDS=( "${@}" )
}

lister_default_fields() {
    DEFAULT_FIELDS=( "${@}" )
}

_is_field() {
    ARG=$1
    for i in "${FIELDS[@]}" ; do
        if [[ ${ARG} == ${i} ]] ; then
            return 0
        fi
    done
    return 1
}

# Print the specified set of variables, with spaces separating the output.
_print_values() {
    local first=1
    for i in "${@}" ; do
        # Print the intervening space, if appropriate
        if [[ $first == 1 ]] ; then
            first=0
        else
            printf " "
        fi

        # Print the value
        printf "%s" "${!i}"
    done
    printf "\n"
}



lister() {

    # Ensure we were called to set things up correctly.
    [[ -n "${CACHE_FILE}" ]]
    [[ ${#FIELDS[@]} -gt 0 ]]

    if [[ ! -v DEFAULT_FIELDS ]] ; then
        DEFAULT_FIELDS=( "${FIELDS[@]}" )
    fi

    SELECTED_FIELDS=()
    QUERY_EQ=()
    QUERY_NE=()
    QUERY_RE=()
    QUERY_NRE=()
    HEADERS=""
    DID_SELECT_A_FIELD=0
    while [[ $# -gt 0 ]] ; do
        ARG=$1

        case $1 in
            --fetch)
                lister_fetch
                ;;

            --headers)
                HEADERS=1
                ;;

            --no-headers)
                HEADERS=0
                ;;

            # Select one of the field names available, optionally with hyphens instead of underscores
            --*)
                # Remove the leading hyphens and convert any other hyphens to underscores
                OPT=${1#--}
                OPT=${OPT//-/_}

                if _is_field "$OPT" ; then
                    SELECTED_FIELDS+=("$OPT")
                    DID_SELECT_A_FIELD=1
                else
                    echo "Invalid option $1.  Possible field names are ${FIELDS[*]}" >&2
                    exit 2
                fi
                ;;

            -*)
                echo "Short options are not yet supported." >&2
                exit 3
                ;;

            *!=*)
                if _is_field ${1%%!=*} ; then
                    QUERY_NE+=( $1 )
                else
                    echo "Invalid field ${1%%~=*}. Possible field names are ${FIELDS[@]}" >&2
                    exit 2
                fi
                ;;

            *!~*)
                if _is_field ${1%%!~*} ; then
                    QUERY_NRE+=( $1 )
                else
                    echo "Invalid field ${1%%!~*}. Possible field names are ${FIELDS[@]}" >&2
                    exit 2
                fi
                ;;

            *~*)
                if _is_field ${1%%~*} ; then
                    QUERY_RE+=( $1 )
                else
                    echo "Invalid field ${1%%~*}. Possible field names are ${FIELDS[@]}" >&2
                    exit 2
                fi
                ;;

            *=*)
                if _is_field ${1%%=*} ; then
                    QUERY_EQ+=( $1 )
                else
                    echo "Invalid field ${1%%=*}. Possible field names are ${FIELDS[@]}" >&2
                    exit 2
                fi
                ;;

            *)
                QUERY_EQ+=( name=$1 )
                ;;
        esac
        shift
    done

    # If no fields are selected, output all of them
    if [[ ${#SELECTED_FIELDS[@]} -eq 0 ]] ; then
        SELECTED_FIELDS=( ${DEFAULT_FIELDS[@]} )
    fi

    # Set a HEADERS value if one wasn't specified.  The default is to have headers unless some set of
    # fields were specified, in which case the caller can see the order from their command line
    if [[ -z $HEADERS ]] ; then

        if [[ ${DID_SELECT_A_FIELD} == 1 ]] ; then
            HEADERS=0
        else
            HEADERS=1
        fi
    fi


    if [[ ! -r "${CACHE_FILE}" ]] ; then
        lister_fetch
    fi

    FIRST_TIME=1
    while read "${FIELDS[@]}" ; do
        if [[ $FIRST_TIME -eq 1 && $HEADERS -eq 1 ]] ; then
            echo "${SELECTED_FIELDS[@]}" | tr '[:lower:]' '[:upper:]'
            FIRST_TIME=0
        fi


        # Print all if there's no query
        if [[ ${#QUERY_EQ[@]} -eq 0 && ${#QUERY_RE[@]} -eq 0 && ${#QUERY_NRE[@]} -eq 0 && ${#QUERY_NE[@]} -eq 0 ]] ; then
            _print_values "${SELECTED_FIELDS[@]}"

        else

            NOMATCH=0

            # NOTE: Work around bash bug with arrays and set -u in bash 4.2.  See also https://stackoverflow.com/a/61551944
            for query in ${QUERY_EQ[@]+"${QUERY_EQ[@]}"} ; do
                QUERY_FIELD=${query%%=*}
                QUERY_VALUE=${query##*=}
                if [[ ${!QUERY_FIELD} != ${QUERY_VALUE} ]] ; then
                    NOMATCH=1
                    break
                fi
            done

            for query in ${QUERY_NE[@]+"${QUERY_NE[@]}"} ; do
                QUERY_FIELD=${query%%!=*}
                QUERY_VALUE=${query##*!=}
                if [[ ${!QUERY_FIELD} == ${QUERY_VALUE} ]] ; then
                    NOMATCH=1
                    break
                fi
            done

            for query in ${QUERY_RE[@]+"${QUERY_RE[@]}"} ; do
                QUERY_FIELD=${query%%~*}
                QUERY_PATTERN=${query##*~}
                if ! [[ ${!QUERY_FIELD} =~ ${QUERY_PATTERN} ]] ; then
                    NOMATCH=1
                    break
                fi
            done

            for query in ${QUERY_NRE[@]+"${QUERY_NRE[@]}"} ; do
                QUERY_FIELD=${query%%!~*}
                QUERY_PATTERN=${query##*!~}
                if [[ ${!QUERY_FIELD} =~ ${QUERY_PATTERN} ]] ; then
                    NOMATCH=1
                    break
                fi
            done

            if [[ ${NOMATCH} == 0 ]] ; then
                _print_values "${SELECTED_FIELDS[@]}"
            fi

        fi
    done < "${CACHE_FILE}" | column -t
}
