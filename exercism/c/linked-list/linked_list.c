#include "linked_list.h"

struct list_node {
  struct list_node *prev, *next;
  ll_data_t data;
};

struct list {
  struct list_node *first, *last;
};

struct list_node *node_create(ll_data_t item_data);
void node_link(struct list_node *lhs, struct list_node *rhs);
void node_unlink(struct list_node *lhs, struct list_node *rhs);

struct list *list_create(void) {
  struct list *result = malloc(sizeof(struct list));
  result->first = NULL;
  result->last = NULL;
  return result;
}

size_t list_count(const struct list *list) {
  size_t result = 0;
  struct list_node *curr = list->first;
  while (curr != NULL) {
    result += 1;
    curr = curr->next;
  }
  return result;
}

void list_push(struct list *list, ll_data_t item_data) {
  struct list_node *new_node = node_create(item_data);
  if (list->last == NULL) {
    list->first = new_node;
    list->last = new_node;
  } else {
    node_link(list->last, new_node);
    list->last = new_node;
  }
}

ll_data_t list_pop(struct list *list) {
  struct list_node *curr = list->last;
  if (curr == NULL) {
    return 0;
  }

  ll_data_t result = curr->data;
  if (curr->prev == NULL) {
    list->first = NULL;
    list->last = NULL;
  } else {
    list->last = curr->prev;
    node_unlink(curr->prev, curr);
  }
  free(curr);
  return result;
}

void list_unshift(struct list *list, ll_data_t item_data) {
  struct list_node *new_node = node_create(item_data);
  if (list->first == NULL) {
    list->first = new_node;
    list->last = new_node;
  } else {
    node_link(new_node, list->first);
    list->first = new_node;
  }
}

ll_data_t list_shift(struct list *list) {
  struct list_node *curr = list->first;
  if (curr == NULL) {
    return 0;
  }

  ll_data_t result = curr->data;
  if (curr->next == NULL) {
    list->first = NULL;
    list->last = NULL;
  } else {
    list->first = curr->next;
    node_unlink(curr, curr->next);
  }
  free(curr);
  return result;
}

void list_delete(struct list *list, ll_data_t data) {
  struct list_node *curr = list->first;
  while (curr != NULL) {
    if (curr->data == data) {
      if (curr == list->first) {
        list_shift(list);
      } else if (curr == list->last) {
        list_pop(list);
      } else {
        node_link(curr->prev, curr->next);
        free(curr);
      }
      return;
    } else {
      curr = curr->next;
    }
  }
}

void list_destroy(struct list *list) {
  while (list->last != NULL) {
    list_pop(list);
  }
  free(list);
}

struct list_node *node_create(ll_data_t item_data) {
  struct list_node *result = malloc(sizeof(struct list_node));
  result->prev = NULL;
  result->data = item_data;
  result->next = NULL;
  return result;
}

void node_link(struct list_node *lhs, struct list_node *rhs) {
  lhs->next = rhs;
  rhs->prev = lhs;
}

void node_unlink(struct list_node *lhs, struct list_node *rhs) {
  lhs->next = NULL;
  rhs->prev = NULL;
}
