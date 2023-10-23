#include <stdio.h>

int main() {
	int n,sum,i;
	n = 10;
	sum = 1;
	i = 1;
	while(i <= n){
		sum *= i;
		i++;
	}
	printf("%d",sum);
	return 0;
}