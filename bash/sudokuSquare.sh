#!/bin/bash
# validate soduko square

declare -a digits
digits=(1 2 3 4 5 6 7 8 9)

isValidLine()
{
    local line=$1
    local myFoundDigits=(false false false false false false false false false)
    for (( i=0; i<${#line}; i++ )); do
        found=${line:$i:1}
        (( found-=1 ))
        myFoundDigits[$found]=true
    done
    allFound=true
    for i in "${myFoundDigits[@]}"; do
        if [ "$i" != "true" ]; then
            allFound=false
        fi
    done
    echo $allFound
}

containsValidDigits()
{
    local line=$1
    isValidDigits=true
    for (( i=0; i<${#line}; i++ )); do
        digit=${line:$i:1}
        validDigit=false
        for d in "${digits[@]}"; do
            if [ "$d" == "$digit" ]; then
                validDigit=true
                break
            fi
        done
        if [ "$validDigit" != "true" ]; then
            isValidDigits=false
            break
        fi
    done
    echo $isValidDigits
}

lines()
{
    # return the lines of a square file as an array
    linesFile=$1
    local returnLines
    local i=0
    for line in `cat $linesFile`; do
        returnLines[$i]=$line
        (( i+=1 ))
    done
    echo ${returnLines[@]}
}

columns()
{
    local squareFile=$1
    local returnColumns
    for line in `cat $squareFile`; do
        for (( i=0; i<${#line}; i++ )); do
            returnColumns[$i]=${returnColumns[$i]}${line:$i:1}
        done
    done
    echo ${returnColumns[@]}
}

subSquares()
{
    local squareFile=$1
    # returning 9 lines representing the subsquares
    local returnSubSquares
    local lines
    # line count
    l=0
    for line in `cat $squareFile`; do
        lines[$l]=$line
        (( l+=1 ))
    done
    returnSubSquares[0]=${lines[0]:0:3}${lines[1]:0:3}${lines[2]:0:3}
    returnSubSquares[1]=${lines[0]:3:3}${lines[1]:3:3}${lines[2]:3:3}
    returnSubSquares[2]=${lines[0]:6:3}${lines[1]:6:3}${lines[2]:6:3}
    returnSubSquares[3]=${lines[3]:0:3}${lines[4]:0:3}${lines[5]:0:3}
    returnSubSquares[4]=${lines[3]:3:3}${lines[4]:3:3}${lines[5]:3:3}
    returnSubSquares[5]=${lines[3]:6:3}${lines[4]:6:3}${lines[5]:6:3}
    returnSubSquares[6]=${lines[6]:0:3}${lines[7]:0:3}${lines[8]:0:3}
    returnSubSquares[7]=${lines[6]:3:3}${lines[7]:3:3}${lines[8]:3:3}
    returnSubSquares[8]=${lines[6]:6:3}${lines[7]:6:3}${lines[8]:6:3}
    echo ${returnSubSquares[@]}
}

check()
{
    local isOkay=true
    local bailOut=false
    local item=$1
    if [ "$(containsValidDigits $item)" != "true" ]; then
        (>&2 echo "ERROR: $item invalid characters found")
        isOkay=false
        bailOut=true
    fi
    if [ "$bailOut" == "false" ]; then
        if [ "$(isValidLine $item)" != "true" ]; then
            (>&2 echo "ERROR: $item is not a valid set")
            isOkay=false
        fi
    fi
    echo $isOkay
}

checkSet()
{
    local rows=($@)
    local i=0
    local isOkay=true
    for row in ${rows[@]}; do
        isValid=$(check $row)
        if [ "$isValid" != "true" ]; then
            isOkay=false
            (>&2 echo "ERROR: $row is not valid")
        fi
        (( i+=1 ))
    done
    if [ $i -lt 9 ]; then
        (>&2 echo "ERROR: row count ($i) less than 9")
        isOkay=false
    fi
    echo $isOkay
}

checkSquare()
{
    local squareFile=$1
    local rows
    local columns
    local subSquares
    local isValidSquare=true
    local isValidRows=true
    local isValidColumns=true
    local isValidSubSquares=true
    rows=($(lines $squareFile))
    isValidRows=$(checkSet ${rows[@]})
    if [ "$isValidRows" != "true" ]; then
        isValidSquare=false
        (>&2 echo "ERROR: row validation fails")
    fi
    columns=($(columns $squareFile))
    isValidColumns=$(checkSet ${columns[@]})
    if [ "$isValidColumns" != "true" ]; then
        isValidSquare=false
        (>&2 echo "ERROR: column validation fails")
    fi
    subSquares=($(subSquares $squareFile))
    isValidSubSquares=$(checkSet ${subSquares[@]})
    if [ "$isValidSubSquares" != "true" ]; then
        isValidSquare=false
        (>&2 echo "ERROR: sub-square validation fails")
    fi
    echo $isValidSquare
}