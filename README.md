This is the dbt project that organizes the transformations for data related to supporting Strong Towns advocacy in Madison. Visit the docs page [here](https://madison-data.house/docs/#!/overview).

Reach out to Ben Noffke (bnoffke3790@gmail.com) if you're interested in contributing. You'll need a development schema created in our postgres database.

# Set Up
1. Run `install_dbt.sh` to get python if you don't have it and set up the dbt environment. This will also tell you which environment variables should be set for dbt.
    - This is only required when you first begin, but this will also update dbt for you.
    - You should create a DBT_USER and DBT_PASSWORD environment variables that match your postgres username/password.
2. Run `source ./dbt_start_dev.sh` to complete session set up steps (virtual environment, defer steps).
3. When you're done with development, clean up your dev schema by running `./clean_dev_schema.sh`.

# Documenting Models
We use dbt's docs blocks to hold column definitions to make them reusable across models. You can use the docs macro in your model's yml after updating `/docs/_docs.md`. This file was first meant to be used by AI to manage documentation, so it's just a big list.

# Review
Reach out to Ben to get review on your work for merging.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
