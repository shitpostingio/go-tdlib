# Fetch latest update for our repo
latest_repo_update=$(curl "https://api.github.com/repos/shitpostingio/go-tdlib/commits?path=Makefile&page=1&per_page=1" | jq -r ".[0].commit.author.date")
lru_date=$(date --date=$latest_repo_update +%s)

# 
latest_tdlib_update=$(curl "https://api.github.com/repos/tdlib/td/commits?path=td/generate/scheme/td_api.tl&page=1&per_page=1" | jq -r ".[0].commit.author.date")
ltu_date=$(date --date=$latest_tdlib_update +%s)

#
latest_tdlib_commit=$(curl "https://api.github.com/repos/tdlib/td/commits?&page=1&per_page=1" | jq -r ".[0].sha")
latest_tdlib_commit=${latest_tdlib_commit:0:7}

#
if [ $ltu_date -gt $lru_date ]; then

        #
        echo "Updating the generated code to tdlib commit $latest_tdlib_commit"

        # Remove the first line of the makefile
        sed -i 1d Makefile

        # Re-add the tag with the correct commit ID
        sed -i "1iTAG := $latest_tdlib_commit" Makefile

        # Generate code
        make schema-update
        make generate-json
        make generate-code

        # Push updates
        git config --global user.name 'Alessandro Pomponio'
        git config --global user.email '10339005+AlessandroPomponio@users.noreply.github.com'
        git commit -am "[AUTO] Update to latest TDlib build"
        git push

else
        echo "No update needed - see you next time 😀"
fi