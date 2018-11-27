# sudoku validator in bash  
I have found this hugely enlightening! I don't believe you could do this in a month of Sundays unless you use some kind of TDD model. Here I am using shunit2 because I have used it in the past and I like it (https://github.com/kward/shunit2.git).

## usage so far
this is just an illustration of how one might go about this kind of stuff. so far, just source the sudokuSquare.sh file and use the checkSquare function with an arg of a text file containing exactly 9 lines of numbers representing the rows of a completed sudoku square
```
source sudokuSquare.sh
result=$(checkSquare path-to-square-file.txt)
if [ "$result" == "true" ]; then
    echo "we have a valid sudoku square!"
else
    echo "hard lines try again - hopefully there are some pointers in the error messages"
fi
```

## tests
the tests are not yet exhaustive but might, if nothing else, give some idea about how the thing has been contrived.