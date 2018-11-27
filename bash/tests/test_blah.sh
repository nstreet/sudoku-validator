#!/bin/bash

. ../hsm_tunnel_utils.sh

setUp()
{
	echo "starting tests"
}
tearDown()
{
	echo "clearing up"
}

echo "Running tests for sgetUser function in hsm_tunnel_utils.sh"

testGetUser()
{
	echo "test that the getUser function returns the current user id"
	me=$(id -un)
	returnValue=$(getUser)
	assertEquals "user should be ${me}" "${me}" "${returnValue}"
}

. src/shunit2
