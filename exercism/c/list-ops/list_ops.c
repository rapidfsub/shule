#include "list_ops.h"

list_t *new_list(size_t length, list_element_t elements[]) {
  list_t *result = malloc(sizeof(list_t) + length * sizeof(list_element_t));
  result->length = length;

  if (elements != NULL) {
    for (size_t i = 0; i < length; i += 1) {
      result->elements[i] = elements[i];
    }
  }

  return result;
}

list_t *append_list(list_t *list1, list_t *list2) {
  size_t len_list1 = length_list(list1);
  size_t len_list2 = length_list(list2);
  list_t *result = new_list(len_list1 + len_list2, NULL);

  for (size_t i = 0; i < len_list1; i += 1) {
    result->elements[i] = list1->elements[i];
  }

  for (size_t i = 0; i < len_list2; i += 1) {
    result->elements[len_list1 + i] = list2->elements[i];
  }

  return result;
}

list_t *filter_list(list_t *list, bool (*filter)(list_element_t)) {
  size_t len = length_list(list);
  list_t *result = new_list(len, NULL);
  size_t len_filter = 0;

  for (size_t i = 0; i < len; i += 1) {
    if (filter(list->elements[i])) {
      result->elements[len_filter] = list->elements[i];
      len_filter += 1;
    }
  }

  result->length = len_filter;
  return result;
}

size_t length_list(list_t *list) { return list->length; }

list_t *map_list(list_t *list, list_element_t (*map)(list_element_t)) {
  size_t len = length_list(list);
  list_t *result = new_list(len, NULL);

  for (size_t i = 0; i < len; i += 1) {
    result->elements[i] = map(list->elements[i]);
  }

  return result;
}

list_element_t foldl_list(list_t *list, list_element_t initial,
                          list_element_t (*foldl)(list_element_t,
                                                  list_element_t)) {

  size_t len = length_list(list);
  list_element_t result = initial;

  for (size_t i = 0; i < len; i += 1) {
    result = foldl(result, list->elements[i]);
  }

  return result;
}

list_element_t foldr_list(list_t *list, list_element_t initial,
                          list_element_t (*foldr)(list_element_t,
                                                  list_element_t)) {
  size_t len = length_list(list);
  list_element_t result = initial;

  for (size_t i = 0; i < len; i += 1) {
    result = foldr(list->elements[len - i - 1], result);
  }

  return result;
}

list_t *reverse_list(list_t *list) {
  size_t len = length_list(list);
  list_t *result = new_list(len, NULL);

  for (size_t i = 0; i < len; i += 1) {
    result->elements[i] = list->elements[len - i - 1];
  }

  return result;
}

void delete_list(list_t *list) { free(list); }
