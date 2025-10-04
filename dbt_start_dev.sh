#Start the venv
source ./.venv/bin/activate
echo "✅ Virtual environment activated"

export DBT_DEFER=""
export DBT_STATE=""
#Prep prod's current state for defer
dbt deps
dbt compile --target prod
mkdir -p state
cp target/manifest.json state/

#Set env vars for defer
export DBT_DEFER=1
export DBT_STATE=./state
echo "✅ DBT state prepared for defer"


echo "🎉 DBT development environment is ready!"