#!/bin/bash
#
# @brief   Copy tool to folder destination
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_XCOPY=xcopy
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A XCOPY_USAGE=(
    [TOOL_NAME]="__$UTIL_XCOPY"
    [ARG1]="[XCOPY_STRUCTURE] Tool name, version, path and dev-path"
    [EX-PRE]="# Copy tool to folder destination"
    [EX]="__$UTIL_XCOPY \$XCOPY_STRUCTURE"
)

#
# @brief  Copy tool to folder destination
# @param  Value required, structure XCOPY_STRUCTURE
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A XCOPY_STRUCTURE=()
# XCOPY_STRUCTURE[TN]="new_tool"
# XCOPY_STRUCTURE[TV]="ver.1.0"
# XCOPY_STRUCTURE[AP]="/usr/bin/local/"
# XCOPY_STRUCTURE[DP]="/opt/new_tool/"
#
# __xcopy $XCOPY_STRUCTURE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | check paths
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __xcopy() {
    local XCOPY_STRUCTURE=$1
    local TOOLNAME=${XCOPY_STRUCTURE[TN]}
    local VERSION=${XCOPY_STRUCTURE[TV]}
    local APPPATH=${XCOPY_STRUCTURE[AP]}
    local DEVPATH=${XCOPY_STRUCTURE[DP]}
    if [ -n "$TOOLNAME" ] && [ -n "$VERSION" ] && 
       [ -n "$APPPATH" ] && [ -n "$DEVPATH" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Check dir [$APPPATH/]"
			printf "$DQUE" "$UTIL_XCOPY" "$FUNC" "$MSG"
		fi
        if [ -d "$APPPATH" ]; then
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "%s\n" "[ok]"
			fi
			:
        else 
            mkdir "$APPPATH/"
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "%s\n" "[created]"
			fi
        fi
        local APPVERSION="$APPPATH/$VERSION"
        if [ -d "$DEVPATH" ]; then   
            if [ -d "$APPVERSION/" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
                	MSG="Clean directory [$APPVERSION/]"
					printf "$DQUE" "$UTIL_XCOPY" "$FUNC" "$MSG"
				fi
                rm -rf "$APPVERSION/"
				if [ "$TOOL_DBG" == "true" ]; then
                	printf "%s\n" "[ok]"
				fi
            else 
				if [ "$TOOL_DBG" == "true" ]; then
                	printf "%s\n" "[nothing to clean]"
				fi
				:
            fi
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Copy tool to destination [$APPPATH/]"
				printf "$DSTA" "$UTIL_XCOPY" "$FUNC" "$MSG"
			fi
            cp -R "$DEVPATH/dist/ver.${VERSION}.0/" "$APPPATH/"
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "$DEND" "$UTIL_XCOPY" "$FUNC" "Done"
			fi
            return $SUCCESS
		fi
		MSG="Check directory [$DEVPATH/]"
		printf "$SEND" "$UTIL_XCOPY" "$MSG"
		return $NOT_SUCCESS
    fi
    __usage $XCOPY_USAGE
    return $NOT_SUCCESS
}