#
latest_makefile_update=$(git log -1 --pretty="format:%ct" Makefile)

#
git clone https://github.com/tdlib/td.git
latest_tdschema_update=$(cd td && git log -1 --pretty="format:%ct" td/generate/scheme/td_api.tl)
latest_commit=$(cd td && git log -1 --pretty="format:%h")

#
echo "Latest Makefile update: $(git log -1 --pretty="format:%ci" Makefile)"
echo "Latest td_api.tl update: $(cd td && git log -1 --pretty="format:%ci" td/generate/scheme/td_api.tl)"

#
rm -rf td

#
if [ $latest_tdschema_update -gt $latest_makefile_update ]; then

        #
        echo "Updating the generated code to tdlib commit $latest_commit"

        # Remove the first line of the makefile
        sed -i 1d Makefile

        # Re-add the tag with the correct commit ID
        sed -i "1iTAG := $latest_commit" Makefile

        #
        make schema-update
        make generate-json
        make generate-code
else
        echo "No update needed - see you next time 😀"
fi
