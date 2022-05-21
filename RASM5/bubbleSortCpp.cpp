// c++ program to sort an array using bubblesort
//
// input:
// a - array to sort
// length - length of the array
void BubbleSort (int a[], int length)
{
	int i, j, temp;
	
    for (i = 0; i < length; i++)
    {
        for (j = 0; j < length - i - 1; j++)
        {
            if (a[j + 1] < a[j])
            {
                temp = a[j];
                a[j] = a[j + 1];
                a[j + 1] = temp;
            }
        }
    }
}