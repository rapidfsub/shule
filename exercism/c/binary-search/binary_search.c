#include "binary_search.h"

const int *binary_search(int value, const int *arr, size_t length) {
  int i = 0;
  int j = length - 1;
  while (i < j) {
    int pivot = (i + j) / 2;
    if (arr[pivot] == value) {
      return &arr[pivot];
    } else if (arr[pivot] > value) {
      j = pivot - 1;
    } else {
      i = pivot + 1;
    }
  }

  if (i < (int)length && arr[i] == value) {
    return &arr[i];
  } else if (j >= 0 && arr[j] == value) {
    return &arr[j];
  } else {
    return NULL;
  }
}
