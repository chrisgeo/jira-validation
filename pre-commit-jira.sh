#!/bin/bash
JIRA_REGEX="[A-Z]+-[0-9]+"

# Check the commit message
commit_message=$(cat "$1")
if [[ ! $commit_message =~ $JIRA_REGEX ]]; then
    echo "Error: Commit message must include a JIRA issue ID (e.g., [PROJECT-123])."
    exit 1
fi

#!/bin/bash
JIRA_REGEX="[A-Z]+-[0-9]+"
JIRA_API="https://your-jira-domain.atlassian.net/rest/api/2/issue"
JIRA_USERNAME="your-jira-username"
JIRA_API_TOKEN="your-jira-api-token"

# Extract the JIRA issue ID from the commit message
commit_message=$(cat "$1")
JIRA_ISSUE=$(echo "$commit_message" | grep -oE "$JIRA_REGEX")

if [[ -z "$JIRA_ISSUE" ]]; then
    echo "Error: Commit message must include a JIRA issue ID (e.g., PROJECT-123)."
    exit 1
fi

# Validate JIRA issue existence
response=$(curl -s -o /dev/null -w "%{http_code}" -u "$JIRA_USERNAME:$JIRA_API_TOKEN" "$JIRA_API/$JIRA_ISSUE")
if [[ "$response" -ne 200 ]]; then
    echo "Error: JIRA issue $JIRA_ISSUE does not exist or is not accessible."
    exit 1
fi

echo "JIRA issue $JIRA_ISSUE is valid."
