#Start the venv
source ./.venv/bin/activate
echo "✅ Virtual environment activated"

#Prep prod's current state for defer
mkdir -p state
dbt compile --target prod
cp target/manifest.json state/
echo "✅ DBT state prepared for defer"

#Set env vars for defer
export DBT_DEFER=1
export DBT_STATE=./state
echo "✅ DBT_DEFER and DBT_STATE environment variables set"

echo "🎉 DBT development environment is ready!"