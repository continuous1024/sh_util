#!/bin/bash
#
# @brief   Test point po point connection
# @version ver.1.0
# @date    Sun Oct 11 02:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ON_CONNECT=on_connect
UTIL_ON_CONNECT_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_ON_CONNECT_VERSION}
UTIL_ON_CONNECT_CFG=${UTIL}/conf/${UTIL_ON_CONNECT}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A ONLINE_CONNECT_USAGE=(
	[USAGE_TOOL]="__${UTIL_ON_CONNECT}"
	[USAGE_ARG1]="[TIME] Sleep time"
	[USAGE_EX_PRE]="# Example running __$TOOL"
	[USAGE_EX]="__${UTIL_ON_CONNECT} 5s"
)

#
# @brief  Test point po point connection
# @param  None
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __on_connect
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# not connected | disconnected
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __on_connect() {
	local INTERVAL=$1
	if [ -n "${INTERVAL}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" PIDNUM="None" STATUS
		declare -A config_on_connect=()
		__load_util_conf "$UTIL_ON_CONNECT_CFG" config_on_connect
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local PROCNAME=${config_on_connect[PROCNAME]} PIDNUM
			MSG="Test point po point connection!"
			__info_debug_message "$MSG" "$FUNC" "$UTIL_ON_CONNECT"
			PIDNUM=$(
				ps ax | grep -v "ps ax" | grep -v grep |
				grep pppd | awk '{ print $1 }'
			)
			if [[ -z "${PIDNUM}" && -n "${PIDNUM}" ]]; then
				MSG="Not connected!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_ON_CONNECT"
				MSG="Force exit!"
				__info_debug_message_end "$MSG" "$FUNC" "$UTIL_ON_CONNECT"
				return $NOT_SUCCESS
			fi
			while [ true ]
			do
				if [ ! -e "/proc/${PIDNUM}/${PROCFILENAME}" ]; then
					MSG="Disconnected!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_ON_CONNECT"
					MSG="Force exit!"
					__info_debug_message_end "$MSG" "$FUNC" "$UTIL_ON_CONNECT"
					return $NOT_SUCCESS
				fi
				netstat -s | grep "Packets received"
				netstat -s | grep "Packets delivered"
				sleep ${INTERVAL}
			done
			__info_debug_message_end "Done" "$FUNC" "$UTIL_ON_CONNECT"
			return $SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_ON_CONNECT"
		return $NOT_SUCCESS
	fi
	__usage ONLINE_CONNECT_USAGE
	return $NOT_SUCCESS
}
