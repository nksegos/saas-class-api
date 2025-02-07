#!/bin/bash
BASE_URL="http://localhost:3000"

function separator() {
  echo "=========================================="
}

separator
echo "1. Testing POST /signup (Signup)"
SIGNUP_RESPONSE=$(http --check-status POST $BASE_URL/signup \
  email="testuser@example.com" password="password" password_confirmation="password")
echo "Signup Response:"
echo "$SIGNUP_RESPONSE"
if echo "$SIGNUP_RESPONSE" | grep -qw "token"; then
  echo "ERROR: Signup response contains a token. It should only return user data."
  exit 1
else
  echo "PASS: Signup returned only user data."
fi

separator
echo "2. Testing POST /auth/login (Login)"
LOGIN_RESPONSE=$(http --check-status POST $BASE_URL/auth/login \
  email="testuser@example.com" password="password")
echo "Login Response:"
echo "$LOGIN_RESPONSE"
# Extract the token using jq (ensure jq is installed)
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token')
if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
  echo "ERROR: Login did not return a token."
  exit 1
else
  echo "PASS: Received token: $TOKEN"
fi

separator
echo "3. Testing GET /todos (List all todos, initially empty)"
TODOS_RESPONSE=$(http --check-status GET $BASE_URL/todos "Authorization:Bearer $TOKEN")
echo "Todos Response:"
echo "$TODOS_RESPONSE"

separator
echo "4. Testing POST /todos (Create a new todo)"
NEW_TODO_RESPONSE=$(http --check-status POST $BASE_URL/todos \
  "Authorization:Bearer $TOKEN" title="My First Todo")
echo "New Todo Response:"
echo "$NEW_TODO_RESPONSE"
# Extract the new todo ID
TODO_ID=$(echo "$NEW_TODO_RESPONSE" | jq -r '.id')
echo "New Todo ID: $TODO_ID"

separator
echo "5. Testing GET /todos/:id (Get the created todo)"
GET_TODO_RESPONSE=$(http --check-status GET $BASE_URL/todos/$TODO_ID "Authorization:Bearer $TOKEN")
echo "GET Todo Response:"
echo "$GET_TODO_RESPONSE"

separator
echo "6. Testing PUT /todos/:id (Update the todo)"
UPDATE_TODO_RESPONSE=$(http --check-status PUT $BASE_URL/todos/$TODO_ID \
  "Authorization:Bearer $TOKEN" title="Updated Todo Title")
echo "PUT Todo Response:"
echo "$UPDATE_TODO_RESPONSE"

separator
echo "7. Testing GET /todos (List all todos and their items)"
TODOS_LIST_RESPONSE=$(http --check-status GET $BASE_URL/todos "Authorization:Bearer $TOKEN")
echo "Todos List Response:"
echo "$TODOS_LIST_RESPONSE"

separator
echo "8. Testing POST /todos/:id/items (Create a new todo item)"
NEW_ITEM_RESPONSE=$(http --check-status POST $BASE_URL/todos/$TODO_ID/items \
  "Authorization:Bearer $TOKEN" title="New Todo Item" completed:=false)
echo "New Item Response:"
echo "$NEW_ITEM_RESPONSE"
# Extract the new item ID
ITEM_ID=$(echo "$NEW_ITEM_RESPONSE" | jq -r '.id')
echo "New Item ID: $ITEM_ID"

separator
echo "9. Testing GET /todos/:id/items/:iid (Get a specific todo item)"
GET_ITEM_RESPONSE=$(http --check-status GET $BASE_URL/todos/$TODO_ID/items/$ITEM_ID "Authorization:Bearer $TOKEN")
echo "GET Todo Item Response:"
echo "$GET_ITEM_RESPONSE"

separator
echo "10. Testing PUT /todos/:id/items/:iid (Update the todo item)"
UPDATE_ITEM_RESPONSE=$(http --check-status PUT $BASE_URL/todos/$TODO_ID/items/$ITEM_ID \
  "Authorization:Bearer $TOKEN" title="Updated Todo Item" completed:=true)
echo "PUT Todo Item Response:"
echo "$UPDATE_ITEM_RESPONSE"

separator
echo "11. Testing DELETE /todos/:id/items/:iid (Delete the todo item)"
DELETE_ITEM_RESPONSE=$(http --check-status DELETE $BASE_URL/todos/$TODO_ID/items/$ITEM_ID "Authorization:Bearer $TOKEN")
echo "DELETE Todo Item Response: (Expecting no content)"
echo "$DELETE_ITEM_RESPONSE"

separator
echo "12. Testing DELETE /todos/:id (Delete the todo and its items)"
DELETE_TODO_RESPONSE=$(http --check-status DELETE $BASE_URL/todos/$TODO_ID "Authorization:Bearer $TOKEN")
echo "DELETE Todo Response: (Expecting no content)"
echo "$DELETE_TODO_RESPONSE"

separator
echo "13. Testing GET /todos/:id (Confirm deletion, should return 404)"
http GET $BASE_URL/todos/$TODO_ID "Authorization:Bearer $TOKEN" || echo "PASS: Todo not found as expected."

separator
echo "14. Testing GET /auth/logout (Logout)"
LOGOUT_RESPONSE=$(http --check-status GET $BASE_URL/auth/logout "Authorization:Bearer $TOKEN")
echo "Logout Response:"
echo "$LOGOUT_RESPONSE"

separator
echo "15. Testing GET /todos after logout (should fail with unauthorized)"
http GET $BASE_URL/todos "Authorization:Bearer $TOKEN"

separator
echo "HTTPie API tests completed."

