#!/usr/env bash

read -rp "Personal Access Tokens: " TOKEN

if [ -z "$TOKEN" ]; then
	cat <<HELP

Personal Access Tokens is required to do any api calls.
More info here: https://docs.gitlab.com/ce/user/profile/personal_access_tokens.html

HELP
exit 1
fi

read -rp "Project's ID: " PROJECT_ID

if [ -z "$PROJECT_ID" ]; then
	cat <<HELP

Project's id is required to identify.
More info here: https://docs.gitlab.com/ee/api/projects.html

HELP
exit 1
fi

read -rp "Tag name you want to release: " GIT_TAG

if ! git rev-parse -q --verify "refs/tags/$GIT_TAG" 1> /dev/null; then
	cat <<HELP

Please specify a valid git tag you want to create release from.
More info here: https://git.dragonlaw.com.hk/help/user/project/releases/index

HELP
exit 1
fi

read -rp "Tag name of last release: " LAST_GIT_TAG
if ! git rev-parse -q --verify "refs/tags/$LAST_GIT_TAG" 1> /dev/null; then
	cat <<HELP

Please specify a valid git tag or do "git fetch --tags" beforhand.

HELP
exit 1
fi

curl \
	--header 'Content-Type: application/json' \
	--header "PRIVATE-TOKEN: $TOKEN" \
	--data "{\"name\": \"Release $GIT_TAG\", \"tag_name\": \"$GIT_TAG\", \"description\": \"## CHANGELOG\r\n$(git log $LAST_GIT_TAG..$GIT_TAG --no-merges --format='\r\n- %s (%h)' | tr -d '\n')\"}" \
	--request POST "https://git.dragonlaw.com.hk/api/v4/projects/$PROJECT_ID/releases"
