#Start the venv
source ./.venv/bin/activate
echo "✅ Virtual environment activated"

#Prep prod's current state for defer
mkdir -p state
export DBT_DEFER=1
export DBT_STATE=./state
dbt compile --target prod
cp target/manifest.json state/
echo "✅ DBT state prepared for defer"

#Set env vars for defer
echo "✅ DBT_DEFER and DBT_STATE environment variables set"

echo "🎉 DBT development environment is ready!"