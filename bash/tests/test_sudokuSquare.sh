#!/bin/bash

. ../sudokuSquare.sh

setUp()
{
	echo "starting tests"
	correctRows[0]=382164975
	correctRows[1]=415927683
	correctRows[2]=967538214
	correctRows[3]=279456831
	correctRows[4]=648371592
	correctRows[5]=531892467
	correctRows[6]=154683729
	correctRows[7]=796215348
	correctRows[8]=823749156
	
	local i=0
	for line in `cat correct-square.txt`; do
	    correctLines[$i]=$line
	    (( i+= 1 ))
	done
}
tearDown()
{
    echo "if the number of tests is 9, I kinda like the symmetry"
	echo "clearing up"
}

echo "Running tests for isValidLine function in sodukoSquare.sh"

testDigitsArray()
{
    echo "test that the digits array is set up correctly"
    assertEquals "element zero should be 1" "1" "${digits[0]}"
    assertEquals "element one should be 2" "2" "${digits[1]}"
    assertEquals "element two should be 3" "3" "${digits[2]}"
    assertEquals "element three should be 4" "4" "${digits[3]}"
    assertEquals "element four should be 5" "5" "${digits[4]}"
    assertEquals "element five should be 6" "6" "${digits[5]}"
    assertEquals "element six should be 7" "7" "${digits[6]}"
    assertEquals "element seven should be 8" "8" "${digits[7]}"
    assertEquals "element eight should be 9" "9" "${digits[8]}"
}

testIsValidLine()
{
	echo "test isValidLine function"
	echo "test that a correct line returns true"
	correctLine="382164975"
	returnValue=$(isValidLine $correctLine)
	assertEquals "correct line should return true" "true" "${returnValue}"
	echo "test that an incorrect line returns false"
	inCorrectLine="382164971"
	returnValue=$(isValidLine $inCorrectLine)
	assertEquals "correct line should return false" "false" "${returnValue}"
}

testContainsValidDigits()
{
    echo "test containsValidDigits function"
    echo "test that a valid line contains only valid digits"
    validDigits="123456789"
    returnValue=$(containsValidDigits $validDigits)
    assertEquals "valid digits should return true" "true" "${returnValue}"
    echo "test that an invalid line (with a zero) does not contain only valid digits"
    validDigits="1234567890"
    returnValue=$(containsValidDigits $validDigits)
    assertEquals "invalid digits should return false" "false" "${returnValue}"
    echo "test that an invalid line (with alpha) does not contain only valid digits"
    validDigits="123456789a"
    returnValue=$(containsValidDigits $validDigits)
    assertEquals "invalid digits should return false" "false" "${returnValue}"
}

testLines()
{
    echo "test lines function"
    echo "test that lines are returned correctly"
    linesFile=random-lines.txt
    returnValue=($(lines $linesFile))
    i=0
    for line in `cat $linesFile`; do
        assertEquals "line contents should be $line" "$line" "${returnValue[$i]}"
        (( i+=1 ))
    done
}

testColumns()
{
    echo "test columns function"
    echo "test that the columns of a square file are returned correctly"
    squareFile=correct-square.txt
    returnValue=($(columns $squareFile))
    columnsFile=correct-columns.txt
    i=0
    for column in `cat $columnsFile`; do
        assertEquals "column $i contents should be $column" "$column" "${returnValue[$i]}"
        (( i+=1 ))
    done
}

testSubSquares()
{
    echo "test subSquares function"
    echo "test that the sub-squares of a square file are returned correctly"
    squareFile=correct-square.txt
    returnValue=($(subSquares $squareFile))
    subsquaresFile=correct-subsquares.txt
    i=0
    for subsquare in `cat $subsquaresFile`; do
        assertEquals "subsquare $i contents should be $subsquare" "$subsquare" "${returnValue[$i]}"
        (( i+=1 ))
    done
}

testCheck()
{
    echo "test check function"
    echo "test that check returns true when we have a valid item"
    returnValue=$(check 123456789)
    assertEquals "check 123456789 is valid" "true" "$returnValue"
    echo "test that check does not return true when we have an invalid item (with alpha)"
    returnValue=$(check 12345678a)
    assertEquals "check 123456789 is valid" "false" "$returnValue"
    echo "test that check does not return true when we have an invalid item (with repeated numerics)"
    returnValue=$(check 123456788)
    assertEquals "check 123456788 is valid" "false" "$returnValue"
}

testCheckSet()
{
    echo "test checkSet function"
    echo "test that less than 9 rows returns false"
    for (( i=0; i<8; i++ )); do
        myRows[$i]=${correctRows[$i]}
    done
    echo "checking with ${#myRows[@]} rows"
    returnValue=$(checkSet ${myRows[@]})
    assertEquals "check only ${#myRows[@]} rows is bad" "false" "$returnValue"
    for (( i=0; i<9; i++ )); do
        myRows[$i]=${correctRows[$i]}
    done
    echo "test that correct (${#myRows[@]})rows returns true"
    echo "checking with ${#myRows} rows"
    returnValue=$(checkSet ${myRows[@]})
    assertEquals "check correct rows is good" "true" "$returnValue"
}

testCheckSquare()
{
    # best to keep this as the last test/last set of tests I think
    echo "and for my last trick, check the checkSquare function!"
    echo "happy path - check a valid square"
    returnValue=$(checkSquare correct-square.txt)
    assertEquals "check that a valid square is valid" "true" "$returnValue"
    echo "check a square with a line missing"
    returnValue=$(checkSquare incorrect-square-missing-line.txt)
    assertEquals "check that a square with a line missing is invalid" "false" "$returnValue"
}
. src/shunit2
