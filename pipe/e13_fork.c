/*https://projecteuler.net/problem=13*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#define LENGTH 100
#define MNGFULDG 11
int main(){
    FILE *fp;
    char line[255];
    char digits[MNGFULDG + 1];
    unsigned long int numbers[LENGTH];


    fp = fopen("./e13.txt", "r");

    for (int i = 0; i < LENGTH; i++){
        fgets(line, 255, fp);
        strncpy(digits, line, MNGFULDG);
        numbers[i] = atol(digits);
    }


    int start, end;
    int fd[2];

    pipe(fd);

    int id = fork();

    if (id == 0){
        start = 0;
        end = start + LENGTH / 2;
    }
    else{
        start = LENGTH / 2;
        end = LENGTH;
    }

    unsigned long sum = 0;

    for (int i = start; i < end; i++)
    {
        sum += numbers[i];
    }

    if (id == 0){
        close(fd[0]);
        write(fd[1], &sum, sizeof(sum));
        close(fd[1]);
    }
    else{
        unsigned long childSum;
        close(fd[1]);
        read(fd[0], &childSum, sizeof(childSum));
        close(fd[0]);

        unsigned long totalSum = sum + childSum;
        printf("%Ld\n", totalSum);
    }


    fclose(fp);
    return 0;
}

