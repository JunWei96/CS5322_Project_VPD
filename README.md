# CS5322_Project

## Order of Scripts
If you are starting from a fresh database, here is the sequence of script you should run:
`schema.sql` > `load_data.sql` > `load_policies.sql`

If you are working on an existing database with existing data and you want to reset the database to its original form, you can run `reset.sql`.
After running reset, you need to run `prepare_auto_context_at_logon.sql` as well for the context to be created and triggered after login.

After you are done running the setup scripts, you can run the test cases by logging into the respective user's account and run their respective scripts there.
